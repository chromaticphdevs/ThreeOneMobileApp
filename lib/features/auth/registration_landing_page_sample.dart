import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:menderapp/core/theme/app_color.dart';
import 'package:menderapp/core/widgets/app_badge.dart';
import 'package:menderapp/core/widgets/app_button.dart';
import 'package:menderapp/core/widgets/app_scaffold.dart';
import 'package:menderapp/core/widgets/app_text_field.dart';
import 'package:menderapp/features/auth/auth_controller.dart';

class RegistrationLandingPageSample extends ConsumerStatefulWidget{
  const RegistrationLandingPageSample({super.key});

  @override
  ConsumerState<RegistrationLandingPageSample> createState () => _RegistrationLandingPage();
}

class _RegistrationLandingPage extends ConsumerState<RegistrationLandingPageSample> {
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    // TODO: implement dispose
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isLoading = ref.watch(authControllerProvider);
    return AppScaffold(
      title: "Registration Page",
      child: SingleChildScrollView(
        child: Column(
          children: [
            AppTextField(controller: _nameController, name: 'name', inputType: TextInputType.text, placeholder: 'Enter your message here'),
            const SizedBox(height: 24),
            AppButton(text: 'Continue with Apple ID',
              color: AppColor.danger,
              icon: Icon(Icons.apple, color: AppColor.white,),
              isLoading: isLoading,
              onPressed: () {
                ref.read(authControllerProvider.notifier)
                    .register(name: _nameController.text);
              },
            ),
            const SizedBox(height: 24),
            AppButton(text: 'Email Address',
              color: AppColor.info,
              isLoading: isLoading,
              onPressed: () {
                ref.read(authControllerProvider.notifier)
                    .register(name: _nameController.text);
              },
            ),
            SizedBox(height: 24,),
            Row(
              children: [
                AppBadge(
                  materialIcon: Icons.handshake_rounded,
                  cupertinoIcon: CupertinoIcons.hand_draw_fill,
                  color: AppColor.info,
                  text: 'Follow',
                ),

                AppBadge(
                  materialIcon: Icons.handshake_rounded,
                  cupertinoIcon: CupertinoIcons.hand_draw_fill,
                  color: AppColor.info,
                  text: 'Help',
                ),

                AppBadge(
                  materialIcon: Icons.handshake_rounded,
                  cupertinoIcon: CupertinoIcons.hand_draw_fill,
                  color: AppColor.info,
                  text: 'Urgent',
                )
              ],
            )
          ],
        ),
      )
    );
  }
}