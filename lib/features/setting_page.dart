import 'dart:io';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:hive/hive.dart';
import 'package:image_picker/image_picker.dart';
import 'package:menderapp/core/configurations/storage.dart';
import 'package:menderapp/core/theme/app_color.dart';
import 'package:menderapp/core/theme/app_text_styles.dart';
import 'package:menderapp/core/utilities/googledrive_source_converter.dart';
import 'package:menderapp/core/widgets/app_button.dart';
import 'package:menderapp/core/widgets/app_form_group.dart';
import 'package:menderapp/core/widgets/app_scaffold.dart';
import 'package:menderapp/core/widgets/app_text_field.dart';
import 'package:menderapp/features/common_widgets/sidebar.dart';
import 'package:menderapp/features/services/image_service.dart';

class SettingPage extends ConsumerStatefulWidget {
  const SettingPage({super.key});
  @override
  ConsumerState<SettingPage> createState() => _SettingPage();
}

class _SettingPage extends ConsumerState<SettingPage> {
  final _videoDurationController = TextEditingController();
  final _videoPreparationDurationController = TextEditingController();
  final _googleDriveLinkController = TextEditingController();

  final _textOfTheDayController = TextEditingController();
  final _pictureOfTheDayController = TextEditingController();
  final _companyNameController = TextEditingController();

  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();

  final videoRecordingSetting = Hive.box(Storage.videoRecordingSetting);
  final brandingSetting = Hive.box(Storage.companyBranding);
  final credentialSetting = Hive.box(Storage.userCredentials);
  final promotionSetting = Hive.box(Storage.promotionSetting);

  final imageService = ImageService();

  File? previewPictureOfTheDayImage;
  File? previewCompanyLogo;
  File? previewWallpaper;

  @override
  void initState() {
    // TODO: implement initState
    _loadInitialData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    return AppScaffold(
      resizeToAvoidBottomInset: false,
      sidebar: buildSidebar(context),
      title: "Settings",
      child: SingleChildScrollView(
        child: CarouselSlider(
          options: CarouselOptions(
            height: screenHeight,
            viewportFraction: 1,
            enlargeCenterPage: false,
            scrollPhysics: BouncingScrollPhysics(),
          ),
          items: [
            Container(
              padding: EdgeInsetsGeometry.all(10),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text("Promotion Page", style: AppTextStyles.formTitle),
                  SizedBox(height: 30),
                  AppFormGroup(
                    label: "Word of the day",
                    child: AppTextField(
                      controller: _textOfTheDayController,
                      name: "text_of_the_day",
                      inputType: TextInputType.text,
                      placeholder: "Text of the day",
                    ),
                  ),

                  AppFormGroup(
                    label: "Upload picture of the day",
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        AppButton(
                          content: Text("Upload Photo"),
                          onPressed: _selectPictureOfTheDayPhoto,
                        ),

                        AppButton(
                          content: Text("Show Current"),
                          onPressed: () async {
                            final currentPhoto = await imageService.loadPhoto(
                              Storage.promotionSetting,
                              'pictureOfTheDay',
                            );
                            if(currentPhoto != null) {
                              setState(() {
                                if(previewPictureOfTheDayImage == null) {
                                  previewPictureOfTheDayImage = currentPhoto;
                                } else {
                                  previewPictureOfTheDayImage = null;
                                }
                              });
                            }
                          },
                        ),
                      ],
                    ),
                  ),
                  if (previewPictureOfTheDayImage != null) ...[
                    SizedBox(
                      width: 150,
                      height: 150,
                      child: Image(
                        image: FileImage(previewPictureOfTheDayImage!),
                      ),
                    ),
                    TextButton(
                      onPressed: _removePictureOfTheDayImage,
                      child: Text("Remove"),
                    ),
                  ],

                  AppFormGroup(
                    label: "Company Wallpaper",
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        AppButton(
                          content: Text("Upload Wallpaper"),
                          onPressed: _selectWallpaper,
                        ),
                        AppButton(
                          content: Text("Show Current"),
                          onPressed: () async {
                            final currentPhoto = await imageService.loadPhoto(
                              Storage.promotionSetting,
                              'companyWallpaper',
                            );

                            if(currentPhoto != null) {
                              setState(() {
                                if(previewWallpaper == null) {
                                  previewWallpaper = currentPhoto;
                                } else {
                                  previewWallpaper = null;
                                }
                              });
                            }
                          },
                        ),
                      ],
                    ),
                  ),
                  if (previewWallpaper != null) ...[
                    SizedBox(
                      width: 150,
                      height: 150,
                      child: Image(
                        image: FileImage(previewWallpaper!),
                      ),
                    ),
                    TextButton(
                      onPressed: _removeWallpaper,
                      child: Text("Remove"),
                    ),
                  ],

                  Divider(),
                  AppFormGroup(
                    label: '',
                    child: AppButton(
                      content: Text("Save"),
                      onPressed: _savePromotionSetting,
                      isFullWidth: true,
                    ),
                  ),
                ],
              ),
            ),

            Container(
              padding: EdgeInsetsGeometry.all(10),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text("Branding", style: AppTextStyles.formTitle),
                  SizedBox(height: 30),
                  AppFormGroup(
                    label: "Company Name",
                    child: AppTextField(
                      controller: _companyNameController,
                      name: "company_name",
                      inputType: TextInputType.text,
                      placeholder: "Company Name",
                    ),
                  ),

                  SizedBox(height: 30),

                  AppFormGroup(
                    label: "Company Logo",
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        AppButton(
                          content: Text("Upload Logo"),
                          onPressed: _selectCompanyLogo,
                        ),
                        AppButton(
                          content: Text("Show Current"),
                          onPressed: () async {
                            final currentPhoto = await imageService.loadPhoto(
                              Storage.companyBranding,
                              'companyLogo',
                            );

                            if(currentPhoto != null) {
                              setState(() {
                                if(previewCompanyLogo == null) {
                                  previewCompanyLogo = currentPhoto;
                                } else {
                                  previewCompanyLogo = null;
                                }
                              });
                            }
                          },
                        ),
                      ],
                    ),
                  ),

                  if (previewCompanyLogo != null) ...[
                    SizedBox(
                      width: 150,
                      height: 150,
                      child: Image(image: FileImage(previewCompanyLogo!)),
                    ),
                    TextButton(
                      onPressed: _removeCompanyLogo,
                      child: Text("Remove"),
                    ),
                  ],
                  Divider(),
                  AppButton(
                    content: Text("Save"),
                    onPressed: _saveBranding,
                    isFullWidth: true,
                  ),
                ],
              ),
            ),

            Container(
              padding: EdgeInsetsGeometry.all(10),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                    "Video Storage and Duration Settings",
                    style: AppTextStyles.formTitle,
                  ),
                  SizedBox(height: 30),
                  AppFormGroup(
                    label: "Video Duration",
                    child: AppTextField(
                      controller: _videoDurationController,
                      name: "video_duration",
                      inputType: TextInputType.number,
                      placeholder: "Duration in seconds",
                    ),
                  ),
                  AppFormGroup(
                    label: "Preparation Duration",
                    child: AppTextField(
                      controller: _videoPreparationDurationController,
                      name: "preparation_duration",
                      inputType: TextInputType.number,
                      placeholder: "Duration in seconds",
                    ),
                  ),

                  AppFormGroup(
                    label: "Google Drive link",
                    child: AppTextField(
                      controller: _googleDriveLinkController,
                      name: "google_drive_link",
                      inputType: TextInputType.text,
                      placeholder: "Google Drive link",
                    ),
                  ),
                  SizedBox(height: 15),
                  Divider(),
                  AppFormGroup(
                    label: '',
                    child: AppButton(
                      content: Text("Save"),
                      onPressed: _saveVideoSettings,
                      isFullWidth: true,
                    ),
                  ),
                ],
              ),
            ),

            Container(
              padding: EdgeInsetsGeometry.all(10),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text("Credentials", style: AppTextStyles.formTitle),
                  SizedBox(height: 30),
                  AppFormGroup(
                    label: "Username",
                    child: AppTextField(
                      controller: _usernameController,
                      name: "username",
                      inputType: TextInputType.text,
                      placeholder: "Username",
                    ),
                  ),

                  AppFormGroup(
                    label: "Password",
                    child: AppTextField(
                      obscureText: true,
                      controller: _passwordController,
                      name: "password",
                      inputType: TextInputType.text,
                      placeholder: "password",
                    ),
                  ),

                  SizedBox(height: 15),
                  Divider(),
                  AppButton(
                    content: Text("Save"),
                    onPressed: _saveCredentials,
                    isFullWidth: true,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _saveVideoSettings() async {
    await videoRecordingSetting.put(
      "maxRecordingDuration",
      int.parse(_videoDurationController.text),
    );
    await videoRecordingSetting.put(
      "googleDrinkLink",
      _googleDriveLinkController.text,
    );

    await videoRecordingSetting.put("videoPreparationDuration", int.parse(_videoPreparationDurationController.text));

    if(!mounted) return;
    Fluttertoast.showToast(
      msg: 'Video Setting Saved',
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 2,
      backgroundColor: Colors.black87,
      textColor: Colors.white,
      fontSize: 14.0,
    );
  }

  void _savePromotionSetting() async {
    await promotionSetting.put("textOfTheDay", _textOfTheDayController.text);
    await _savePictureOfTheDay();
    if(!mounted) return;

    Fluttertoast.showToast(
      msg: 'Saved Promotion Details',
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 2,
      backgroundColor: Colors.black87,
      textColor: Colors.white,
      fontSize: 14.0,
    );
  }

  void _loadInitialData() {
    _videoDurationController.text = videoRecordingSetting
        .get("maxRecordingDuration", defaultValue: '')
        .toString();

    _videoPreparationDurationController.text = videoRecordingSetting
        .get("videoPreparationDuration", defaultValue: '')
        .toString();

    _googleDriveLinkController.text = videoRecordingSetting
        .get("googleDrinkLink", defaultValue: '')
        .toString();

    _textOfTheDayController.text = promotionSetting
        .get("textOfTheDay", defaultValue: '')
        .toString();
    _pictureOfTheDayController.text = promotionSetting
        .get("pictureOfTheDay", defaultValue: '')
        .toString();

    _companyNameController.text = brandingSetting
        .get('companyName', defaultValue: '')
        .toString();

    final credential = credentialSetting.get('credentials');
    _usernameController.text = credential['username'];
  }

  Future<XFile?> _initImagePicker() async {
    final pickedImage = await imageService.pickImage(ImageSource.gallery);
    if (pickedImage == null) {
      return null;
    }
    return pickedImage;
  }

  Future<void> _selectPictureOfTheDayPhoto() async {
    final pickedImage = await _initImagePicker();
    setState(() {
      previewPictureOfTheDayImage = File(pickedImage!.path);
    });
  }

  Future<void> _savePictureOfTheDay() async {
    if (previewPictureOfTheDayImage != null) {
      final isImageSaved = await imageService.saveImage(
        previewPictureOfTheDayImage,
        Storage.promotionSetting,
        'pictureOfTheDay',
      );

      if (isImageSaved != null) {
        setState(() {
          previewPictureOfTheDayImage = null;
        });
      }
    }

    if (previewWallpaper != null) {
      final isWallPaperSaved = await imageService.saveImage(
        previewWallpaper,
        Storage.promotionSetting,
        'companyWallpaper',
      );

      if(isWallPaperSaved != null) {
        setState(() {
          previewWallpaper = null;
        });
      }
    }
  }

  Future<void> _removePictureOfTheDayImage() async {
    if(previewPictureOfTheDayImage != null) {
      imageService.deleteFile(previewPictureOfTheDayImage);
      promotionSetting.delete('pictureOfTheDay');

      setState(() {
        previewPictureOfTheDayImage = null;
      });
    }
  }

  Future<void> _removeCompanyLogo() async {
    if(previewCompanyLogo != null) {
      imageService.deleteFile(previewCompanyLogo);
      promotionSetting.delete('companyLogo');
      setState(() {
        previewCompanyLogo = null;
      });
    }
  }

  void _removeWallpaper() {
    if(previewWallpaper != null) {
      imageService.deleteFile(previewWallpaper);
      promotionSetting.delete('companyWallpaper');
      setState(() {
        previewWallpaper = null;
      });
    }
  }

  Future<void> _saveBranding() async {
    final companyName = _companyNameController.text;
    if (companyName != '') {
      await brandingSetting.put('companyName', companyName);
    }

    if (previewCompanyLogo != null) {
      final isLogoSaved = await imageService.saveImage(
        previewCompanyLogo,
        Storage.companyBranding,
        'companyLogo',
      );

      setState(() {
        previewCompanyLogo = null;
      });
    }

    if(!mounted) return;
    Fluttertoast.showToast(
      msg: 'Saved Branding Details',
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 2,
      backgroundColor: Colors.black87,
      textColor: Colors.white,
      fontSize: 14.0,
    );
  }

  Future<void> _selectCompanyLogo() async {
    final pickedImage = await _initImagePicker();
    setState(() {
      previewCompanyLogo = File(pickedImage!.path);
    });
  }

  Future<void> _selectWallpaper() async {
    final pickedImage = await _initImagePicker();
    setState(() {
      previewWallpaper = File(pickedImage!.path);
    });
  }

  Future<void> _saveCredentials() async {
    final username = _usernameController.text;
    final password = _passwordController.text;
    Map<String, String> userCredential = {
      'username' : username,
      'password' : password
    };
    String localMessage = "";

    if (username.isNotEmpty && username.length > 4) {
      userCredential['username'] = username;
      if (password.isNotEmpty && password.length > 4) {
        userCredential['password'] = password;
        _passwordController.text = '';
      } else {
        localMessage = "Invalid Password";
      }
    } else {
      localMessage = "Invalid Username";
    }

    if(localMessage.isNotEmpty) {
      await credentialSetting.put('credentials', userCredential);
      if(!mounted) return;
    } else {
      localMessage = "Credentials Updated";
    }

    Fluttertoast.showToast(
      msg: localMessage,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 2,
      backgroundColor: Colors.black87,
      textColor: Colors.white,
      fontSize: 14.0,
    );
  }
}
