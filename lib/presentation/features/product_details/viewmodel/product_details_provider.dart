import 'package:flutter/material.dart';
import '../../../../domain/entities/product_details.dart';
import '../../../../data/services/product_service.dart';

class ProductDetailsProvider extends ChangeNotifier {
  final ProductService _productService = ProductService();

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  ProductDetails? _product;
  ProductDetails? get product => _product;

  Future<void> fetchProductDetails(String id) async {
    if (id.isEmpty) {
      _errorMessage = 'A product ID is required.';
      notifyListeners();
      return;
    }

    _isLoading = true;
    _errorMessage = null;
    _product = null;
    notifyListeners();

    try {
      _product = await _productService.getProductDetails(id);
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
