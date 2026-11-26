import 'package:crafty_bay/presentation/features/cart/viewmodel/cart_provider.dart';
import 'package:crafty_bay/presentation/features/wishlist/viewmodel/wishlist_provider.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  setUp(() {
    SharedPreferences.setMockInitialValues({});
  });

  test('guest cart actions are rejected instead of stored locally', () async {
    final provider = CartProvider();

    expect(
      await provider.addProduct(
        productId: 'product-123',
        title: 'API Shoes',
        subtitle: 'Color: Black',
        priceString: '\$40',
        price: 40,
        quantity: 1,
        image: 'https://example.com/shoe.png',
      ),
      isFalse,
    );
    expect(provider.items, isEmpty);
    expect(provider.errorMessage, contains('Sign in'));
    expect(await provider.fetchCart(), isFalse);
    expect(provider.items, isEmpty);
  });

  test(
    'guest wishlist actions are rejected instead of stored locally',
    () async {
      final provider = WishlistProvider();

      expect(
        await provider.toggleProduct(
          productId: 'product-123',
          title: 'API Shoes',
          price: '\$40',
          rating: 4.8,
          image: 'https://example.com/shoe.png',
        ),
        isFalse,
      );
      expect(provider.wishlist, isEmpty);
      expect(provider.errorMessage, contains('Sign in'));
      expect(await provider.fetchWishlist(), isFalse);
      expect(provider.wishlist, isEmpty);
    },
  );
}
