import 'dart:convert';
import '../../core/end_points.dart';
import '../models/slide_model.dart';
import 'network/network_caller.dart';

class SlideService {
  final _networkCaller = NetworkCaller();

  Future<List<SlideModel>> getSlides() async {
    final response = await _networkCaller.get(
      Uri.parse(EndPoints.slides),
      headers: {'accept': 'application/json'},
    );
    if (response.isSuccess != true) {
      throw Exception(response.errorMessage ?? 'Failed to load slides');
    }
    final json = jsonDecode(response.body!);
    return (json['data']['results'] as List)
        .map((e) => SlideModel.fromJson(e))
        .toList();
  }
}
