import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:hive/hive.dart';
import 'package:menderapp/core/configurations/storage.dart';
import 'package:menderapp/core/widgets/app_button.dart';
import 'package:menderapp/core/widgets/app_scaffold.dart';
import 'package:menderapp/features/common_widgets/sidebar.dart';

class LandingPage extends ConsumerStatefulWidget{
  const LandingPage({super.key});

  @override
  ConsumerState<LandingPage> createState() => _LandingPage();
}

class _LandingPage extends ConsumerState<LandingPage> {
  final promotionSetting = Hive.box(Storage.promotionSetting);
  @override
  Widget build(BuildContext context) {
    return AppScaffold(title: "Landing Page", sidebar: buildSidebar(context), child:
      SingleChildScrollView(
        child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Text(promotionSetting.get('textOfTheDay').toString(), style: TextStyle(
              fontSize: 30,
              fontWeight: FontWeight.w700
          ), textAlign: TextAlign.center,),
          SizedBox(height: 50,),
          Image.network(promotionSetting.get('pictureOfTheDay', defaultValue: '')),
          SizedBox(height: 50,),
          InkWell(
            child: CircleAvatar(
              radius: 50,
              child: Text("Start"),
            ),
            onTap: () {
              context.push('/video-capturing');
            },
          )
        ],
      ),
      ),);
  }
}