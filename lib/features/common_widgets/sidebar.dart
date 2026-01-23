import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:menderapp/core/theme/app_color.dart';
Widget buildSidebar(BuildContext context) {
  return ListView(
    padding: EdgeInsets.zero,
    children: [
      DrawerHeader(
        decoration: BoxDecoration(color: AppColor.grey),
        child: Text('Menu', style: TextStyle(fontSize: 24, color: Colors.white)),
      ),
      ListTile(
        title: Text("Gdrive Uploader"),
        onTap: () {
          context.go('/gdrive-uploader');
          Navigator.of(context).pop();
        },
      ),
      ListTile(
        title: Text("Settings"),
        onTap: () {
          context.go('/setting'); // GoRouter navigation
          Navigator.of(context).pop(); // Close the drawer
        },
      ),
      ListTile(
        title: Text("Landing Page"),
        onTap: () {
          context.go('/landing-page'); // GoRouter navigation
          Navigator.of(context).pop(); // Close the drawer
        },
      ),
      ListTile(
        title: Text("Videos"),
        onTap: () {
          context.go('/video-list'); // GoRouter navigation
          Navigator.of(context).pop(); // Close the drawer
        },
      ),
      ListTile(
        title: Text("Logout"),
        onTap: () {
          context.go('/login'); // GoRouter navigation
          Navigator.of(context).pop(); // Close the drawer
        },
      ),
    ],
  );
}