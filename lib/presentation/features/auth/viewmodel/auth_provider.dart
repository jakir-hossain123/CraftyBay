import 'package:flutter/material.dart';
import '../../../../data/services/cache/cache_service.dart';

class AuthProvider extends ChangeNotifier {
  bool isLoading = false;
  String? token;

  Future<void> login(String email, String password) async {
    isLoading = true;
    notifyListeners();
    await Future.delayed(const Duration(seconds: 1));
    token = 'sample_bearer_token_12345';
    await CacheService.setAccessToken(token!);
    isLoading = false;
    notifyListeners();
  }

  Future<void> logout() async {
    token = null;
    await CacheService.clearToken();
    notifyListeners();
  }
}
