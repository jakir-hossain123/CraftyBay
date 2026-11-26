import '../../domain/entities/product_details.dart';

class ProductDetailsModel extends ProductDetails {
  ProductDetailsModel({
    required super.id,
    required super.title,
    required super.slug,
    required super.description,
    required super.photos,
    required super.colors,
    required super.sizes,
    required super.regularPrice,
    required super.currentPrice,
    required super.quantity,
  });

  factory ProductDetailsModel.fromJson(Map<String, dynamic> json) {
    List<String> stringList(String key) {
      final value = json[key];
      return value is List
          ? value.map((item) => item.toString()).toList()
          : const [];
    }

    num? number(String key) {
      final value = json[key];
      if (value is num) return value;
      return num.tryParse(value?.toString() ?? '');
    }

    return ProductDetailsModel(
      id: json['_id']?.toString() ?? json['id']?.toString() ?? '',
      title: json['title']?.toString() ?? '',
      slug: json['slug']?.toString() ?? '',
      description: json['description']?.toString() ?? '',
      photos: stringList('photos'),
      colors: stringList('colors'),
      sizes: stringList('sizes'),
      regularPrice: number('regular_price'),
      currentPrice: number('current_price') ?? 0,
      quantity: number('quantity')?.toInt() ?? 0,
    );
  }
}
