import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:menderapp/core/theme/app_button_size.dart';
import 'package:menderapp/core/theme/app_color.dart';
import 'package:menderapp/core/widgets/app_platform_widget.dart';

class AppButton extends StatelessWidget {
  final Widget content;
  final VoidCallback? onPressed;
  final bool isLoading;
  final Color? color;
  final Widget? icon;
  final Widget? iconMaterial;
  final Widget? iconCupertino;
  final Widget? trailing;
  final Widget? leading;

  const AppButton({
    super.key,
    required this.content,
    required this.onPressed,
    this.color = AppColor.primary,
    this.icon,
    this.iconMaterial,
    this.iconCupertino,
    this.trailing,
    this.leading,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    return AppPlatformWidget(ios: _cupertino(), material: _material());
  }

  Widget _material() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: isLoading ? null : onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadiusGeometry.circular(8),
          ),
        ),
        child: _content(isCupertino: false),
      ),
    );
  }

  Widget _cupertino() {
    return SizedBox(
      width: double.infinity,
      child: CupertinoButton(
        onPressed: isLoading ? null : onPressed,
        color: color,
        borderRadius: BorderRadius.circular(8),
        child: _content(isCupertino: true),
      ),
    );
  }

  Widget _content({required bool isCupertino}) {
    if(isLoading) {
      return isCupertino ? const CupertinoActivityIndicator() : CircularProgressIndicator();
    }
    return Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        if(leading != null) ... [
          leading!,
          const SizedBox(width: 30,)
        ],
        content,
        if(leading != null) ... [
          const SizedBox(width: 30,),
          leading!,
        ],
      ],
    );
  }

}

// class AppButton extends StatelessWidget {
//
//   final String text;
//   final VoidCallback? onPressed;
//   final bool isLoading;
//   final Color color;
//   final Widget? icon;
//
//   const AppButton({
//     super.key,
//     required this.text,
//     required this.onPressed,
//     required this.color,
//     this.icon,
//     this.isLoading = false
//   });
//
//   @override
//   Widget build(BuildContext context) {
//
//     if(Platform.isIOS) {
//
//     } else {
//
//     }
//     return SizedBox(
//       height: 52,
//       width: double.infinity,
//       child: ElevatedButton(
//         onPressed: isLoading ? null : onPressed,
//         style: ElevatedButton.styleFrom(
//           backgroundColor: color,
//           shape: RoundedRectangleBorder(
//             borderRadius: BorderRadiusGeometry.circular(8))
//         ),
//         child: isLoading ? const CircularProgressIndicator(
//           color: AppColor.grey,
//         ) : Row(
//           mainAxisAlignment: MainAxisAlignment.center,
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             if(icon != null) ... [
//               icon!,
//               const SizedBox(width: 8,)
//             ],
//             Text(
//               text,
//               style: const TextStyle(
//                   fontSize: 15,
//                   fontWeight: FontWeight.w400,
//                   color: AppColor.white
//               ),
//             )
//           ],
//         ),
//       ),
//     );
//   }
//
//   Widget _buildMaterialButton() {
//     return SizedBox(
//       height: 52,
//     );
//   }
// }
