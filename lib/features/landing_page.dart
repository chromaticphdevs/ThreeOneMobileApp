import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:go_router/go_router.dart';
import 'package:hive/hive.dart';
import 'package:menderapp/core/configurations/storage.dart';
import 'package:menderapp/core/theme/app_color.dart';
import 'package:menderapp/core/widgets/app_button.dart';
import 'package:menderapp/core/widgets/app_form_group.dart';
import 'package:menderapp/core/widgets/app_scaffold.dart';
import 'package:menderapp/core/widgets/app_text_field.dart';
import 'package:menderapp/features/common_widgets/sidebar.dart';
import 'package:menderapp/features/services/image_service.dart';
import 'package:path_provider/path_provider.dart';

class LandingPage extends ConsumerStatefulWidget {
  const LandingPage({super.key});

  @override
  ConsumerState<LandingPage> createState() => _LandingPage();
}

class _LandingPage extends ConsumerState<LandingPage> {
  final videoRecordingSetting = Hive.box(Storage.videoRecordingSetting);
  final promotionSetting = Hive.box(Storage.promotionSetting);
  final brandingSetting = Hive.box(Storage.companyBranding);
  final userCredentialSetting = Hive.box(Storage.userCredentials);

  final usernameController = TextEditingController();
  final passwordController = TextEditingController();
  final _imageService = ImageService();

  List<FileSystemEntity> _videos = [];

  File? _pictureOfTheDay;
  File? _companyWallpaper;
  File? previewLogo;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _loadPictureOfTheDay();
    _loadWallpaper();
    loadImages();
    _loadVideos();
  }
  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      wallpaper: _companyWallpaper,
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
      bottomNavigationBar: Container(
        alignment: Alignment.center,
        padding: EdgeInsetsGeometry.all(5),
        height: 50,
        color: AppColor.white,
        child: Text(brandingSetting.get('companyName', defaultValue: 'Company Name is not set'),
            textAlign: TextAlign.center,
        style: TextStyle(
          color: AppColor.black,
          fontWeight: FontWeight.bold
        ),),
      ),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final deviceHeight = constraints.maxHeight;
          return SingleChildScrollView(
            child: ConstrainedBox(
              constraints: BoxConstraints(
                minHeight: constraints.maxHeight,
                minWidth: constraints.maxWidth,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [

                  if(promotionSetting.get('textOfTheDay') != '') ... [
                    Container(
                      alignment: Alignment.center,
                      height: deviceHeight * .15,
                      child: SizedBox(
                        width: constraints.maxWidth,
                        child: Text(
                          promotionSetting
                              .get(
                            'textOfTheDay',
                            defaultValue: "Default text of the day!!",
                          )
                              .toString(),
                          style: TextStyle(
                            fontSize: 30,
                            fontWeight: FontWeight.w700,
                            color: Colors.deepOrange
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                  ],
                  Container(
                    alignment: Alignment.topCenter,
                    height: deviceHeight * .60,
                    child: SizedBox(
                        width: constraints.maxWidth,
                        child: _pictureOfTheDay == null ? SizedBox.shrink() :
                        Image(image: FileImage(_pictureOfTheDay!), fit: BoxFit.cover,)
                    ),
                  ),
                  SizedBox(
                    height: deviceHeight * .05,
                  ),
                  Container(
                    alignment: Alignment.center,
                    height: deviceHeight * .20,
                    child: InkWell(
                      child: CircleAvatar(radius: 50,
                        backgroundColor: AppColor.primary, foregroundColor: AppColor.white, child: const Text('START'),),
                      onTap: () {
                        if(videoRecordingSetting.get('maxRecordingDuration') == '' || videoRecordingSetting.get('maxRecordingDuration') < 1.0) {
                          Fluttertoast.showToast(
                            msg: "Set max recording duration in settings first",
                            toastLength: Toast.LENGTH_SHORT,
                            gravity: ToastGravity.BOTTOM,
                            timeInSecForIosWeb: 5,
                            backgroundColor: Colors.black87,
                            textColor: Colors.white,
                            fontSize: 14.0,
                          );
                          return;
                        }
                        context.push('/video-capturing');
                      },
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Future<void> _loadPictureOfTheDay () async {
    final pictureOfTheDay = await _imageService.loadPhoto(Storage.promotionSetting, 'pictureOfTheDay');
    if(pictureOfTheDay == null) return;

    setState(() {
      _pictureOfTheDay = pictureOfTheDay;
    });
  }

  Future<void> _loadWallpaper () async {
    final pictureOfTheDay = await _imageService.loadPhoto(Storage.promotionSetting, 'companyWallpaper');
    if(pictureOfTheDay == null) return;
    setState(() {
      _companyWallpaper = pictureOfTheDay;
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

  Future<void> loadImages() async {
    final logo = await _imageService.loadPhoto(Storage.companyBranding, 'companyLogo');
    if(logo == null) return;

    setState(() {
      previewLogo = logo;
    });
  }

  Future<void> _loadVideos() async {
    final dir = await getApplicationDocumentsDirectory();
    final files =
    dir.listSync().where((f) => f.path.endsWith('.mp4')).toList();
    setState(() => _videos = files);
  }
}
