import 'package:flutter/material.dart';
class AppButtonText extends StatelessWidget {
  final String text;
  final Widget? leading;
  final Widget? trailing;

  const AppButtonText({
    super.key,
    required this.text,
    this.leading,
    this.trailing
  });

  @override
  Widget build(BuildContext context) {
    return
      Text(
        text,
        style: const TextStyle(color: Colors.white),
      );
  }
}
