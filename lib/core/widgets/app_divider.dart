import 'package:flutter/material.dart';
class AppDivider extends StatelessWidget {
  const AppDivider({super.key});

  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).dividerColor;

    return Row(
      children: [
        Expanded(
          child: Divider(
            color: color,
            thickness: 2,
          ),
        ),
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 12),
          child: Text(
            'OR',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              letterSpacing: 1.2,
            ),
          ),
        ),
        Expanded(
          child: Divider(
            color: color,
            thickness: 2,
          ),
        ),
      ],
    );
  }
}
