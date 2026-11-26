import 'package:flutter/material.dart';
import '../../../../data/models/wishlist_item_model.dart';
import '../../../../data/services/cache/cache_service.dart';
import '../../../../data/services/wishlist_service.dart';

class WishlistItem {
  final String id;
  final String productId;
  final String title;
  final String price;
  final double rating;
  final String image;

  const WishlistItem({
    required this.id,
    required this.productId,
    required this.title,
    required this.price,
    required this.rating,
    required this.image,
  });

  factory WishlistItem.fromModel(WishlistItemModel model) {
    return WishlistItem(
      id: model.id,
      productId: model.productId,
      title: model.title,
      price: '\$${model.price}',
      rating: model.rating,
      image: model.image,
    );
  }
}

class WishlistProvider extends ChangeNotifier {
  final WishlistService _wishlistService = WishlistService();
  List<WishlistItem> _wishlist = [];

  List<WishlistItem> get wishlist => List.unmodifiable(_wishlist);

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  bool _hasLoaded = false;
  bool get hasLoaded => _hasLoaded;

  bool _isMutating = false;
  bool get isMutating => _isMutating;

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  static String localProductId(String title) =>
      'local-${title.toLowerCase().replaceAll(' ', '-')}';

  void clearRemoteItems() {
    _wishlist = [];
    _hasLoaded = false;
    notifyListeners();
  }

  bool isWished(String productId) {
    return _wishlist.any((item) => item.productId == productId);
  }

  Future<bool> fetchWishlist() async {
    if (!await CacheService.hasToken()) {
      _errorMessage = null;
      _hasLoaded = false;
      notifyListeners();
      return false;
    }
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();
    try {
      final remoteItems = await _wishlistService.getWishlist();
      _wishlist = remoteItems.map(WishlistItem.fromModel).toList();
      _hasLoaded = true;
      return true;
    } catch (e) {
      _errorMessage = e.toString();
      _hasLoaded = true;
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> toggleProduct({
    required String productId,
    required String title,
    required String price,
    required double rating,
    required String image,
  }) async {
    if (_isMutating) return false;
    if (productId.isEmpty) {
      _errorMessage = 'This demo product cannot be added to your wishlist.';
      notifyListeners();
      return false;
    }
    if (!await CacheService.hasToken()) {
      _errorMessage = 'Sign in to save products to your wishlist.';
      notifyListeners();
      return false;
    }

    if (!_hasLoaded) {
      final loaded = await fetchWishlist();
      if (!loaded) return false;
    }

    WishlistItem? existing;
    for (final item in _wishlist) {
      if (item.productId == productId) {
        existing = item;
        break;
      }
    }
    return _mutate(() async {
      if (existing != null) {
        await _wishlistService.removeItem(existing.id);
      } else {
        await _wishlistService.addToWishlist(productId);
      }
      await _refreshAfterMutation();
    });
  }

  Future<bool> removeItem(WishlistItem item) async {
    if (_isMutating) return false;
    return _mutate(() async {
      await _wishlistService.removeItem(item.id);
      await _refreshAfterMutation();
    });
  }

  Future<bool> _mutate(Future<void> Function() action) async {
    if (_isMutating) return false;
    _isMutating = true;
    _errorMessage = null;
    notifyListeners();
    try {
      await action();
      return true;
    } catch (e) {
      _errorMessage = e.toString();
      return false;
    } finally {
      _isMutating = false;
      notifyListeners();
    }
  }

  Future<void> _refreshAfterMutation() async {
    final remoteItems = await _wishlistService.getWishlist();
    _wishlist = remoteItems.map(WishlistItem.fromModel).toList();
    _hasLoaded = true;
  }
}
