import 'dart:convert';
import '../../core/end_points.dart';
import '../models/category_model.dart';
import 'network/network_caller.dart';

class CategoryService {
  final _networkCaller = NetworkCaller();

  Future<List<CategoryModel>> getCategories() async {
    final response = await _networkCaller.get(
      Uri.parse(EndPoints.categories),
      headers: {'accept': 'application/json'},
    );
    if (response.isSuccess != true) {
      throw Exception(response.errorMessage ?? 'Failed to load categories');
    }
    final json = jsonDecode(response.body!);
    return (json['data']['results'] as List)
        .map((e) => CategoryModel.fromJson(e))
        .toList();
  }

  Future<CategoryModel> getCategoryDetails(String id) async {
    final response = await _networkCaller.get(
      Uri.parse(EndPoints.categoryById(id)),
      headers: {'accept': 'application/json'},
    );
    if (response.isSuccess != true) {
      throw Exception(
        response.errorMessage ?? 'Failed to load category details',
      );
    }

    final body = response.body;
    if (body == null) {
      throw const FormatException('Category details response was empty');
    }
    final json = jsonDecode(body);
    if (json is! Map<String, dynamic> ||
        json['data'] is! Map<String, dynamic>) {
      throw const FormatException('Invalid category details response');
    }
    return CategoryModel.fromJson(json['data'] as Map<String, dynamic>);
  }
}
