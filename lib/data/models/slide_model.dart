import '../../domain/entities/slide.dart';

class SlideModel extends Slide {
  SlideModel({
    required super.id,
    required super.photoUrl,
    required super.description,
    super.product,
    super.brand,
    super.category,
  });

  factory SlideModel.fromJson(Map<String, dynamic> json) {
    return SlideModel(
      id: json['_id'] ?? json['id'] ?? '',
      photoUrl: json['photo_url'] ?? json['photoUrl'] ?? '',
      description: json['description'] ?? '',
      product: json['product'],
      brand: json['brand'],
      category: json['category'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'photo_url': photoUrl,
      'description': description,
      'product': product,
      'brand': brand,
      'category': category,
    };
  }

  Slide toEntity() {
    return Slide(
      id: id,
      photoUrl: photoUrl,
      description: description,
      product: product,
      brand: brand,
      category: category,
    );
  }
}
