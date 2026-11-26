import 'package:flutter/material.dart';
import '../../../../core/app_assets.dart';

class WishlistItem {
  final String id;
  final String title;
  final String price;
  final double rating;
  final String image;

  WishlistItem({
    required this.id,
    required this.title,
    required this.price,
    required this.rating,
    required this.image,
  });
}

class WishlistProvider extends ChangeNotifier {
  final List<WishlistItem> _wishlist = [
    WishlistItem(
      id: '1',
      title: 'New Year Special Shoe 30',
      price: '\$100',
      rating: 4.8,
      image: AppAssets.shoe,
    ),
  ];

  List<WishlistItem> get wishlist => _wishlist;

  bool isWished(String id) {
    return _wishlist.any((item) => item.id == id);
  }

  void toggleWishlist({
    required String id,
    required String title,
    required String price,
    required double rating,
    required String image,
  }) {
    final index = _wishlist.indexWhere((item) => item.id == id);
    if (index >= 0) {
      _wishlist.removeAt(index);
    } else {
      _wishlist.add(
        WishlistItem(
          id: id,
          title: title,
          price: price,
          rating: rating,
          image: image,
        ),
      );
    }
    notifyListeners();
  }
}
