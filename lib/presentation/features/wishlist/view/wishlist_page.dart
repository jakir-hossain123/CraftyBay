import 'package:flutter/material.dart';
import '../../../../core/app_assets.dart';
import '../../../core/widgets/product_card.dart';
import '../../../core/widgets/product_grid_page.dart';

class WishlistPage extends StatelessWidget {
  const WishlistPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ProductGridPage(
      title: 'Wish List',
      itemCount: 6,
      itemBuilder: (context, index) {
        return ProductCard(
          title: 'New Year Special Shoe 30',
          price: '\$100',
          rating: 4.8,
          image: const AssetImage(AppAssets.shoe),
          isWished: true,
          onWishTap: () {},
        );
      },
    );
  }
}
