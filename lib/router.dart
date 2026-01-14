import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:menderapp/features/auth/registration_landing_page_sample.dart';
import 'package:menderapp/features/landing_page.dart';
import 'package:menderapp/features/login_page.dart';
import 'package:menderapp/features/setting_page.dart';
import 'package:menderapp/features/video_capturing_page.dart';
import 'package:menderapp/features/video_list_page.dart';
import 'package:menderapp/features/video_player_page.dart';

final routerProvider = Provider<GoRouter>((ref) {
  return GoRouter(
      initialLocation: '/login',
      routes: [
        GoRoute(path : '/register', builder: (context, state) => RegistrationLandingPageSample()),
        GoRoute(path: '/login', builder: (context, state) => LoginPage()),
        GoRoute(path: '/setting', builder: (context, state) => SettingPage()),
        GoRoute(path: '/landing-page', builder: (context, state) => LandingPage()),
        GoRoute(path: '/video-capturing', builder: (context, state) => VideoCapturingPage()),
        GoRoute(path: '/video-list', builder: (context,state) => VideoListPage()),
        GoRoute(path: '/video-player', builder: (context, state) {
          // final String videoPath = state.extra as String;
          final File file = state.extra as File;
          return VideoPlayerPage(file: file);
        }),
      ]
  );
});