import 'package:flutter/material.dart';
import 'package:menderapp/core/theme/app_color.dart';
class AppBadge extends StatelessWidget {
  final IconData? icon;
  final String text;
  final Color color;

  const AppBadge({
    super.key,
    this.icon,
    required this.text,
    required this.color,
});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(
        right: 5
      ),
      padding: EdgeInsets.symmetric(
        vertical: 8, horizontal: 16
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: color
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: AppColor.white , size: 12,),
          Text(
            text,
            style: TextStyle(
              color: AppColor.white,
              fontSize: 12
            ),
          )
        ],
      ),
    );
  }
}

