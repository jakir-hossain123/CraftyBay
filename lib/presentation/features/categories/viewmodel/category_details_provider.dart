import 'package:flutter/material.dart';
import '../../../../data/models/category_model.dart';
import '../../../../data/services/category_service.dart';

class CategoryDetailsProvider extends ChangeNotifier {
  final CategoryService _categoryService = CategoryService();

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  CategoryModel? _category;
  CategoryModel? get category => _category;

  Future<void> fetchCategoryDetails(String id) async {
    if (id.isEmpty) {
      _errorMessage = 'A category ID is required.';
      notifyListeners();
      return;
    }

    _isLoading = true;
    _errorMessage = null;
    _category = null;
    notifyListeners();

    try {
      _category = await _categoryService.getCategoryDetails(id);
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
