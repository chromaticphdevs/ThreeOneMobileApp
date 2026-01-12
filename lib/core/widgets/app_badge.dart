import 'package:flutter/material.dart';
import 'package:menderapp/core/theme/app_color.dart';
import 'package:menderapp/core/widgets/app_platform_widget.dart';

class AppBadge extends StatelessWidget {
  final IconData? materialIcon;
  final IconData? cupertinoIcon;
  final String text;
  final Color color;

  const AppBadge({
    super.key,
    required this.materialIcon,
    required this.cupertinoIcon,
    required this.text,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return AppPlatformWidget(ios: _cupertino(), material: _material());
  }

  Widget _material() {
    return _baseBadge(
      icon: materialIcon,
      iconColor: AppColor.white,
    );
  }

  Widget _cupertino() {
    return _baseBadge(
      icon: cupertinoIcon,
      iconColor: AppColor.white,
    );
  }

  Widget _baseBadge({
    IconData? icon,
    required Color iconColor,
  }) {
    return Container(
      margin: const EdgeInsets.only(right: 5),
      padding: const EdgeInsets.symmetric(
        vertical: 6,
        horizontal: 12,
      ),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            Icon(
              icon,
              size: 12,
              color: iconColor,
            ),
            const SizedBox(width: 4),
          ],
          Text(
            text,
            style: const TextStyle(
              fontSize: 12,
              color: AppColor.white,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
