import 'package:flutter/material.dart';
import '../../../../data/models/slide_model.dart';
import '../../../../data/services/slide_service.dart';

class SlideProvider extends ChangeNotifier {
  final SlideService _slideService = SlideService();

  bool isLoading = false;
  String? errorMessage;
  List<SlideModel> slides = [];
  int bannerIndex = 0;

  void setBannerIndex(int index) {
    bannerIndex = index;
    notifyListeners();
  }

  Future<void> fetchSlides() async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();

    try {
      slides = await _slideService.getSlides();
    } catch (e) {
      errorMessage = e.toString();
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}
