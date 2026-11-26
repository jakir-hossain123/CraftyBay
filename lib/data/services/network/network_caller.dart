import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:logger/logger.dart';

import 'network_log_box.dart';
import 'network_response.dart';

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
  Future<NetworkResponse> get(Uri uri, {Map<String, String>? headers}) async {
    _logger.i(NetworkLogBox.request('GET', uri, headers));
    final stopwatch = Stopwatch()..start();
    final response = await http.get(uri, headers: headers).timeout(_timeout);
    _logResponse('GET', response, stopwatch.elapsedMilliseconds);
    return _toNetworkResponse(response);
  }

  /// Sends a POST request to [uri].
  Future<NetworkResponse> post(
    Uri uri, {
    Map<String, String>? headers,
    Object? body,
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
    return _toNetworkResponse(response);
  }

  void _logResponse(String method, http.Response response, int elapsedMs) {
    final message = NetworkLogBox.response(
      method: method,
      uri: response.request?.url,
      statusCode: response.statusCode,
      reason: response.reasonPhrase,
      elapsedMs: elapsedMs,
      body: response.body,
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
          : 'Server error: ${response.statusCode}',
    );
  }
}
