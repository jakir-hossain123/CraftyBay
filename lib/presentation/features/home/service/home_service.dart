import 'dart:convert';
import '../../../../core/end_points.dart';
import '../../../../data/models/brand_model.dart';
import '../../../../data/models/category_model.dart';
import '../../../../data/models/slide_model.dart';
import '../../../../data/services/network/network_caller.dart';

class HomeService {
  final NetworkCaller _networkCaller = NetworkCaller();

  List<dynamic> _extractList(String? body) {
    if (body == null) return [];
    try {
      final decoded = jsonDecode(body);
      if (decoded is Map) {
        final data = decoded['data'];
        if (data is Map) {
          final results = data['results'] ?? data['data'];
          if (results is List) return results;
        } else if (data is List) {
          return data;
        }
        if (decoded['results'] is List) return decoded['results'];
      } else if (decoded is List) {
        return decoded;
      }
    } catch (_) {}
    return [];
  }

  Future<List<SlideModel>> getSlides() async {
    final response = await _networkCaller.get(Uri.parse(EndPoints.slides));
    if (response.isSuccess && response.body != null) {
      final list = _extractList(response.body);
      return list.map((e) => SlideModel.fromJson(e)).toList();
    }
    return [];
  }

  Future<List<BrandModel>> getBrands() async {
    final response = await _networkCaller.get(Uri.parse(EndPoints.brands));
    if (response.isSuccess && response.body != null) {
      final list = _extractList(response.body);
      return list.map((e) => BrandModel.fromJson(e)).toList();
    }
    return [];
  }

  Future<List<CategoryModel>> getCategories() async {
    final response = await _networkCaller.get(Uri.parse(EndPoints.categories));
    if (response.isSuccess && response.body != null) {
      final list = _extractList(response.body);
      return list.map((e) => CategoryModel.fromJson(e)).toList();
    }
    return [];
  }
}
