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
  final Widget? sidebar;
  final Widget? floatingActionButton;

  const AppScaffold({
    super.key,
    this.title,
    required this.child,
    this.trailing,
    this.leading,
    this.backgroundColor,
    this.padding = const EdgeInsetsGeometry.all(16),
    this.sidebar,
    this.floatingActionButton
  });

  @override
  Widget build(BuildContext context) {
    if (Platform.isIOS || Platform.isMacOS) {
      return _cupertinoScaffold(context);
    }
    return _materialScaffold(context);
  }

  Widget _cupertinoScaffold(BuildContext context) {
    return CupertinoPageScaffold(
      backgroundColor: backgroundColor,
      navigationBar: title == null
          ? null
          : CupertinoNavigationBar(
        leading: leading ?? (sidebar != null ? GestureDetector(
          onTap: () {
            // Implement your iOS-style sidebar here, e.g., showModalBottomSheet
            showCupertinoModalPopup(
              context: context,
              builder: (_) => Container(
                height: 300,
                color: CupertinoColors.systemBackground,
                child: sidebar,
              ),
            );
          },
          child: Icon(CupertinoIcons.bars),
        ) : null),
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
        leading: leading ?? (sidebar != null ? Builder(
          builder: (context) {
            return IconButton(
              icon: Icon(Icons.menu),
              onPressed: () => Scaffold.of(context).openDrawer(),
            );
          },
        ) : null),
        actions: trailing != null ? [trailing!] : null,
      ),
      drawer: sidebar != null ? Drawer(child: sidebar!) : null,
      body: SafeArea(
        child: Padding(padding: padding, child: child),
      ),
      floatingActionButton: floatingActionButton,
    );
  }


}
