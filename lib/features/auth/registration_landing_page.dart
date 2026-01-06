import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:menderapp/core/theme/app_color.dart';
import 'package:menderapp/core/widgets/app_badge.dart';
import 'package:menderapp/core/widgets/app_button.dart';
import 'package:menderapp/core/widgets/app_text_field.dart';
import 'package:menderapp/features/auth/auth_controller.dart';

class RegistrationLandingPage extends ConsumerStatefulWidget{
  const RegistrationLandingPage({super.key});

  @override
  ConsumerState<RegistrationLandingPage> createState () => _RegistrationLandingPage();
}

class _RegistrationLandingPage extends ConsumerState<RegistrationLandingPage> {
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

    return Scaffold(
      appBar: AppBar(title: const Text('Register'),),
      body: Padding(padding: const EdgeInsetsGeometry.all(16),
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
                  icon: Icons.add,
                  color: AppColor.info,
                  text: 'Follow',
                ),

                AppBadge(
                  icon: Icons.handshake,
                  color: AppColor.primary,
                  text: 'Help',
                ),

                AppBadge(
                  icon: Icons.warning,
                  color: AppColor.danger,
                  text: 'Urgent',
                )
              ],
            )
          ],
        ),
      ),),
    );
  }
}