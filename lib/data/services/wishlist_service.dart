import 'dart:convert';
import '../../core/end_points.dart';
import '../models/wishlist_item_model.dart';
import 'cache/cache_service.dart';
import 'network/network_caller.dart';
import 'network/network_response.dart';

class WishlistService {
  final NetworkCaller _networkCaller = NetworkCaller();

  Future<List<WishlistItemModel>> getWishlist() async {
    final response = await _networkCaller.get(
      Uri.parse(EndPoints.wishlist),
      headers: await CacheService.bearerHeaders,
      requiresAuthentication: true,
    );
    if (response.isSuccess != true) {
      throw Exception(response.errorMessage ?? 'Failed to load wishlist');
    }

    final body = response.body;
    if (body == null) {
      throw const FormatException('Wishlist response was empty');
    }
    final json = jsonDecode(body);
    if (json is! Map<String, dynamic>) {
      throw const FormatException('Invalid wishlist response');
    }
    final data = json['data'];
    final items = data is Map<String, dynamic>
        ? (data['results'] ?? data['data'])
        : data;
    if (items is! List) {
      throw const FormatException('Invalid wishlist response');
    }
    return items
        .whereType<Map<String, dynamic>>()
        .map(WishlistItemModel.fromJson)
        .toList();
  }

  Future<void> addToWishlist(String productId) async {
    final response = await _networkCaller.post(
      Uri.parse(EndPoints.wishlist),
      headers: await CacheService.bearerHeaders,
      requiresAuthentication: true,
      body: {'product': productId},
    );
    _ensureSuccess(response, 'Failed to add product to wishlist');
  }

  Future<void> removeItem(String itemId) async {
    final response = await _networkCaller.delete(
      Uri.parse(EndPoints.wishlistItem(itemId)),
      headers: await CacheService.bearerHeaders,
      requiresAuthentication: true,
    );
    _ensureSuccess(response, 'Failed to remove wishlist item');
  }

  void _ensureSuccess(NetworkResponse response, String message) {
    if (response.isSuccess != true) {
      throw Exception(response.errorMessage ?? message);
    }
  }
}
