import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:menderapp/core/widgets/app_scaffold.dart';
import 'package:menderapp/features/common_widgets/sidebar.dart';

class VideoCapturingPage extends ConsumerStatefulWidget{
  @override
  ConsumerState<VideoCapturingPage> createState() => _VideoCapturingPage();
}

class _VideoCapturingPage extends ConsumerState<VideoCapturingPage> {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build

    return AppScaffold(sidebar: buildSidebar(context), title: "Video Capturing Page", child: Center(
      child: TextButton(onPressed: () {}, child: Text("Start Capturing")),
    ),);
  }

}