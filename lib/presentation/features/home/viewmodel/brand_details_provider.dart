import 'package:flutter/material.dart';
import '../../../../data/models/brand_model.dart';
import '../../../../data/services/brand_service.dart';

class BrandDetailsProvider extends ChangeNotifier {
  final BrandService _brandService = BrandService();

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  BrandModel? _brand;
  BrandModel? get brand => _brand;

  Future<void> fetchBrandDetails(String id) async {
    if (id.isEmpty) {
      _errorMessage = 'A brand ID is required.';
      notifyListeners();
      return;
    }

    _isLoading = true;
    _errorMessage = null;
    _brand = null;
    notifyListeners();

    try {
      _brand = await _brandService.getBrandDetails(id);
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
