import 'package:flutter/material.dart';
import '../../../../core/app_assets.dart';
import '../../../../data/models/brand_model.dart';
import '../../../../data/models/category_model.dart';
import '../../../../data/models/slide_model.dart';
import '../service/home_service.dart';

class HomeProvider extends ChangeNotifier {
  final HomeService _homeService = HomeService();

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

  // Fallback dummy products
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
        _homeService.getSlides(),
        _homeService.getBrands(),
        _homeService.getCategories(),
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
