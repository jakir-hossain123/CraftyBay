import '../../domain/entities/brand.dart';

class BrandModel extends Brand {
  BrandModel({
    required super.id,
    required super.title,
    required super.slug,
    required super.description,
    required super.icon,
  });

  factory BrandModel.fromJson(Map<String, dynamic> json) {
    return BrandModel(
      id: json['_id'] ?? json['id'] ?? '',
      title: json['title'] ?? '',
      slug: json['slug'] ?? '',
      description: json['description'] ?? '',
      icon: json['icon'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'title': title,
      'slug': slug,
      'description': description,
      'icon': icon,
    };
  }

  Brand toEntity() {
    return Brand(
      id: id,
      title: title,
      slug: slug,
      description: description,
      icon: icon,
    );
  }
}
