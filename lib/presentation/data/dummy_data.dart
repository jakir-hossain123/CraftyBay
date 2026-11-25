import 'package:flutter/material.dart';
import '../../core/app_assets.dart';

class DummyData {
  DummyData._();

  static const List<Map<String, dynamic>> categories = [
    {'title': 'Electronics', 'icon': Icons.tv},
    {'title': 'Food', 'icon': Icons.fastfood},
    {'title': 'Fashion', 'icon': Icons.diamond},
    {'title': 'Furniture', 'icon': Icons.weekend},
  ];

  static const List<Map<String, dynamic>> products = [
    {
      'title': 'New Year Special Shoe 30',
      'price': '\$100',
      'rating': 4.8,
      'image': AppAssets.shoe,
    },
    {
      'title': 'New Year Special Shoe 30',
      'price': '\$100',
      'rating': 4.8,
      'image': AppAssets.shoe,
    },
    {
      'title': 'New Year Special Shoe 30',
      'price': '\$100',
      'rating': 4.8,
      'image': AppAssets.shoe,
    },
  ];
}
