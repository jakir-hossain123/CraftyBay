import 'package:shared_preferences/shared_preferences.dart';

class CacheService {
  CacheService._();

  static const String _tokenKey = 'auth_token';

  /// Save bearer token upon successful login.
  static Future<void> saveToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_tokenKey, token);
  }

  /// Convenience method for setting the access token.
  static Future<void> setAccessToken(String token) => saveToken(token);

  /// Retrieve the cached bearer token.
  static Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_tokenKey);
  }

  /// Convenience getter for accessing the token.
  static Future<String?> get accessToken => getToken();

  /// Clear the cached bearer token (e.g. on logout).
  static Future<void> clearToken() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_tokenKey);
  }

  /// Check if a bearer token is cached.
  static Future<bool> hasToken() async {
    final token = await getToken();
    return token != null && token.isNotEmpty;
  }
}
