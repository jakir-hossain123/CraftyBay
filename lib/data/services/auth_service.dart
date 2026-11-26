import 'dart:convert';

import '../../core/end_points.dart';
import 'cache/cache_service.dart';
import 'network/network_caller.dart';
import 'network/network_response.dart';

class AuthService {
  final NetworkCaller _networkCaller;

  AuthService({NetworkCaller? networkCaller})
    : _networkCaller = networkCaller ?? NetworkCaller();

  static const _jsonHeaders = {
    'accept': 'application/json',
    'content-type': 'application/json',
  };

  Future<String> login({
    required String email,
    required String password,
  }) async {
    final response = await _networkCaller.post(
      Uri.parse(EndPoints.login),
      headers: _jsonHeaders,
      body: {'email': email, 'password': password},
    );
    final json = _decodeSuccess(response, 'Login failed');
    final token = _findToken(json);
    if (token == null) {
      throw Exception('Login succeeded but the server returned no token.');
    }
    return token;
  }

  Future<void> signUp({
    required String firstName,
    required String lastName,
    required String email,
    required String password,
  }) async {
    final response = await _networkCaller.post(
      Uri.parse(EndPoints.signup),
      headers: _jsonHeaders,
      body: {
        'first_name': firstName,
        'last_name': lastName,
        'email': email,
        'password': password,
      },
    );
    _decodeSuccess(response, 'Could not create account');
  }

  Future<String?> verifyOtp({
    required String email,
    required String otp,
  }) async {
    final response = await _networkCaller.post(
      Uri.parse(EndPoints.verifyOtp),
      headers: _jsonHeaders,
      body: {'email': email, 'otp': otp},
    );
    final json = _decodeSuccess(response, 'OTP verification failed');
    return _findToken(json);
  }

  Future<void> resendOtp(String email) async {
    final response = await _networkCaller.post(
      Uri.parse(EndPoints.resendOtp),
      headers: _jsonHeaders,
      body: {'email': email},
    );
    _decodeSuccess(response, 'Could not resend verification code');
  }

  Future<void> updateProfile({
    required String phone,
    required String city,
    required String shippingAddress,
  }) async {
    final response = await _networkCaller.patch(
      Uri.parse(EndPoints.profile),
      headers: await CacheService.bearerHeaders,
      requiresAuthentication: true,
      body: {'phone': phone, 'city': city, 'shipping_address': shippingAddress},
    );
    _decodeSuccess(response, 'Could not save profile');
  }

  Map<String, dynamic> _decodeSuccess(
    NetworkResponse response,
    String defaultMessage,
  ) {
    if (!response.isSuccess) {
      throw Exception(response.errorMessage ?? defaultMessage);
    }
    final body = response.body;
    if (body == null || body.isEmpty) return {};
    final decoded = jsonDecode(body);
    if (decoded is! Map<String, dynamic>) {
      throw const FormatException('Invalid authentication response');
    }
    final code = num.tryParse(decoded['code']?.toString() ?? '');
    final status = decoded['status']?.toString().toLowerCase();
    if ((code != null && code >= 400) ||
        decoded['success'] == false ||
        (status != null && status != 'success')) {
      throw Exception(
        decoded['msg']?.toString() ??
            decoded['message']?.toString() ??
            defaultMessage,
      );
    }
    return decoded;
  }

  String? _findToken(Map<String, dynamic> response) {
    for (final key in ['token', 'access_token', 'accessToken', 'jwt']) {
      final value = response[key];
      if (value is String && value.isNotEmpty) return value;
    }
    final data = response['data'];
    if (data is String && data.isNotEmpty) return data;
    if (data is Map<String, dynamic>) return _findToken(data);
    return null;
  }
}
