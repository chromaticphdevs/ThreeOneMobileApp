import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:menderapp/core/theme/app_asset_files.dart';
import 'package:menderapp/core/theme/app_color.dart';
import 'package:menderapp/core/widgets/app_button.dart';
import 'package:menderapp/core/widgets/app_button_text.dart';
import 'package:menderapp/core/widgets/app_divider.dart';
import 'package:menderapp/core/widgets/app_platform_widget.dart';
import 'package:menderapp/core/widgets/app_scaffold.dart';
class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  @override
  Widget build(BuildContext context) {
    return AppScaffold(child: _landing());
  }

  Widget _landing() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Image.asset(AppAssetFiles.logoWide, width: 163, height: 33,),
        SizedBox(height: 30,),
        Text.rich(
          TextSpan(
            text: 'Discover Mender, ',
            style: const TextStyle(
              color: AppColor.info
            ),
            children: [
              const TextSpan(
                text: 'where professionals \n grow and ',
                style: TextStyle(
                    color: AppColor.black
                )
              ),
              TextSpan(
                text: 'opportunities begin.',
                style: const TextStyle(
                  color: AppColor.info, // your highlight color
                ),
              ),
            ],
          ),
          textAlign: TextAlign.center,
        ),
        SizedBox(height: 30,),
        Text("Connect with experts, gain insights, and take the next step toward your personal and career growth."),

        SizedBox(height: 60,),
        AppButton(content: Row(
          children: [
            AppPlatformWidget(ios: Icon(CupertinoIcons.device_phone_portrait), material: Icon(Icons.phone_android_outlined)),
            SizedBox(width: 10),
            AppButtonText(text: "Continue with Phone Number"),
          ],
        ), onPressed: () {}, color: AppColor.info,),
        SizedBox(height: 30,),

        AppButton(content: Row(
          children: [
            AppPlatformWidget(ios: Icon(Icons.apple), material: Icon(Icons.apple)),
            SizedBox(width: 10),
            AppButtonText(text: "Continue with Apple Id")
          ],
        ), onPressed: () {}, color: AppColor.info,),
        SizedBox(height: 30,),
        AppDivider(),
        SizedBox(height: 30,),
        AppButton(content: Row(
          children: [
            AppPlatformWidget(ios: Icon(Icons.apple), material: Icon(Icons.apple)),
            SizedBox(width: 10),
            AppButtonText(text: "Email Address")
          ],
        ), onPressed: () {}, color: AppColor.info,),
        SizedBox(height: 150,),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("No Account Yet?"),
            TextButton(onPressed: () {
              context.push('/register');
            }, child: Text("Register now"))
          ],
        )
      ],
    );
  }

/**
 * Login with Phone
 */

/**
 * Login With Email
 */

/**
 * Email Verification
 */

/**
 * SMS Verification
 */
}
