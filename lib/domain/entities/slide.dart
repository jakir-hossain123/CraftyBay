class Slide {
  final String id;
  final String photoUrl;
  final String description;
  final String? product;
  final String? brand;
  final String? category;

  Slide({
    required this.id,
    required this.photoUrl,
    required this.description,
    this.product,
    this.brand,
    this.category,
  });
}
