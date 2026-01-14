import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:menderapp/app.dart';
import 'package:menderapp/core/configurations/storage.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();

  await Hive.initFlutter();
  await Hive.openBox(Storage.videoRecordingSetting);
  await Hive.openBox(Storage.companyBranding);
  await Hive.openBox(Storage.userCredentials);
  await Hive.openBox(Storage.promotionSetting);

  final videoRecordingSetting = Hive.box(Storage.videoRecordingSetting);

  // if(videoRecordingSetting.containsKey('maxRecordingDuration')) {
  //   await videoRecordingSetting.put('maxRecordingDuration', 15);
  //   await videoRecordingSetting.put('preparationDuration', 5);
  // }
  runApp(const ProviderScope(child: MyApp()));
}