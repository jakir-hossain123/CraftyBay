import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/widgets/product_card.dart';
import '../../../core/widgets/product_grid_page.dart';
import '../viewmodel/wishlist_provider.dart';

class WishlistPage extends StatelessWidget {
  const WishlistPage({super.key});

  @override
  Widget build(BuildContext context) {
    final wishlistProvider = context.watch<WishlistProvider>();
    final wishlist = wishlistProvider.wishlist;

    return ProductGridPage(
      title: 'Wish List',
      itemCount: wishlist.length,
      itemBuilder: (context, index) {
        final item = wishlist[index];
        return ProductCard(
          title: item.title,
          price: item.price,
          rating: item.rating,
          image: AssetImage(item.image),
          isWished: true,
          onWishTap: () {
            wishlistProvider.toggleWishlist(
              id: item.id,
              title: item.title,
              price: item.price,
              rating: item.rating,
              image: item.image,
            );
          },
        );
      },
    );
  }
}
