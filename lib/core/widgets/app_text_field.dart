import 'package:flutter/material.dart';
import 'package:menderapp/core/theme/app_color.dart';

class AppTextField extends StatelessWidget {
  final TextEditingController controller;
  final String name;
  final String? placeholder;
  final IconData? prefixIcon;
  final IconData? suffixIcon;
  final bool obscureText;
  final TextCapitalization textCapitalization;
  final TextInputType inputType;

  const AppTextField({super.key,
    required this.controller,
    required this.name,
    this.placeholder = 'Enter Text',
    this.prefixIcon,
    this.suffixIcon,
    this.obscureText = false,
    this.textCapitalization = TextCapitalization.none,
    required this.inputType,
  });
  @override
  Widget build(BuildContext context) {
    /**
     * padding 16, 8
     */
    return Container(
      padding: const EdgeInsets.fromLTRB(16,8,16,8),
      decoration: BoxDecoration(
        color: AppColor.white,
        borderRadius: BorderRadius.circular(16),
      ),
      height: 58,
      child: TextField(
        enabled: true,
        controller: controller,
        textCapitalization: textCapitalization,
        obscureText: obscureText,
        keyboardType: inputType,
        textAlign: TextAlign.start,
        style: TextStyle(
          color: AppColor.grey
        ),
        decoration: InputDecoration(
          border: InputBorder.none,
          hint: Text(placeholder!, style: TextStyle(color: AppColor.grey),)
        ),
      ),
    );
  }
}
