import 'package:flutter/material.dart';
import 'package:menderapp/core/theme/app_color.dart';

class AppButton extends StatelessWidget {

  final String text;
  final VoidCallback? onPressed;
  final bool isLoading;
  final Color color;
  final Widget? icon;

  const AppButton({
    super.key,
    required this.text,
    required this.onPressed,
    required this.color,
    this.icon,
    this.isLoading = false
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 52,
      width: double.infinity,
      child: ElevatedButton(
        onPressed: isLoading ? null : onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadiusGeometry.circular(8))
        ),
        child: isLoading ? const CircularProgressIndicator(
          color: AppColor.grey,
        ) : Row(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            if(icon != null) ... [
              icon!,
              const SizedBox(width: 8,)
            ],
            Text(
              text,
              style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w400,
                  color: AppColor.white
              ),
            )
          ],
        ),
      ),
    );
  }
}
