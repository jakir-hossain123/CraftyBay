import 'package:flutter/material.dart';
import '../../../../core/app_assets.dart';

class CartItem {
  final String id;
  final String title;
  final String subtitle;
  final String priceString;
  final double price;
  int quantity;
  final String image;

  CartItem({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.priceString,
    required this.price,
    this.quantity = 1,
    required this.image,
  });
}

class CartProvider extends ChangeNotifier {
  final List<CartItem> _items = [
    CartItem(
      id: '1',
      title: 'New Year Special Shoe',
      subtitle: 'Color: Red, Size: X',
      priceString: '\$100',
      price: 100.0,
      quantity: 1,
      image: AppAssets.shoe,
    ),
  ];

  List<CartItem> get items => _items;

  double get totalPrice {
    double total = 0;
    for (var item in _items) {
      total += item.price * item.quantity;
    }
    return total;
  }

  void addItem({
    required String title,
    required String subtitle,
    required String priceString,
    required double price,
    int quantity = 1,
    required String image,
  }) {
    final existingIndex = _items.indexWhere(
      (item) => item.title == title && item.subtitle == subtitle,
    );
    if (existingIndex >= 0) {
      _items[existingIndex].quantity += quantity;
    } else {
      _items.add(
        CartItem(
          id: DateTime.now().toIso8601String(),
          title: title,
          subtitle: subtitle,
          priceString: priceString,
          price: price,
          quantity: quantity,
          image: image,
        ),
      );
    }
    notifyListeners();
  }

  void incrementQuantity(int index) {
    _items[index].quantity++;
    notifyListeners();
  }

  void decrementQuantity(int index) {
    if (_items[index].quantity > 1) {
      _items[index].quantity--;
      notifyListeners();
    }
  }

  void removeItem(int index) {
    _items.removeAt(index);
    notifyListeners();
  }
}
