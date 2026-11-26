import 'dart:convert';
import '../../core/end_points.dart';
import '../models/cart_item_model.dart';
import 'cache/cache_service.dart';
import 'network/network_caller.dart';
import 'network/network_response.dart';

class CartService {
  final NetworkCaller _networkCaller;

  CartService({NetworkCaller? networkCaller})
    : _networkCaller = networkCaller ?? NetworkCaller();

  Future<List<CartItemModel>> getCart() async {
    final response = await _networkCaller.get(
      Uri.parse(EndPoints.cart),
      headers: await CacheService.bearerHeaders,
      requiresAuthentication: true,
    );
    if (response.isSuccess != true) {
      throw Exception(response.errorMessage ?? 'Failed to load cart');
    }

    final json = _decodeResponse(response.body);
    final data = json['data'];
    final items = data is Map<String, dynamic>
        ? (data['results'] ?? data['data'])
        : data;
    if (items is! List) {
      throw const FormatException('Invalid cart response');
    }
    return items
        .whereType<Map<String, dynamic>>()
        .map(CartItemModel.fromJson)
        .toList();
  }

  Future<void> addToCart({
    required String productId,
    required int quantity,
    String? color,
    String? size,
  }) async {
    final response = await _networkCaller.post(
      Uri.parse(EndPoints.cart),
      headers: await CacheService.bearerHeaders,
      requiresAuthentication: true,
      body: {
        'product': productId,
        'quantity': quantity,
        'color': ?color,
        'size': ?size,
      },
    );
    _ensureSuccess(response, 'Failed to add product to cart');
  }

  Future<void> updateQuantity(String itemId, int quantity) async {
    final response = await _networkCaller.patch(
      Uri.parse(EndPoints.cartItem(itemId)),
      headers: await CacheService.bearerHeaders,
      requiresAuthentication: true,
      body: {'quantity': quantity},
    );
    _ensureSuccess(response, 'Failed to update cart quantity');
  }

  Future<void> removeItem(String itemId) async {
    final response = await _networkCaller.delete(
      Uri.parse(EndPoints.cartItem(itemId)),
      headers: await CacheService.bearerHeaders,
      requiresAuthentication: true,
    );
    _ensureSuccess(response, 'Failed to remove cart item');
  }

  Map<String, dynamic> _decodeResponse(String? body) {
    if (body == null) {
      throw const FormatException('Cart response was empty');
    }
    final json = jsonDecode(body);
    if (json is! Map<String, dynamic>) {
      throw const FormatException('Invalid cart response');
    }
    return json;
  }

  void _ensureSuccess(NetworkResponse response, String message) {
    if (response.isSuccess != true) {
      throw Exception(response.errorMessage ?? message);
    }
  }
}
