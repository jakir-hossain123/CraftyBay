import '../../domain/entities/category.dart';

class CategoryModel extends Category {
  CategoryModel({
    required super.id,
    required super.title,
    required super.slug,
    required super.description,
    required super.icon,
    super.parent,
  });

  factory CategoryModel.fromJson(Map<String, dynamic> json) {
    return CategoryModel(
      id: json['_id'] ?? json['id'] ?? '',
      title: json['title'] ?? '',
      slug: json['slug'] ?? '',
      description: json['description'] ?? '',
      icon: json['icon'] ?? '',
      parent: json['parent'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'title': title,
      'slug': slug,
      'description': description,
      'icon': icon,
      'parent': parent,
    };
  }

  Category toEntity() {
    return Category(
      id: id,
      title: title,
      slug: slug,
      description: description,
      icon: icon,
      parent: parent,
    );
  }
}
