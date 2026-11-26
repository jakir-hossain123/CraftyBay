import 'package:flutter/material.dart';
import '../../../../data/models/category_model.dart';
import '../../../../data/services/category_service.dart';

class CategoryProvider extends ChangeNotifier {
  final CategoryService _categoryService = CategoryService();

  bool isLoading = false;
  String? errorMessage;
  List<CategoryModel> categories = [];

  Future<void> fetchCategories() async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();

    try {
      categories = await _categoryService.getCategories();
    } catch (e) {
      errorMessage = e.toString();
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}
