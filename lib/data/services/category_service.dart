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
}
