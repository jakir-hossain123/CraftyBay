class CartItemModel {
  final String id;
  final String productId;
  final String title;
  final String subtitle;
  final num price;
  final int quantity;
  final String image;

  const CartItemModel({
    required this.id,
    required this.productId,
    required this.title,
    required this.subtitle,
    required this.price,
    required this.quantity,
    required this.image,
  });

  factory CartItemModel.fromJson(Map<String, dynamic> json) {
    final product = _productFrom(json);
    final quantity = _number(json['qty'] ?? json['quantity'])?.toInt() ?? 1;
    final color = json['color']?.toString();
    final size = json['size']?.toString();
    final subtitle = [
      if (color != null && color.isNotEmpty) 'Color: $color',
      if (size != null && size.isNotEmpty) 'Size: $size',
    ].join(', ');

    return CartItemModel(
      id: json['_id']?.toString() ?? json['id']?.toString() ?? '',
      productId:
          product['_id']?.toString() ??
          product['id']?.toString() ??
          json['product']?.toString() ??
          json['product_id']?.toString() ??
          '',
      title: product['title']?.toString() ?? product['name']?.toString() ?? '',
      subtitle: subtitle,
      price:
          _number(
            product['current_price'] ??
                product['price'] ??
                product['regular_price'],
          ) ??
          0,
      quantity: quantity,
      image: _imageFor(product),
    );
  }

  static Map<String, dynamic> _productFrom(Map<String, dynamic> json) {
    final value = json['product'];
    if (value is Map<String, dynamic>) return value;
    final nested = json['product_id'];
    if (nested is Map<String, dynamic>) return nested;
    return json;
  }

  static num? _number(dynamic value) {
    if (value is num) return value;
    return num.tryParse(
      value?.toString().replaceAll(RegExp(r'[^0-9.-]'), '') ?? '',
    );
  }

  static String _imageFor(Map<String, dynamic> product) {
    final photos = product['photos'];
    if (photos is List && photos.isNotEmpty) {
      final first = photos.first;
      if (first is String) return first;
      if (first is Map<String, dynamic>) {
        return first['url']?.toString() ?? first['path']?.toString() ?? '';
      }
    }
    return product['image']?.toString() ??
        product['photo_url']?.toString() ??
        '';
  }
}
