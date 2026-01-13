import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';

final authControllerProvider = StateNotifierProvider<AuthController,bool>((ref) {
  return AuthController();
});

class AuthController extends StateNotifier<bool>{
  AuthController() : super(false);

  Future<void> register({
    required String name
}) async {
   state = true;
    await Future.delayed(const Duration(seconds: 2));
   state = false;
  }

  Future<void> login() async {
    state = true;
    await Future.delayed(const Duration(seconds: 10));
    state = false;
  }


}