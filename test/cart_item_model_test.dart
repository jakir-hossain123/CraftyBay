import 'package:crafty_bay/data/models/cart_item_model.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('maps a populated cart API item', () {
    final item = CartItemModel.fromJson({
      '_id': 'cart-1',
      'product': {
        '_id': 'product-1',
        'title': 'Everyday Shoes',
        'current_price': 49.5,
        'photos': ['https://example.com/shoe.jpg'],
      },
      'qty': 2,
      'color': 'Black',
      'size': '9',
    });

    expect(item.id, 'cart-1');
    expect(item.productId, 'product-1');
    expect(item.title, 'Everyday Shoes');
    expect(item.price, 49.5);
    expect(item.quantity, 2);
    expect(item.image, 'https://example.com/shoe.jpg');
    expect(item.subtitle, 'Color: Black, Size: 9');
  });
}
