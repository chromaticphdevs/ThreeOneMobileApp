import 'dart:io';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';

class VideoRecorderPage extends StatefulWidget {
  const VideoRecorderPage({super.key});

  @override
  State<VideoRecorderPage> createState() => _VideoRecorderPageState();
}

class _VideoRecorderPageState extends State<VideoRecorderPage> {
  CameraController? _controller;
  bool _isRecording = false;
  late CameraDescription _frontCamera;

  @override
  void initState() {
    super.initState();
    _initCamera();
  }

  Future<void> _initCamera() async {
    final cameras = await availableCameras();
    _frontCamera = cameras.firstWhere(
          (camera) => camera.lensDirection == CameraLensDirection.front,
    );

    _controller = CameraController(
      _frontCamera,
      ResolutionPreset.high,
      enableAudio: true,
    );

    await _controller!.initialize();
    if (!mounted) return;
    setState(() {});
  }

  Future<String> _getFilePath() async {
    final dir = await getApplicationDocumentsDirectory();
    final filePath = path.join(
      dir.path,
      'video_${DateTime.now().millisecondsSinceEpoch}.mp4',
    );
    return filePath;
  }

  Future<void> _startRecording() async {
    if (_controller == null || _controller!.value.isRecordingVideo) return;

    final filePath = await _getFilePath();
    try {
      await _controller!.startVideoRecording();
      setState(() => _isRecording = true);
    } catch (e) {
      print('Error starting video recording: $e');
    }
  }

  Future<void> _stopRecording() async {
    if (_controller == null || !_controller!.value.isRecordingVideo) return;

    try {
      // Stop recording and get XFile
      final XFile file = await _controller!.stopVideoRecording();
      setState(() => _isRecording = false);

      // Move file to documents folder
      final savePath = await _getFilePath();
      await file.saveTo(savePath);

      print('Video saved at: $savePath'); // <-- check here
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Video saved at: $savePath')),
      );
    } catch (e) {
      print('Error stopping video recording: $e');
    }
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_controller == null || !_controller!.value.isInitialized) {
      return const Center(child: CircularProgressIndicator());
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Record Video')),
      body: Stack(
        children: [
          CameraPreview(_controller!),
          Positioned(
            bottom: 30,
            left: MediaQuery.of(context).size.width / 2 - 35,
            child: FloatingActionButton(
              backgroundColor: _isRecording ? Colors.red : Colors.green,
              child: Icon(_isRecording ? Icons.stop : Icons.videocam),
              onPressed: _isRecording ? _stopRecording : _startRecording,
            ),
          ),
        ],
      ),
    );
  }
}
