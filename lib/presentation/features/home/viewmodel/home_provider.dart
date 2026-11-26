import 'package:flutter/material.dart';
import '../../../../core/app_assets.dart';
import '../../../../data/models/brand_model.dart';
import '../../../../data/models/category_model.dart';
import '../../../../data/models/slide_model.dart';
import '../../../../data/services/brand_service.dart';
import '../../../../data/services/category_service.dart';
import '../../../../data/services/slide_service.dart';

class HomeProvider extends ChangeNotifier {
  final BrandService _brandService = BrandService();
  final CategoryService _categoryService = CategoryService();
  final SlideService _slideService = SlideService();

  bool isLoading = false;
  String? errorMessage;

  List<SlideModel> slides = [];
  List<BrandModel> brands = [];
  List<CategoryModel> categories = [];

  int bannerIndex = 0;

  void setBannerIndex(int index) {
    bannerIndex = index;
    notifyListeners();
  }

  final List<Map<String, dynamic>> products = [
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

  Future<void> loadHomeData() async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();

    try {
      final results = await Future.wait([
        _slideService.getSlides(),
        _brandService.getBrands(),
        _categoryService.getCategories(),
      ]);

      slides = results[0] as List<SlideModel>;
      brands = results[1] as List<BrandModel>;
      categories = results[2] as List<CategoryModel>;
    } catch (e) {
      errorMessage = e.toString();
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}
