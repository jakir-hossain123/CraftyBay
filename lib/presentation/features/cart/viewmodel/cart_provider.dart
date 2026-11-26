import 'package:flutter/material.dart';
import '../../../../data/models/cart_item_model.dart';
import '../../../../data/services/cache/cache_service.dart';
import '../../../../data/services/cart_service.dart';

class CartItem {
  final String id;
  final String productId;
  final String title;
  final String subtitle;
  final String priceString;
  final double price;
  final String image;
  int quantity;

  CartItem({
    required this.id,
    required this.productId,
    required this.title,
    required this.subtitle,
    required this.priceString,
    required this.price,
    required this.quantity,
    required this.image,
  });

  factory CartItem.fromModel(CartItemModel model) {
    return CartItem(
      id: model.id,
      productId: model.productId,
      title: model.title,
      subtitle: model.subtitle,
      priceString: '\$${model.price}',
      price: model.price.toDouble(),
      quantity: model.quantity,
      image: model.image,
    );
  }
}

class CartProvider extends ChangeNotifier {
  final CartService _cartService = CartService();
  List<CartItem> _items = [];

  List<CartItem> get items => List.unmodifiable(_items);

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  bool _hasLoaded = false;
  bool get hasLoaded => _hasLoaded;

  bool _isMutating = false;
  bool get isMutating => _isMutating;

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  double get totalPrice =>
      _items.fold(0, (total, item) => total + item.price * item.quantity);

  void clearRemoteItems() {
    _items = [];
    _hasLoaded = false;
    notifyListeners();
  }

  Future<bool> fetchCart() async {
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
      final remoteItems = await _cartService.getCart();
      _items = remoteItems.map(CartItem.fromModel).toList();
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

  Future<bool> addProduct({
    required String productId,
    required String title,
    required String subtitle,
    required String priceString,
    required double price,
    required int quantity,
    required String image,
    String? color,
    String? size,
  }) async {
    if (productId.isEmpty) {
      _errorMessage = 'This demo product cannot be added to your cart.';
      notifyListeners();
      return false;
    }
    if (!await CacheService.hasToken()) {
      _errorMessage = 'Sign in to add products to your cart.';
      notifyListeners();
      return false;
    }

    return _mutate(() async {
      await _cartService.addToCart(
        productId: productId,
        quantity: quantity,
        color: color,
        size: size,
      );
      await _refreshAfterMutation();
    });
  }

  Future<bool> updateQuantity(CartItem item, int quantity) async {
    if (quantity < 1) return false;
    return _mutate(() async {
      await _cartService.updateQuantity(item.id, quantity);
      await _refreshAfterMutation();
    });
  }

  Future<bool> removeItem(CartItem item) async {
    return _mutate(() async {
      await _cartService.removeItem(item.id);
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
    final remoteItems = await _cartService.getCart();
    _items = remoteItems.map(CartItem.fromModel).toList();
    _hasLoaded = true;
  }
}
