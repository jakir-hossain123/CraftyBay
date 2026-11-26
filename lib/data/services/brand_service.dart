import 'dart:convert';
import '../../core/end_points.dart';
import '../models/brand_model.dart';
import 'network/network_caller.dart';

class BrandService {
  final _networkCaller = NetworkCaller();

  Future<List<BrandModel>> getBrands() async {
    final response = await _networkCaller.get(
      Uri.parse(EndPoints.brands),
      headers: {'accept': 'application/json'},
    );
    if (response.isSuccess != true) {
      throw Exception(response.errorMessage ?? 'Failed to load brands');
    }
    final json = jsonDecode(response.body!);
    return (json['data']['results'] as List)
        .map((e) => BrandModel.fromJson(e))
        .toList();
  }

  Future<BrandModel> getBrandDetails(String id) async {
    final response = await _networkCaller.get(
      Uri.parse(EndPoints.brandById(id)),
      headers: {'accept': 'application/json'},
    );
    if (response.isSuccess != true) {
      throw Exception(response.errorMessage ?? 'Failed to load brand details');
    }

    final body = response.body;
    if (body == null) {
      throw const FormatException('Brand details response was empty');
    }
    final json = jsonDecode(body);
    if (json is! Map<String, dynamic> ||
        json['data'] is! Map<String, dynamic>) {
      throw const FormatException('Invalid brand details response');
    }
    return BrandModel.fromJson(json['data'] as Map<String, dynamic>);
  }
}
