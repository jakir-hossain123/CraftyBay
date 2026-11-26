import 'package:crafty_bay/data/models/wishlist_item_model.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('maps a populated wishlist API item', () {
    final item = WishlistItemModel.fromJson({
      '_id': 'wishlist-1',
      'product': {
        '_id': 'product-1',
        'title': 'Everyday Shoes',
        'current_price': '49.50',
        'rating': '4.5',
        'photos': ['https://example.com/shoe.jpg'],
      },
    });

    expect(item.id, 'wishlist-1');
    expect(item.productId, 'product-1');
    expect(item.title, 'Everyday Shoes');
    expect(item.price, 49.5);
    expect(item.rating, 4.5);
    expect(item.image, 'https://example.com/shoe.jpg');
  });
}
