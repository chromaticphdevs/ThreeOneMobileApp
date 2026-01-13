import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:menderapp/core/theme/app_color.dart';
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
  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
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
              AppTextField(controller: _videoDurationController, name: "video_duration",
                inputType: TextInputType.text, placeholder: "Google Drive link",),
              SizedBox(height: 15),
              AppButton(content: Text("Save"), onPressed: () {})
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
              AppButton(content: Text("Save"), onPressed: () {})
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
              AppButton(content: Text("Save"), onPressed: () {})
            ],
          ),
        )
      ],
    ));
  }
}