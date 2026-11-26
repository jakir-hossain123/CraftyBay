import 'package:flutter/material.dart';
import '../../../../data/services/auth_service.dart';
import '../../../../data/services/cache/cache_service.dart';

class AuthProvider extends ChangeNotifier {
  final AuthService _authService;

  AuthProvider({AuthService? authService})
    : _authService = authService ?? AuthService();

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  String? _token;
  String? get token => _token;

  Future<bool> login({required String email, required String password}) async {
    return _run(() async {
      _token = await _authService.login(
        email: email.trim(),
        password: password,
      );
      await CacheService.saveAccessToken(_token!);
    });
  }

  Future<bool> signUp({
    required String firstName,
    required String lastName,
    required String email,
    required String password,
  }) async {
    return _run(() async {
      await _authService.signUp(
        firstName: firstName.trim(),
        lastName: lastName.trim(),
        email: email.trim(),
        password: password,
      );
    });
  }

  Future<bool> verifyOtp({
    required String email,
    required String otp,
    required String password,
  }) async {
    return _run(() async {
      var token = await _authService.verifyOtp(email: email, otp: otp);
      token ??= await _authService.login(email: email, password: password);
      _token = token;
      await CacheService.saveAccessToken(token);
    });
  }

  Future<bool> resendOtp(String email) =>
      _run(() => _authService.resendOtp(email));

  Future<bool> updateProfile({
    required String mobile,
    required String city,
    required String shippingAddress,
  }) {
    return _run(
      () => _authService.updateProfile(
        phone: mobile,
        city: city,
        shippingAddress: shippingAddress,
      ),
    );
  }

  Future<void> logout() async {
    _token = null;
    await CacheService.clearAccessToken();
    notifyListeners();
  }

  void clearSession() {
    _token = null;
    notifyListeners();
  }

  Future<bool> _run(Future<void> Function() action) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();
    try {
      await action();
      return true;
    } catch (e) {
      _errorMessage = e.toString();
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
