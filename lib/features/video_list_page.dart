import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:go_router/go_router.dart';
import 'package:menderapp/core/widgets/app_button.dart';
import 'package:menderapp/core/widgets/app_button_text.dart';
import 'package:menderapp/core/widgets/app_scaffold.dart';
import 'package:menderapp/features/common_widgets/sidebar.dart';
import 'package:menderapp/features/services/image_service.dart';
import 'package:menderapp/features/video_player_page.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as pathx;
class VideoListPage extends ConsumerStatefulWidget{
  const VideoListPage({super.key});

  @override
  ConsumerState<VideoListPage> createState() => _VideoListPage();
}

class _VideoListPage extends ConsumerState<VideoListPage> {
  List<FileSystemEntity> _videos = [];
  ImageService imageService = ImageService();

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
          Text("last sync : 8:30 AM, 24 files uploaded"),
          SizedBox(height: 20,),
          _videos.isEmpty ? const Center(child: Text('No Videos'),) :
          Expanded(child: ListView.builder(
            itemCount: _videos.length,
            itemBuilder: (context, index) {
              final file = _videos[index];
              return ListTile(
                leading: const Icon(Icons.videocam),
                title: Text(file.path.split('/').last),
                onTap: () => _playVideo(File(file.path)),
                onLongPress: ()=> _confirmDelete(context, File(file.path), index),
              );
            },
          ))
        ],
      )
    );
  }

  void _playVideo(File file) {
    context.push('/video-player', extra: file);
  }

  Future<void> _loadVideos() async {
    final dir = await getApplicationDocumentsDirectory();
    final files =
    dir.listSync().where((f) => f.path.endsWith('.mp4')).toList();
    setState(() => _videos = files);
  }


  Future<void> _confirmDelete(BuildContext context, File file, int index) async {
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

  Future<void> _deleteItem(File file, int index) async{
    await imageService.deleteFile(file);
    setState(() {
      _videos.removeAt(index);
    });
  }

  Future<void> _empty() async{
    final dir = await getApplicationDocumentsDirectory();
    if (await dir.exists()) {
      await for (final entity in dir.list(recursive: true)) {
        if(entity is File) {
          if(pathx.extension(entity.path.toLowerCase()) == '.mp4') {
            try {
              await entity.delete(recursive: true);
            } catch (_) {}
          }
        }
      }
    }
  }

  Future<void> _sync() async{
    Fluttertoast.showToast(
      msg: "Only Available in paid version",
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 2,
      backgroundColor: Colors.black87,
      textColor: Colors.white,
      fontSize: 14.0,
    );
  }
}

