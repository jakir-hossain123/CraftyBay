import 'package:flutter/material.dart';

import '../../../core/app_navigator.dart';
import 'login/view/login_page.dart';

class AuthRedirect {
  AuthRedirect._();

  static bool _isOpen = false;

  static void toLogin() {
    final navigator = AppNavigator.key.currentState;
    if (_isOpen || navigator == null) return;
    _isOpen = true;
    navigator.pushAndRemoveUntil(
      MaterialPageRoute<void>(builder: (_) => const LoginPage()),
      (_) => false,
    );
  }

  static void reset() {
    _isOpen = false;
  }
}
