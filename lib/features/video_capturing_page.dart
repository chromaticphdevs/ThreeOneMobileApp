import 'dart:async';
import 'package:flutter/rendering.dart';
import 'package:go_router/go_router.dart';
import 'package:menderapp/core/theme/app_text_styles.dart';
import 'package:path/path.dart' as path;
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:menderapp/core/configurations/storage.dart';
import 'package:menderapp/core/theme/app_color.dart';
import 'package:menderapp/core/widgets/app_scaffold.dart';
import 'package:menderapp/features/common_widgets/sidebar.dart';
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';

class VideoCapturingPage extends ConsumerStatefulWidget {
  const VideoCapturingPage({super.key});

  @override
  ConsumerState<VideoCapturingPage> createState() => _VideoCapturingPage();
}

class _VideoCapturingPage extends ConsumerState<VideoCapturingPage> {
  CameraController? _cameraController;
  late CameraDescription _frontCamera;

  bool _isRecording = false;
  bool _isRecordingFinished = false;

  Color? backgroundColor = Colors.white;
  Timer? _timer;
  int _secondsLeft = 0;
  String _textDisplayCameraOverlay = '';
  final promotionSetting = Hive.box(Storage.promotionSetting);
  @override
  void initState() {
    _initializeCamera();
    _startPreparationCountdown();
    // TODO: implement initState
    super.initState();
  }

  @override
  void dispose() {
    _timer?.cancel();
    _cameraController?.dispose();
    super.dispose();
  }

  Future<void> _initializeCamera() async {
    final cameras = await availableCameras();
    _frontCamera = cameras.firstWhere(
      (camera) => camera.lensDirection == CameraLensDirection.front,
    );

    _cameraController = CameraController(
      _frontCamera,
      ResolutionPreset.high,
      enableAudio: true,
    );

    await _cameraController!.initialize();
    if (!mounted) return;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      backgroundColor: backgroundColor,
      title: "Video Recording page",
      sidebar: buildSidebar(context),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final height = constraints.maxHeight;
          return Column(
            children: [
              if(_isRecording) ... [
                Text("$_secondsLeft", style: AppTextStyles.formTitle,)
              ],
              Stack(
                alignment: Alignment.center,
                children: [
                  Container(
                    height: height * .80,
                    width: constraints.maxWidth,
                    color: AppColor.info,
                    child: _cameraBuilder(),
                  ),
                  Align(
                    alignment: Alignment.center,
                    child: _textDisplayCameraOverlay != ''
                        ? Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: Colors.black54,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              "$_textDisplayCameraOverlay",
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 40,
                              ),
                            ),
                          )
                        : const SizedBox.shrink(),
                  ),
                ],
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _cameraBuilder() {
    if (_cameraController == null) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_cameraController!.value.hasError) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error, color: Colors.red, size: 48),
            const SizedBox(height: 12),
            Text(
              'Camera error:\n${_cameraController!.value.errorDescription}',
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _initializeCamera,
              child: const Text('Retry'),
            ),
          ],
        ),
      );
    }

    if (!_cameraController!.value.isInitialized) {
      return const Center(child: CircularProgressIndicator());
    }

    return CameraPreview(_cameraController!);
  }

  Widget wTextButton({
    required VoidCallback onPressed,
    required String text,
    required Color color,
    Color colorForeGround = AppColor.white,
  }) {
    return TextButton(
      onPressed: onPressed,
      style: TextButton.styleFrom(
        backgroundColor: color,
        foregroundColor: colorForeGround,
      ),
      child: Text(text),
    );
  }

  Future<void> _startRecording() async {
    if (_cameraController == null) return;
    if (!_cameraController!.value.isInitialized) return;
    if (_cameraController!.value.isRecordingVideo) return;

    try {
      await _cameraController!.startVideoRecording();
      setState(() {
        _isRecording = true;
        backgroundColor = AppColor.highlight;
      });
    } catch (e) {
      debugPrint('Start recording error: $e');
    }
  }

  Future<void> _stopRecording() async {
    if (_cameraController == null) return;
    if (!_cameraController!.value.isRecordingVideo) return;
    _timer?.cancel();

    try {
      final XFile file = await _cameraController!.stopVideoRecording();
      setState(() {
        _secondsLeft = 0;
        _isRecording = false;
        _isRecordingFinished = true;
      });

      final savePath = await _getFilePath();
      await file.saveTo(savePath);

      if(!mounted) return;

      final messenger = ScaffoldMessenger.of(context);
      messenger.showSnackBar(SnackBar(content: Text('Video saved at:\n$savePath')));
      Future.delayed(const Duration(seconds: 2));

      if(!mounted) return;
      context.push('/landing-page');

    } catch (e) {
      debugPrint('Stop recording error: $e');
    }
  }

  void _startPreparationCountdown() {
    final videoRecordingSetting = Hive.box(Storage.videoRecordingSetting);
    final preparationDuration = videoRecordingSetting.get(
      'preparationDuration',
      defaultValue: 8,
    );
    _secondsLeft = preparationDuration;

    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_secondsLeft <= 0) {
        setState(() {
          _textDisplayCameraOverlay = "";
        });
        timer.cancel();

        _startCapturingCountdown();
      } else {
        setState(() {
          _secondsLeft--;
          if (_secondsLeft <= 3 && _secondsLeft >= 1) {
            _textDisplayCameraOverlay = "Ready $_secondsLeft s";
          } else {
            _textDisplayCameraOverlay = "$_secondsLeft";
          }
        });
      }
    });
  }

  void _startCapturingCountdown() {
    final videoRecordingSetting = Hive.box(Storage.videoRecordingSetting);
    final preparationDuration = videoRecordingSetting.get(
      'maxRecordingDuration',
    );
    _secondsLeft = preparationDuration;
    _startRecording();

    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_secondsLeft <= 0) {
        setState(() {
          _textDisplayCameraOverlay = "";
        });
        timer.cancel();
        _stopRecording();
      } else {
        setState(() {
          _secondsLeft--;
          if (_secondsLeft <= 3 && _secondsLeft >= 1) {
            _textDisplayCameraOverlay = "$_secondsLeft";
          } else {}
        });
      }
    });
  }

  Future<String> _getFilePath() async {
    final dir = await getApplicationDocumentsDirectory();
    final filePath = path.join(
      dir.path,
      'video_${DateTime.now().millisecondsSinceEpoch}.mp4',
    );
    return filePath;
  }
}
