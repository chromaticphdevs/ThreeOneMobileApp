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

class LoginPage extends ConsumerStatefulWidget{
  const LoginPage({super.key});

  @override
  ConsumerState<LoginPage> createState() => _LoginPage();
}

class _LoginPage extends ConsumerState<LoginPage>{
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  final userCredentialSetting = Hive.box(Storage.userCredentials);

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(AppAssetFiles.logoIcon, height: 100,),

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
}