class WishlistItemModel {
  final String id;
  final String productId;
  final String title;
  final num price;
  final double rating;
  final String image;

  const WishlistItemModel({
    required this.id,
    required this.productId,
    required this.title,
    required this.price,
    required this.rating,
    required this.image,
  });

  factory WishlistItemModel.fromJson(Map<String, dynamic> json) {
    final value = json['product'] ?? json['product_id'];
    final product = value is Map<String, dynamic> ? value : json;
    final photos = product['photos'];
    final firstPhoto = photos is List && photos.isNotEmpty
        ? photos.first
        : null;
    final image = firstPhoto is Map<String, dynamic>
        ? firstPhoto['url']?.toString() ?? firstPhoto['path']?.toString() ?? ''
        : firstPhoto?.toString() ??
              product['image']?.toString() ??
              product['photo_url']?.toString() ??
              '';

    return WishlistItemModel(
      id: json['_id']?.toString() ?? json['id']?.toString() ?? '',
      productId:
          product['_id']?.toString() ??
          product['id']?.toString() ??
          value?.toString() ??
          json['product_id']?.toString() ??
          '',
      title: product['title']?.toString() ?? product['name']?.toString() ?? '',
      price:
          _number(
            product['current_price'] ??
                product['price'] ??
                product['regular_price'],
          ) ??
          0,
      rating: _number(product['rating'] ?? product['star'])?.toDouble() ?? 0,
      image: image,
    );
  }

  static num? _number(dynamic value) {
    if (value is num) return value;
    return num.tryParse(
      value?.toString().replaceAll(RegExp(r'[^0-9.-]'), '') ?? '',
    );
  }
}
