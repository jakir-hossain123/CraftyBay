class SlideEntity {
  final String id;
  final String title;
  final String description;
  final String image;
  final String? link;

  SlideEntity({
    required this.id,
    required this.title,
    required this.description,
    required this.image,
    this.link,
  });
}
