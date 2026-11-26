import 'package:crafty_bay/data/services/cart_service.dart';
import 'package:crafty_bay/data/services/network/network_caller.dart';
import 'package:crafty_bay/data/services/network/network_response.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:shared_preferences/shared_preferences.dart';

class _FakeNetworkCaller extends NetworkCaller {
  final List<String> methods = [];
  final List<Object?> bodies = [];

  @override
  Future<NetworkResponse> post(
    Uri uri, {
    Map<String, String>? headers,
    Object? body,
    bool requiresAuthentication = false,
  }) async {
    methods.add('POST');
    bodies.add(body);
    return NetworkResponse(isSuccess: true, statusCode: 200);
  }

  @override
  Future<NetworkResponse> patch(
    Uri uri, {
    Map<String, String>? headers,
    Object? body,
    bool requiresAuthentication = false,
  }) async {
    methods.add('PATCH');
    bodies.add(body);
    return NetworkResponse(isSuccess: true, statusCode: 200);
  }
}

void main() {
  setUpAll(() {
    dotenv.testLoad(fileInput: 'BASE_URL=https://test.example/api');
  });

  setUp(() {
    SharedPreferences.setMockInitialValues({'auth_token': 'test-token'});
  });

  test('add to cart sends quantity in the API payload', () async {
    final caller = _FakeNetworkCaller();
    final service = CartService(networkCaller: caller);

    await service.addToCart(productId: 'product-1', quantity: 2);

    expect(caller.methods, ['POST']);
    expect(caller.bodies.single, {'product': 'product-1', 'quantity': 2});
  });

  test('cart quantity updates send quantity in the API payload', () async {
    final caller = _FakeNetworkCaller();
    final service = CartService(networkCaller: caller);

    await service.updateQuantity('cart-1', 3);

    expect(caller.methods, ['PATCH']);
    expect(caller.bodies.single, {'quantity': 3});
  });
}
