import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:menderapp/features/auth/registration_landing_page_sample.dart';
import 'package:menderapp/features/login_page.dart';
import 'package:menderapp/features/setting_page.dart';

final routerProvider = Provider<GoRouter>((ref) {
  return GoRouter(
      initialLocation: '/login',
      routes: [
        GoRoute(path : '/register', builder: (context, state) => RegistrationLandingPageSample()),
        GoRoute(path: '/login', builder: (context, state) => LoginPage()),
        GoRoute(path: '/setting', builder: (context, state) => SettingPage())
      ]
  );
});