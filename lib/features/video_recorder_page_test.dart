import 'dart:io';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';

class VideoRecorderPage extends StatefulWidget {
  const VideoRecorderPage({super.key});

  @override
  _VideoRecorderPageState createState() => _VideoRecorderPageState();
}

class _VideoRecorderPageState extends State<VideoRecorderPage> {
  CameraController? _controller;
  late List<CameraDescription> _cameras;
  bool _isRecording = false;

  @override
  void initState() {
    super.initState();
    _initializeCamera();
  }

  Future<void> _initializeCamera() async {
    _cameras = await availableCameras();
    // Select front camera
    final frontCamera = _cameras.firstWhere(
          (camera) => camera.lensDirection == CameraLensDirection.front,
    );

    _controller = CameraController(
      frontCamera,
      ResolutionPreset.high,
      enableAudio: true,
    );

    await _controller!.initialize();
    if (!mounted) return;
    setState(() {});
  }

  Future<void> _startRecording() async {
    if (_controller == null || _controller!.value.isRecordingVideo) return;

    final Directory extDir = await getTemporaryDirectory();
    final String filePath =
    path.join(extDir.path, '${DateTime.now().millisecondsSinceEpoch}.mp4');

    try {
      await _controller!.startVideoRecording();
      setState(() {
        _isRecording = true;
      });
    } catch (e) {
      print('Error starting video recording: $e');
    }
  }

  Future<void> _stopRecording() async {
    if (_controller == null || !_controller!.value.isRecordingVideo) return;

    try {
      final XFile file = await _controller!.stopVideoRecording();
      setState(() {
        _isRecording = false;
      });
      print('Video saved to ${file.path}');
      // You can now play the video or upload it
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
      appBar: AppBar(title: const Text('Video Recorder')),
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
