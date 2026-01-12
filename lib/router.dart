import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:menderapp/features/auth/login_page.dart';
import 'package:menderapp/features/auth/registration_landing_page_sample.dart';

final routerProvider = Provider<GoRouter>((ref) {
  return GoRouter(
      initialLocation: '/register',
      routes: [
        GoRoute(path : '/register', builder: (context, state) => RegistrationLandingPageSample()),
        GoRoute(path: '/login', builder: (context, state) => LoginPage())
      ]
  );
});