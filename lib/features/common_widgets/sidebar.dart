import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:menderapp/core/theme/app_color.dart';
Widget buildSidebar(BuildContext context) {
  return Drawer(
    backgroundColor: Colors.black,
    child: Theme(data: Theme.of(context).copyWith(
      textTheme: Theme.of(context).textTheme.apply(
        bodyColor: Colors.white
      )
    ), child: ListView(
      padding: EdgeInsets.zero,
      children: [
        DrawerHeader(
          decoration: BoxDecoration(color: AppColor.black),
          child: Text('Menu', style: TextStyle(fontSize: 24, color: Colors.white)),
        ),
        ListTile(
          textColor: Colors.white,
          title: Text("Settings"),
          onTap: () {
            context.go('/setting'); // GoRouter navigation
            Navigator.of(context).pop(); // Close the drawer
          },
        ),
        ListTile(
            textColor: Colors.white,
          title: Text("Landing Page"),
          onTap: () {
            context.go('/landing-page'); // GoRouter navigation
            Navigator.of(context).pop(); // Close the drawer
          },
        ),
        ListTile(
          textColor: Colors.white,
          title: Text("Videos"),
          onTap: () {
            context.go('/video-list'); // GoRouter navigation
            Navigator.of(context).pop(); // Close the drawer
          },
        ),
        ListTile(
          textColor: Colors.white,
          title: Text("Logout"),
          onTap: () {
            context.go('/login'); // GoRouter navigation
            Navigator.of(context).pop(); // Close the drawer
          },
        ),
      ],
    ))
  );


}