import 'package:crafty_bay/data/services/auth_service.dart';
import 'package:crafty_bay/data/services/network/network_caller.dart';
import 'package:crafty_bay/data/services/network/network_response.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

class _FakeNetworkCaller extends NetworkCaller {
  final List<NetworkResponse> responses;
  final List<Uri> uris = [];
  final List<Object?> bodies = [];
  final List<Map<String, String>?> headers = [];

  _FakeNetworkCaller(this.responses);

  @override
  Future<NetworkResponse> post(
    Uri uri, {
    Map<String, String>? headers,
    Object? body,
    bool requiresAuthentication = false,
  }) async {
    uris.add(uri);
    bodies.add(body);
    this.headers.add(headers);
    return responses.removeAt(0);
  }

  @override
  Future<NetworkResponse> patch(
    Uri uri, {
    Map<String, String>? headers,
    Object? body,
    bool requiresAuthentication = false,
  }) async {
    uris.add(uri);
    bodies.add(body);
    this.headers.add(headers);
    return responses.removeAt(0);
  }
}

NetworkResponse _response(
  String body, {
  int statusCode = 200,
  String? errorMessage,
}) {
  return NetworkResponse(
    isSuccess: statusCode >= 200 && statusCode < 300,
    statusCode: statusCode,
    body: body,
    errorMessage: errorMessage,
  );
}

void main() {
  setUpAll(() {
    dotenv.testLoad(fileInput: 'BASE_URL=https://test.example/api');
  });

  test('login sends email/password and parses the response JWT', () async {
    SharedPreferences.setMockInitialValues({});
    final caller = _FakeNetworkCaller([
      _response('{"code":200,"status":"success","data":{"token":"login-jwt"}}'),
    ]);
    final service = AuthService(networkCaller: caller);

    final token = await service.login(
      email: 'person@example.com',
      password: 'secret123',
    );

    expect(token, 'login-jwt');
    expect(caller.uris.single.path, endsWith('/auth/login'));
    expect(caller.bodies.single, {
      'email': 'person@example.com',
      'password': 'secret123',
    });
  });

  test('signup sends name, email and password; HTTP 201 succeeds', () async {
    final caller = _FakeNetworkCaller([
      _response(
        '{"code":201,"status":"success","msg":"OTP sent"}',
        statusCode: 201,
      ),
    ]);
    final service = AuthService(networkCaller: caller);

    await service.signUp(
      firstName: 'Alex',
      lastName: 'Smith',
      email: 'person@example.com',
      password: 'secret123',
    );

    expect(caller.uris.single.path, endsWith('/auth/signup'));
    expect(caller.bodies.single, {
      'first_name': 'Alex',
      'last_name': 'Smith',
      'email': 'person@example.com',
      'password': 'secret123',
    });
  });

  test('OTP returns data.token and sends email plus code', () async {
    final caller = _FakeNetworkCaller([
      _response(
        '{"code":200,"status":"success","data":{"token":"verified-jwt","user":{"email":"person@example.com"}}}',
      ),
    ]);
    final service = AuthService(networkCaller: caller);

    final token = await service.verifyOtp(
      email: 'person@example.com',
      otp: '1234',
    );

    expect(token, 'verified-jwt');
    expect(caller.uris.single.path, endsWith('/auth/verify-otp'));
    expect(caller.bodies.single, {
      'email': 'person@example.com',
      'otp': '1234',
    });
  });

  test('OTP permits a successful response without a token', () async {
    final caller = _FakeNetworkCaller([
      _response('{"code":200,"status":"success","msg":"Verified"}'),
    ]);
    final service = AuthService(networkCaller: caller);

    expect(
      await service.verifyOtp(email: 'person@example.com', otp: '1234'),
      isNull,
    );
  });

  test('login surfaces API authentication errors', () async {
    final caller = _FakeNetworkCaller([
      _response(
        '{"msg":"Invalid credentials"}',
        statusCode: 401,
        errorMessage: 'Invalid credentials',
      ),
    ]);
    final service = AuthService(networkCaller: caller);

    await expectLater(
      service.login(email: 'person@example.com', password: 'wrong-password'),
      throwsA(
        isA<Exception>().having(
          (error) => error.toString(),
          'message',
          contains('Invalid credentials'),
        ),
      ),
    );
  });
}
