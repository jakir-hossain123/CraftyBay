import 'package:crafty_bay/data/services/cache/cache_service.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  test('authenticated headers use the cached bearer token', () async {
    SharedPreferences.setMockInitialValues({'auth_token': 'test-token'});

    final headers = await CacheService.bearerHeaders;

    expect(headers['token'], 'test-token');
    expect(headers.containsKey('authorization'), isFalse);
    expect(headers['content-type'], 'application/json');
  });

  test('authenticated headers reject requests without a token', () async {
    SharedPreferences.setMockInitialValues({});

    await expectLater(CacheService.bearerHeaders, throwsA(isA<StateError>()));
  });
}
