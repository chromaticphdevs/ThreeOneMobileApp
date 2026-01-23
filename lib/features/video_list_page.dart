import 'dart:io' as io;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:go_router/go_router.dart';
import 'package:hive/hive.dart';
import 'package:menderapp/core/configurations/storage.dart';
import 'package:menderapp/core/theme/app_text_styles.dart';
import 'package:menderapp/core/widgets/app_button.dart';
import 'package:menderapp/core/widgets/app_button_text.dart';
import 'package:menderapp/core/widgets/app_scaffold.dart';
import 'package:menderapp/features/common_widgets/sidebar.dart';
import 'package:menderapp/features/services/image_service.dart';
import 'package:menderapp/features/video_player_page.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as pathx;
import 'package:http/http.dart' as httpx;


import 'package:google_sign_in/google_sign_in.dart';
import 'package:googleapis_auth/auth_io.dart';
import 'package:googleapis/drive/v3.dart' as drive;

class VideoListPage extends ConsumerStatefulWidget{
  const VideoListPage({super.key});

  @override
  ConsumerState<VideoListPage> createState() => _VideoListPage();
}

class _VideoListPage extends ConsumerState<VideoListPage> {
  final videoRecordingSetting = Hive.box(Storage.videoRecordingSetting);
  List<io.FileSystemEntity> _videos = [];
  ImageService imageService = ImageService();

  final _googleSignIn = GoogleSignIn(
    scopes: ['https://www.googleapis.com/auth/drive.file']
  );

  bool _isAuthenticated = false;
  bool _isUploading = false;
  bool _syncInProgress = false;

  String _uploadingStatus = '';
  String? _google_drive_link;

  @override
  void initState() {
    _loadVideos();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      title: 'Videos',
      sidebar: buildSidebar(context),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              AppButton(content: AppButtonText(text: "Sync"), onPressed: _sync),
              AppButton(content: AppButtonText(text: "Empty"), onPressed: _empty),
            ],
          ),
          SizedBox(height: 5,),
          if(_uploadingStatus.isNotEmpty) ... [
            TextButton(onPressed: () {
              setState(() {
                _uploadingStatus = "";
              });
            }, child: Text(_uploadingStatus, style: AppTextStyles.formLabel,))
          ],
          SizedBox(height: 20,),
          _videos.isEmpty ? const Center(child: Text('No Videos'),) :
          Expanded(child: ListView.builder(
            itemCount: _videos.length,
            itemBuilder: (context, index) {
              final file = _videos[index];
              return ListTile(
                leading: const Icon(Icons.videocam),
                title: Text(file.path.split('/').last),
                onTap: () => _playVideo(io.File(file.path)),
                onLongPress: ()=> _confirmDelete(context, io.File(file.path), index),
              );
            },
          ))
        ],
      )
    );
  }

  void _playVideo(io.File file) {
    context.push('/video-player', extra: file);
  }

  Future<void> _loadVideos() async {
    final dir = await getApplicationDocumentsDirectory();
    final files =
    dir.listSync().where((f) => f.path.endsWith('.mp4')).toList();
    setState(() => _videos = files);
  }


  Future<void> _confirmDelete(BuildContext context, io.File file, int index) async {
    if (!context.mounted) return;

    final bool shouldDelete = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Delete item?'),
        content: const Text(
          'This action cannot be undone.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
            ),
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Delete'),
          ),
        ],
      ),
    ) ??
        false;

    if (!shouldDelete || !context.mounted) return;

    _deleteItem(file, index);
  }

  Future<void> _deleteItem(io.File file, int index) async{
    await imageService.deleteFile(file);
    setState(() {
      _videos.removeAt(index);
    });
  }

  Future<void> _empty() async{
    final dir = await getApplicationDocumentsDirectory();
    if (await dir.exists()) {
      await for (final entity in dir.list(recursive: true)) {
        if(entity is io.File) {
          if(pathx.extension(entity.path.toLowerCase()) == '.mp4') {
            try {
              await entity.delete(recursive: true);
            } catch (_) {}
          }
        }
      }
    }

    _loadVideos();
  }

  Future<void> _sync() async{
    if(_syncInProgress) return;

    setState(() {
      _syncInProgress = true;
    });
    if(_isUploading) {
      setState(() {
        _syncInProgress = false;
      });
      return;
    }
    final driverAPI = await _authenticate();

    if(!_isAuthenticated) {
      setState(() {
        _syncInProgress = false;
      });
      return;
    }

    await _uploadVideos(driverAPI);
    setState(() {
      _syncInProgress = false;
    });
  }

  Future<dynamic> _authenticate() async {
    final account = await _googleSignIn.signIn();
    if (account == null) {
      setState(() {
        _isAuthenticated = false;
        _uploadingStatus = "Sign-in Cancelled, Unable to process google Account";
      });
      return;
    }
    setState(() {
      _isAuthenticated = true;
      _uploadingStatus = "Signed In, Working to upload your files ...";
    });
    final authHeaders = await account.authHeaders;
    final expiry = DateTime.now().toUtc().add(const Duration(hours: 1));
    final client = authenticatedClient(
      httpx.Client(),
      AccessCredentials(
        AccessToken(
          'Bearer',
          authHeaders['Authorization']!.split(' ').last,
          expiry,
        ),
        null,
        ['https://www.googleapis.com/auth/drive.file'],
      ),
    );

    final driveApi = drive.DriveApi(client);
    return driveApi;
  }

  Future<void> _uploadVideos(dynamic googleDriveApi) async {
    final googleDriveLink = videoRecordingSetting.get('googleDrinkLink').toString();
    if(googleDriveLink == '') {
      setState(() {
        _uploadingStatus = "Google drive link is not set";
      });
      return;
    }
    setState(() {
      _uploadingStatus = "Trying to upload";
    });
    final folderId = extractFolderId(googleDriveLink);

    if(_videos.isEmpty) {
      setState(() {
        _uploadingStatus = "No Videos to import";
      });
      return;
    }
    for(final video in _videos) {
      final videoFile = io.File(video.path);
      final String originalPath = videoFile.path;
      final String fileName = originalPath.split('/').last;
      // Prevent double-prefixing
      if (fileName.startsWith('synced_')) {
        //skip since video is already uploaded
        continue;
      }

      setState(() {
        _isUploading = true;
        _uploadingStatus = "Uploading ${video.path.split('/').last}";
      });

      await googleDriveApi.files.create(
          drive.File()
            ..name = video.path.split('/').last
            ..parents = [folderId],
          uploadMedia: drive.Media(
              videoFile.openRead(),
              await videoFile.length(),
              contentType: 'video/mp4'
          )
      );

      setState(() {
        _uploadingStatus = "Uploaded! ${video.path.split('/').last}";
      });

      final String newPath =
      originalPath.replaceFirst(fileName, 'synced_$fileName');

      await videoFile.rename(newPath);
    }

    await _loadVideos();
    setState(() {
      _uploadingStatus = "Upload Complete!";
      _isUploading = false;
    });
  }

  String extractFolderId(String link) {
    final uri = Uri.parse(link);
    final segments = uri.pathSegments;
    final index = segments.indexOf('folders');
    if (index != -1 && segments.length > index + 1) {
      return segments[index + 1];
    }
    return '';
  }
}

