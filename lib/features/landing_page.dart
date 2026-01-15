import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:hive/hive.dart';
import 'package:menderapp/core/configurations/storage.dart';
import 'package:menderapp/core/widgets/app_scaffold.dart';
import 'package:menderapp/features/common_widgets/sidebar.dart';
import 'package:menderapp/features/services/image_service.dart';

class LandingPage extends ConsumerStatefulWidget {
  const LandingPage({super.key});

  @override
  ConsumerState<LandingPage> createState() => _LandingPage();
}

class _LandingPage extends ConsumerState<LandingPage> {
  final promotionSetting = Hive.box(Storage.promotionSetting);
  final brandingSetting = Hive.box(Storage.companyBranding);

  final _imageService = ImageService();
  File? _pictureOfTheDay;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _loadPictureOfTheDay();
  }
  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      title: "Landing Page",
      sidebar: buildSidebar(context),
      bottomNavigationBar: Container(
        padding: EdgeInsetsGeometry.all(5),
        height: 30,
        color: Colors.red,
        child: Text(brandingSetting.get('companyName', defaultValue: 'Company Name is not set'), textAlign: TextAlign.center),
      ),
      child: LayoutBuilder(
        builder: (context, constraints) {
          return SingleChildScrollView(
            child: ConstrainedBox(
              constraints: BoxConstraints(
                minHeight: constraints.maxHeight,
                minWidth: constraints.maxWidth,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(
                    width: constraints.maxWidth,
                    child: Text(
                      promotionSetting
                          .get(
                            'textOfTheDay',
                            defaultValue: "Default text of the day!!",
                          )
                          .toString(),
                      style: TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.w700,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  SizedBox(height: 10),
                  SizedBox(
                    width: constraints.maxWidth,
                    child: _pictureOfTheDay == null ? SizedBox.shrink() :
                      Image(image: FileImage(_pictureOfTheDay!))
                  ),
                  SizedBox(height: 10),
                  InkWell(
                    child: CircleAvatar(radius: 50, child: Text("Start")),
                    onTap: () {
                      context.push('/video-capturing');
                    },
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Future<void> _loadPictureOfTheDay () async {
    final pictureOfTheDay = await _imageService.loadPhoto(Storage.promotionSetting, 'pictureOfTheDay');
    if(pictureOfTheDay == null) return;

    setState(() {
      _pictureOfTheDay = pictureOfTheDay;
    });
  }
}
