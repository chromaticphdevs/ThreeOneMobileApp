import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AppScaffold extends StatelessWidget {
  final String? title;
  final Widget child;
  final Widget? trailing;
  final Widget? leading;
  final Color? backgroundColor;
  final EdgeInsetsGeometry padding;

  const AppScaffold({
    super.key,
    this.title,
    required this.child,
    this.trailing,
    this.leading,
    this.backgroundColor,
    this.padding = const EdgeInsetsGeometry.all(16),
  });

  @override
  Widget build(BuildContext context) {
    if (Platform.isIOS || Platform.isMacOS) {
      return _cupertinoScaffold();
    }

    return _materialScaffold(context);
  }

  Widget _cupertinoScaffold() {
    return CupertinoPageScaffold(
      backgroundColor: backgroundColor,
      navigationBar: title == null
          ? null
          : CupertinoNavigationBar(
              leading: leading,
              middle: Text(title!),
              trailing: trailing,
            ),
      child: Padding(padding: padding, child: child),
    );
  }

  Widget _materialScaffold(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: title == null
          ? null
          : AppBar(
              title: Text(title!),
              leading: leading,
              actions: trailing != null ? [trailing!] : null,
            ),
      body: SafeArea(
        child: Padding(padding: padding, child: child),
      ),
    );
  }
}
