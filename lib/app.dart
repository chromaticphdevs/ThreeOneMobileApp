import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:menderapp/router.dart';
import 'dart:io';

class MyApp extends ConsumerWidget{
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // TODO: implement build
    final router = ref.watch(routerProvider);

    if(Platform.isIOS) {
      return CupertinoApp.router(
        debugShowCheckedModeBanner: false,
        routerConfig: router,
      );
    }

    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      routerConfig: router,
    );
  }
}
