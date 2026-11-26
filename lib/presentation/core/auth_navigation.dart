import 'package:flutter/material.dart';

import '../../data/services/cache/cache_service.dart';
import '../features/auth/login/view/login_page.dart';

class AuthNavigation {
  AuthNavigation._();

  static Future<bool> requireLogin(BuildContext context) async {
    if (await CacheService.hasToken()) return true;
    if (!context.mounted) return false;
    Navigator.of(
      context,
    ).push(MaterialPageRoute<void>(builder: (_) => const LoginPage()));
    return false;
  }
}
