

import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:googleapis_auth/auth_io.dart';
import 'package:googleapis/drive/v3.dart' as drive;
import 'package:menderapp/core/widgets/app_scaffold.dart';
import 'package:menderapp/features/common_widgets/sidebar.dart';
import 'package:path_provider/path_provider.dart';
import 'package:http/http.dart' as http;
import 'dart:io' as io;


class GoogleDriveFilePage extends StatefulWidget {
  const GoogleDriveFilePage({super.key});

  @override
  State<GoogleDriveFilePage> createState() => _GoogleDriveFilePageState();
}

class _GoogleDriveFilePageState extends State<GoogleDriveFilePage> {
  final _googleSignIn = GoogleSignIn(
    scopes: ['https://www.googleapis.com/auth/drive.file'],
  );

  String _status = "";
  bool _uploading = false;

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      sidebar: buildSidebar(context),
      floatingActionButton: ElevatedButton(
        onPressed: _authenticateUser,
        child: Text("+"),
      ),
      child: Center(child: Text("Sample . $_status")),
    );
  }

  Future<void> _authenticateUser() async {
    final account = await _googleSignIn.signIn();
    if (account == null) {
      setState(() {
        _status = "Sign-in Cancelled, Unable to process google Account";
      });

      return;
    }
    final authHeaders = await account.authHeaders;
    final expiry = DateTime.now().toUtc().add(const Duration(hours: 1));
    final client = authenticatedClient(
      http.Client(),
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
    await _uploadVideos(driveApi);
  }

  Future<void> _uploadVideos(dynamic googleDriveApi) async {
    final loadVideos = await _loadVideos();
    final folderId = extractFolderId("https://drive.google.com/drive/folders/163so5_7safIfsqBpiD6KwXIVkvw7tylW");

    if(loadVideos.isEmpty) {
      setState(() {
        _uploading = false;
        _status = " No Videos found locally";
      });
      return;
    }

    for(final video in loadVideos) {
      setState(() {
        _status = "Uploading ${video.path.split('/').last}";
      });


      await googleDriveApi.files.create(
        drive.File()
            ..name = video.path.split('/').last
            ..parents = [folderId],
        uploadMedia: drive.Media(
          video.openRead(),
          await video.length(),
          contentType: 'video/mp4'
        )
      );
    }
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

  Future<List<io.File>> _loadVideos() async {
    final List<io.File> videoFiles = [];
    final dir = await getApplicationDocumentsDirectory();
    for (final entity in dir.listSync(recursive: true)) {
      if (entity is io.File && entity.path.endsWith('.mp4')) {
        videoFiles.add(io.File(entity.path));
      }
    }
    return videoFiles;
  }
}
