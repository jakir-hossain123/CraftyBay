import 'package:flutter/material.dart';
import '../../../../data/models/product_model.dart';
import '../../../../data/services/product_service.dart';

class ProductProvider extends ChangeNotifier {
  final ProductService _productService = ProductService();

  bool isLoading = false;
  String? errorMessage;
  List<ProductModel> products = [];

  Future<void> fetchProducts() async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();

    try {
      products = await _productService.getProducts();
    } catch (e) {
      errorMessage = e.toString();
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}
