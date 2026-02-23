import 'dart:async';
import 'dart:io';
import 'package:flutter/rendering.dart';
import 'package:go_router/go_router.dart';
import 'package:menderapp/core/theme/app_text_styles.dart';
import 'package:menderapp/core/widgets/app_button.dart';
import 'package:menderapp/core/widgets/app_form_group.dart';
import 'package:menderapp/core/widgets/app_text_field.dart';
import 'package:menderapp/features/services/image_service.dart';
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
  final userCredentialSetting = Hive.box(Storage.userCredentials);

  bool _isRecording = false;
  bool _isRecordingFinished = false;
  final usernameController = TextEditingController();
  final passwordController = TextEditingController();

  Color? backgroundColor = Colors.white;
  Timer? _timer;
  int _secondsLeft = 0;
  String _textDisplayCameraOverlay = '';
  final promotionSetting = Hive.box(Storage.promotionSetting);
  final _imageService = ImageService();

  File? previewLogo;
  @override
  void initState() {
    _initializeCamera();
    _startPreparationCountdown();
    loadImages();
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
      title: "",
      sidebar: Container(
        padding: EdgeInsetsGeometry.all(12),
        alignment: Alignment.center,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
                width: 150,
                height: 150,
                child: previewLogo == null ? SizedBox.shrink() :
                Image(image: FileImage(previewLogo!))
            ),
            SizedBox(height: 10,),

            AppFormGroup(label: "Username", child: AppTextField(controller: usernameController, name: 'username', inputType: TextInputType.text),),
            AppFormGroup(label: "Password",
              child: AppTextField(controller: passwordController, name: 'password',
                inputType: TextInputType.text, obscureText: true,),),
            AppButton(content: Text("Authenticate"), onPressed: _login)
          ],
        ),
      ),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final height = constraints.maxHeight;
          return Column(
            children: [
              Stack(
                alignment: Alignment.bottomRight,
                children: [
                  Container(
                    color: AppColor.white,
                    child: _cameraBuilder(),
                  ),
                  Align(
                    alignment: Alignment.bottomRight,
                    child: _secondsLeft != ''
                        ? Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: Colors.black54,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              "$_secondsLeft",
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 70,
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
        backgroundColor = AppColor.white;
      });
    } catch (e) {
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
      // Future.delayed(const Duration(seconds: 5));
      messenger.showSnackBar(
        SnackBar(
          duration: Duration(seconds: 5),
          backgroundColor: Colors.yellow,
          content: Text.rich(
            TextSpan(
              style: const TextStyle(color: Colors.black),
              children: [
                TextSpan(text: 'VIDEO SAVED \n', style: TextStyle(fontWeight: FontWeight.bold)),
                TextSpan(text: 'Thank you for sharing your dedication')
              ]
            ),
            textAlign: TextAlign.center,
          ),
        )
      );
      context.push('/landing-page');

    } catch (e) {
    }
  }

  void _startPreparationCountdown() {
    final videoRecordingSetting = Hive.box(Storage.videoRecordingSetting);
    final preparationDuration = videoRecordingSetting.get(
      'videoPreparationDuration',
      defaultValue: 4,
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

  Future<void> loadImages() async {
    final logo = await _imageService.loadPhoto(Storage.companyBranding, 'companyLogo');
    if(logo == null) return;

    setState(() {
      previewLogo = logo;
    });
  }

  void _login() {
    final credential = userCredentialSetting.get('credentials');
    if(usernameController.text == credential['username']) {
      if(passwordController.text == credential['password']) {
        context.push('/setting');
      }
    }
    passwordController.text = '';
  }
}
