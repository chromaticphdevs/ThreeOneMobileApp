import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:hive/hive.dart';
import 'package:menderapp/core/configurations/storage.dart';
import 'package:menderapp/core/theme/app_color.dart';
import 'package:menderapp/core/utilities/googledrive_source_converter.dart';
import 'package:menderapp/core/widgets/app_button.dart';
import 'package:menderapp/core/widgets/app_scaffold.dart';
import 'package:menderapp/core/widgets/app_text_field.dart';
import 'package:menderapp/features/common_widgets/sidebar.dart';

class SettingPage extends ConsumerStatefulWidget{
  const SettingPage({super.key});
  @override
  ConsumerState<SettingPage> createState() => _SettingPage();
}

class _SettingPage extends ConsumerState<SettingPage> {
  final _videoDurationController = TextEditingController();
  final _googleDriveLinkController = TextEditingController();

  final _textOfTheDayController = TextEditingController();
  final _pictureOfTheDayController = TextEditingController();

  final videoRecordingSetting = Hive.box(Storage.videoRecordingSetting);
  final brandingSetting = Hive.box(Storage.companyBranding);
  final credentialSetting = Hive.box(Storage.userCredentials);
  final promotionSetting = Hive.box(Storage.promotionSetting);

  @override
  void initState() {
    // TODO: implement initState
    _loadInitialData();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final image = promotionSetting.get("pictureOfTheDay", defaultValue: '').toString();
    return AppScaffold(sidebar: buildSidebar(context), title: "Settings Page", child: CarouselSlider(
      options: CarouselOptions(
        height: screenHeight,
        viewportFraction: 1,
        enlargeCenterPage: false,
        scrollPhysics: BouncingScrollPhysics()
      ),
      items: [
        Container(
          padding: EdgeInsetsGeometry.all(10),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text("Main"),
              SizedBox(height: 30),
              AppTextField(controller: _videoDurationController, name: "video_duration",
                inputType: TextInputType.number, placeholder: "Video Duration",),
              SizedBox(height: 8),
              AppTextField(controller: _googleDriveLinkController, name: "google_drive_link",
                inputType: TextInputType.text, placeholder: "Google Drive link",),
              SizedBox(height: 15),
              AppButton(content: Text("Save"), onPressed: _saveVideoSettings)
            ],
          ),
        ),

        Container(
          padding: EdgeInsetsGeometry.all(10),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text("Promotion Page"),
              SizedBox(height: 30),
              AppTextField(controller: _textOfTheDayController, name: "text_of_the_day",
                inputType: TextInputType.text, placeholder: "Text of the day",),
              SizedBox(height: 8),
              AppTextField(controller: _pictureOfTheDayController, name: "picture_of_the_day",
                inputType: TextInputType.text, placeholder: "Picture",),
              image == '' ? SizedBox.shrink() : Image.network(image),
              SizedBox(height: 15),
              AppButton(content: Text("Save"), onPressed: _savePromotionSetting)
            ],
          ),
        ),

        Container(
          padding: EdgeInsetsGeometry.all(10),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text("Branding"),
              SizedBox(height: 30),
              AppTextField(controller: _videoDurationController, name: "logo",
                inputType: TextInputType.text, placeholder: "Logo Link",),
              SizedBox(height: 8),
              AppTextField(controller: _videoDurationController, name: "wallpaper",
                inputType: TextInputType.text, placeholder: "Google Drive link",),
              SizedBox(height: 8),
              AppTextField(controller: _videoDurationController, name: "company_name",
                inputType: TextInputType.text, placeholder: "Company Name",),
              SizedBox(height: 15),
              AppButton(content: Text("Save"), onPressed: _saveVideoSettings)
            ],
          ),
        ),

        Container(
          padding: EdgeInsetsGeometry.all(10),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text("Credentials"),
              SizedBox(height: 30),
              AppTextField(controller: _videoDurationController, name: "username",
                inputType: TextInputType.text, placeholder: "Username",),
              SizedBox(height: 8),
              AppTextField(controller: _videoDurationController, name: "password",
                inputType: TextInputType.text, placeholder: "Password",),
              SizedBox(height: 8),
              SizedBox(height: 15),
              AppButton(content: Text("Save"), onPressed: _saveVideoSettings)
            ],
          ),
        )
      ],
    ));
  }

  void _saveVideoSettings() async{
    await videoRecordingSetting.put("maxRecordingDuration", int.parse(_videoDurationController.text));
    await videoRecordingSetting.put("googleDrinkLink", _googleDriveLinkController.text);
  }

  void _savePromotionSetting() async {
    String googleLinkImageConverter = GoogledriveSourceConverter().convertedDriveLink(_pictureOfTheDayController.text);
    await promotionSetting.put("textOfTheDay", _textOfTheDayController.text);
    await promotionSetting.put("pictureOfTheDay", googleLinkImageConverter);
  }
  void _loadInitialData() {
    _videoDurationController.text = videoRecordingSetting.get("maxRecordingDuration", defaultValue: '').toString();
    _googleDriveLinkController.text = videoRecordingSetting.get("googleDrinkLink", defaultValue: '').toString();

    _textOfTheDayController.text = promotionSetting.get("textOfTheDay", defaultValue: '').toString();
    _pictureOfTheDayController.text = promotionSetting.get("pictureOfTheDay", defaultValue: '').toString();
  }

}