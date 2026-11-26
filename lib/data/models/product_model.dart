import '../../domain/entities/product.dart';

class ProductModel extends Product {
  ProductModel({
    required super.id,
    required super.title,
    required super.slug,
    required super.price,
    required super.rating,
    required super.image,
  });

  factory ProductModel.fromJson(Map<String, dynamic> json) {
    final rawPrice = json['price'] ?? json['current_price'] ?? '100';
    final priceStr = rawPrice is num ? '\$$rawPrice' : '$rawPrice';
    final rawRating = json['rating'] ?? json['star'] ?? 4.8;
    final ratingVal = rawRating is num
        ? rawRating.toDouble()
        : double.tryParse(rawRating.toString()) ?? 4.8;

    // Handle image field (could be string or list of photos)
    String img = '';
    if (json['image'] is String) {
      img = json['image'];
    } else if (json['photos'] is List && (json['photos'] as List).isNotEmpty) {
      img = json['photos'][0].toString();
    } else if (json['photo_url'] is String) {
      img = json['photo_url'];
    }

    return ProductModel(
      id: json['_id'] ?? json['id'] ?? '',
      title: json['title'] ?? json['name'] ?? '',
      slug: json['slug'] ?? '',
      price: priceStr,
      rating: ratingVal,
      image: img,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'title': title,
      'slug': slug,
      'price': price,
      'rating': rating,
      'image': image,
    };
  }

  Product toEntity() {
    return Product(
      id: id,
      title: title,
      slug: slug,
      price: price,
      rating: rating,
      image: image,
    );
  }
}
