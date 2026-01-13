import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:menderapp/core/theme/app_color.dart';

class AppTextField extends StatelessWidget {
  final TextEditingController controller;
  final String name;
  final String? placeholder;
  final IconData? materialPrefixIcon;
  final IconData? materialSuffixIcon;
  final IconData? cupertinoPrefixIcon;
  final IconData? cupertinoSuffixIcon;
  final bool obscureText;
  final TextCapitalization textCapitalization;
  final TextInputType inputType;

  const AppTextField({
    super.key,
    required this.controller,
    required this.name,
    this.placeholder,
    this.materialPrefixIcon,
    this.materialSuffixIcon,
    this.cupertinoPrefixIcon,
    this.cupertinoSuffixIcon,
    this.obscureText = false,
    this.textCapitalization = TextCapitalization.none,
    required this.inputType,
  });

  @override
  Widget build(BuildContext context) {
    if (Platform.isIOS || Platform.isMacOS) {
      return _cupertinoTextField();
    }
    return _materialTextField();
  }

  /// iOS / macOS
  Widget _cupertinoTextField() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: CupertinoTextField(
        controller: controller,
        placeholder: placeholder,
        obscureText: obscureText,
        textCapitalization: textCapitalization,
        keyboardType: inputType,
        padding: const EdgeInsets.symmetric(
          vertical: 14,
          horizontal: 16,
        ),
        prefix: cupertinoPrefixIcon == null
            ? null
            : Padding(
          padding: const EdgeInsets.only(left: 8),
          child: Icon(
            cupertinoPrefixIcon,
            size: 12,
            color: CupertinoColors.systemGrey,
          ),
        ),
        suffix: cupertinoSuffixIcon == null
            ? null
            : Padding(
          padding: const EdgeInsets.only(right: 8),
          child: Icon(
            cupertinoSuffixIcon,
            size: 12,
            color: CupertinoColors.systemGrey,
          ),
        ),
        decoration: BoxDecoration(
          color: CupertinoColors.systemGrey6,
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );
  }

  /// Android / Windows
  Widget _materialTextField() {
    return TextField(
      controller: controller,
      obscureText: obscureText,
      keyboardType: inputType,
      textCapitalization: textCapitalization,
      decoration: InputDecoration(
        hintText: placeholder,
        prefixIcon:
        materialPrefixIcon != null ? Icon(materialPrefixIcon) : null,
        suffixIcon:
        materialSuffixIcon != null ? Icon(materialSuffixIcon) : null,
        contentPadding: const EdgeInsets.symmetric(
          vertical: 8,
          horizontal: 10,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );
  }
}
