import 'package:flutter/material.dart';
class AppFormGroup extends StatelessWidget {
  final String label;
  final Widget? child;
  const AppFormGroup({super.key, required this.label, this.child});

  @override
  Widget build(BuildContext context) {
    return Padding(padding: EdgeInsetsGeometry.only(bottom: 13), child: Container(
      alignment: Alignment.centerLeft,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: TextStyle(fontWeight: FontWeight.bold), textAlign: TextAlign.left,),
          if(child != null)...[
            SizedBox(height: 5,),
            child!
          ]
        ],
      ),
    ),);
  }
}
