import 'package:flutter/material.dart';
import '../../../../data/models/brand_model.dart';
import '../../../../data/services/brand_service.dart';

class BrandProvider extends ChangeNotifier {
  final BrandService _brandService = BrandService();

  bool isLoading = false;
  String? errorMessage;
  List<BrandModel> brands = [];

  Future<void> fetchBrands() async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();

    try {
      brands = await _brandService.getBrands();
    } catch (e) {
      errorMessage = e.toString();
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}
