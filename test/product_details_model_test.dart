import 'package:crafty_bay/data/models/product_details_model.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('maps product detail fields from API JSON', () {
    final product = ProductDetailsModel.fromJson({
      '_id': 'product-1',
      'title': 'Everyday Shoes',
      'slug': 'everyday-shoes',
      'description': 'Comfortable shoes for daily use.',
      'photos': [
        'https://example.com/front.jpg',
        'https://example.com/side.jpg',
      ],
      'colors': ['Black', 'White'],
      'sizes': ['8', '9'],
      'regular_price': '120',
      'current_price': 95,
      'quantity': '4',
    });

    expect(product.id, 'product-1');
    expect(product.title, 'Everyday Shoes');
    expect(product.description, 'Comfortable shoes for daily use.');
    expect(product.photos, [
      'https://example.com/front.jpg',
      'https://example.com/side.jpg',
    ]);
    expect(product.colors, ['Black', 'White']);
    expect(product.sizes, ['8', '9']);
    expect(product.regularPrice, 120);
    expect(product.currentPrice, 95);
    expect(product.quantity, 4);
  });
}
