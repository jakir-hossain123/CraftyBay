import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:logger/logger.dart';

import '../../../core/app_strings.dart';
import '../cache/cache_service.dart';
import 'network_log_box.dart';
import 'network_response.dart';
import 'session_expired.dart';

/// The only class in the app that talks to the `http` package.
///
/// It sends a request, prints the request and response to the debug console
/// with `logger`, and turns every outcome into a [NetworkResponse].
class NetworkCaller {
  static const Duration _timeout = Duration(seconds: 20);

  final _logger = Logger(
    printer: PrettyPrinter(
      methodCount: 0,
      colors: false,
      printEmojis: false,
      noBoxingByDefault: true,
      dateTimeFormat: DateTimeFormat.none,
    ),
  );

  /// Sends a GET request to [uri].
  Future<NetworkResponse> get(
    Uri uri, {
    Map<String, String>? headers,
    bool requiresAuthentication = false,
  }) async {
    _logger.i(NetworkLogBox.request('GET', uri, headers));
    final stopwatch = Stopwatch()..start();
    final response = await http.get(uri, headers: headers).timeout(_timeout);
    _logResponse('GET', response, stopwatch.elapsedMilliseconds);
    await _handleUnauthorized(response, headers, requiresAuthentication);
    return _toNetworkResponse(response);
  }

  /// Sends a POST request to [uri].
  Future<NetworkResponse> post(
    Uri uri, {
    Map<String, String>? headers,
    Object? body,
    bool requiresAuthentication = false,
  }) async {
    _logger.i(NetworkLogBox.request('POST', uri, headers));
    final stopwatch = Stopwatch()..start();
    final response = await http
        .post(
          uri,
          headers: headers,
          body: body is Map ? jsonEncode(body) : body,
        )
        .timeout(_timeout);
    _logResponse('POST', response, stopwatch.elapsedMilliseconds);
    await _handleUnauthorized(response, headers, requiresAuthentication);
    return _toNetworkResponse(response);
  }

  /// Sends a PATCH request to [uri].
  Future<NetworkResponse> patch(
    Uri uri, {
    Map<String, String>? headers,
    Object? body,
    bool requiresAuthentication = false,
  }) async {
    _logger.i(NetworkLogBox.request('PATCH', uri, headers));
    final stopwatch = Stopwatch()..start();
    final response = await http
        .patch(
          uri,
          headers: headers,
          body: body is Map ? jsonEncode(body) : body,
        )
        .timeout(_timeout);
    _logResponse('PATCH', response, stopwatch.elapsedMilliseconds);
    await _handleUnauthorized(response, headers, requiresAuthentication);
    return _toNetworkResponse(response);
  }

  /// Sends a DELETE request to [uri].
  Future<NetworkResponse> delete(
    Uri uri, {
    Map<String, String>? headers,
    bool requiresAuthentication = false,
  }) async {
    _logger.i(NetworkLogBox.request('DELETE', uri, headers));
    final stopwatch = Stopwatch()..start();
    final response = await http.delete(uri, headers: headers).timeout(_timeout);
    _logResponse('DELETE', response, stopwatch.elapsedMilliseconds);
    await _handleUnauthorized(response, headers, requiresAuthentication);
    return _toNetworkResponse(response);
  }

  Future<void> _handleUnauthorized(
    http.Response response,
    Map<String, String>? requestHeaders,
    bool requiresAuthentication,
  ) async {
    final hasTokenHeader =
        requestHeaders?.keys.any(
          (key) =>
              key.toLowerCase() == 'authorization' ||
              key.toLowerCase() == 'token',
        ) ??
        false;
    if (response.statusCode != 401 ||
        !requiresAuthentication ||
        !hasTokenHeader) {
      return;
    }
    final path = response.request?.url.path ?? '';
    if (path.endsWith('/auth/login') ||
        path.endsWith('/auth/signup') ||
        path.endsWith('/auth/verify-otp') ||
        path.endsWith('/auth/resend-otp')) {
      return;
    }
    await CacheService.clearAccessToken();
    await SessionExpired.notify();
  }

  void _logResponse(String method, http.Response response, int elapsedMs) {
    final message = NetworkLogBox.response(
      method: method,
      uri: response.request?.url,
      statusCode: response.statusCode,
      reason: response.reasonPhrase,
      elapsedMs: elapsedMs,
      body: _redactBody(response.body),
    );
    if (response.statusCode >= 200 && response.statusCode < 300) {
      _logger.d(message);
    } else {
      _logger.e(message);
    }
  }

  NetworkResponse _toNetworkResponse(http.Response response) {
    final isSuccess = response.statusCode >= 200 && response.statusCode < 300;
    return NetworkResponse(
      isSuccess: isSuccess,
      statusCode: response.statusCode,
      body: response.body,
      errorMessage: isSuccess
          ? null
          : _serverMessage(response.body) ??
                '${AppStrings.networkServerError} ${response.statusCode}',
    );
  }

  String? _serverMessage(String body) {
    try {
      final decoded = jsonDecode(body);
      final message = decoded is Map ? decoded['msg'] : null;
      return message is String && message.isNotEmpty ? message : null;
    } on FormatException {
      return null;
    }
  }

  String _redactBody(String body) {
    try {
      return jsonEncode(_redactTokens(jsonDecode(body)));
    } on FormatException {
      return body;
    }
  }

  Object? _redactTokens(Object? value) {
    if (value is Map) {
      return value.map((key, child) {
        final normalizedKey = key.toString().toLowerCase();
        if (const {
          'token',
          'access_token',
          'accesstoken',
          'jwt',
          'password',
        }.contains(normalizedKey)) {
          return MapEntry(key, '[REDACTED]');
        }
        return MapEntry(key, _redactTokens(child));
      });
    }
    if (value is List) {
      return value.map(_redactTokens).toList();
    }
    return value;
  }
}
