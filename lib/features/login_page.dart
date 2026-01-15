import 'dart:io';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:hive/hive.dart';
import 'package:menderapp/core/configurations/storage.dart';
import 'package:menderapp/core/theme/app_asset_files.dart';
import 'package:menderapp/core/widgets/app_button.dart';
import 'package:menderapp/core/widgets/app_button_text.dart';
import 'package:menderapp/core/widgets/app_scaffold.dart';
import 'package:menderapp/core/widgets/app_text_field.dart';
import 'package:menderapp/features/services/image_service.dart';

class LoginPage extends ConsumerStatefulWidget{
  const LoginPage({super.key});

  @override
  ConsumerState<LoginPage> createState() => _LoginPage();
}

class _LoginPage extends ConsumerState<LoginPage>{
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();

  final companyBrandingSetting = Hive.box(Storage.companyBranding);
  final userCredentialSetting = Hive.box(Storage.userCredentials);

  final ImageService _imageService = ImageService();

  File? previewLogo;

  @override
  void initState() {
    // TODO: implement initState
    loadImages();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
              width: 150,
              height: 150,
              child: previewLogo == null ? SizedBox.shrink() :
              Image(image: FileImage(previewLogo!))
          ),
          SizedBox(height: 20,),
          AppTextField(controller: _usernameController, name: "username", inputType: TextInputType.text,
          placeholder: "Username",),

          SizedBox(height: 20,),
          AppTextField(controller: _passwordController, name: "password", inputType: TextInputType.text,
            placeholder: "Password", obscureText: true,),
          SizedBox(height: 40,),
          AppButton(content: AppButtonText(text: "Login"), onPressed: _login, isFullWidth: true,)
        ],
      ),
    );
  }

  void _login() {
    final credential = userCredentialSetting.get('credential');
    if(_usernameController.text == credential['username']) {
      if(_passwordController.text == credential['password']) {
        context.push('/landing-page');
      }
    }
    _passwordController.text = '';
  }


  Future<void> loadImages() async {
    final logo = await _imageService.loadPhoto(Storage.companyBranding, 'companyLogo');
    if(logo == null) return;

    setState(() {
      previewLogo = logo;
    });
  }
}