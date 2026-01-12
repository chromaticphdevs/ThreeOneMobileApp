import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'dart:io';

class AppPlatformWidget extends StatelessWidget {
  final Widget ios;
  final Widget material;

  const AppPlatformWidget({
    super.key,
    required this.ios,
    required this.material,
  });

  @override
  Widget build(BuildContext context) {
    return Platform.isIOS ? ios : material;
  }
}
