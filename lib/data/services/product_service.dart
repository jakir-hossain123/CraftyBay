import 'dart:convert';
import '../../core/end_points.dart';
import '../../domain/entities/product_details.dart';
import '../models/product_details_model.dart';
import '../models/product_model.dart';
import 'network/network_caller.dart';

class ProductService {
  final NetworkCaller _networkCaller = NetworkCaller();

  Future<List<ProductModel>> getProducts() async {
    final response = await _networkCaller.get(
      Uri.parse(EndPoints.products),
      headers: {'accept': 'application/json'},
    );
    if (response.isSuccess != true) {
      throw Exception(response.errorMessage ?? 'Failed to load products');
    }
    final json = jsonDecode(response.body!);
    final data = json['data'];
    final list = data is Map
        ? (data['results'] ?? data['data'])
        : (data ?? json['results'] ?? json);
    if (list is List) {
      return list.map((e) => ProductModel.fromJson(e)).toList();
    }
    return [];
  }

  Future<ProductDetails> getProductDetails(String id) async {
    final response = await _networkCaller.get(
      Uri.parse(EndPoints.productById(id)),
      headers: {'accept': 'application/json'},
    );
    if (response.isSuccess != true) {
      throw Exception(
        response.errorMessage ?? 'Failed to load product details',
      );
    }

    final body = response.body;
    if (body == null) {
      throw const FormatException('Product details response was empty');
    }
    final json = jsonDecode(body);
    if (json is! Map<String, dynamic>) {
      throw const FormatException('Invalid product details response');
    }
    final data = json['data'];
    if (data is! Map<String, dynamic>) {
      throw const FormatException('Product details were missing from response');
    }
    return ProductDetailsModel.fromJson(data);
  }
}
