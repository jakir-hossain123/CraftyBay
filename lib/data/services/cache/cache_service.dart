import 'package:shared_preferences/shared_preferences.dart';

class CacheService {
  CacheService._();

  static const String _tokenKey = 'auth_token';

  static Future<void> init() async {
    await SharedPreferences.getInstance();
  }

  static Future<void> saveAccessToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_tokenKey, token);
  }

  static Future<void> setAccessToken(String token) => saveAccessToken(token);

  static Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_tokenKey);
  }

  static Future<String?> get accessToken => getToken();

  static Future<Map<String, String>> get bearerHeaders async {
    final token = await getToken();
    if (token == null || token.isEmpty) {
      throw StateError('An access token is required for this request.');
    }
    return {
      'accept': 'application/json',
      'content-type': 'application/json',
      'token': token,
    };
  }

  static Future<void> clearAccessToken() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_tokenKey);
  }

  static Future<void> clearToken() => clearAccessToken();

  static Future<bool> hasToken() async {
    final token = await getToken();
    return token != null && token.isNotEmpty;
  }
}
