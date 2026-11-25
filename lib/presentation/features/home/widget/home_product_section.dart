import 'package:flutter/material.dart';
import '../../../core/widgets/product_card.dart';
import '../../../core/widgets/product_section.dart';

class HomeProductSection extends StatelessWidget {
  final String title;
  final List<Map<String, dynamic>> products;

  const HomeProductSection({
    super.key,
    required this.title,
    required this.products,
  });

  @override
  Widget build(BuildContext context) {
    const cardWidth = 125.0;
    const spacing = 12.0;

    return ProductSection(
      title: title,
      onSeeAllTap: () {},
      itemCount: products.length,
      itemSpacing: spacing,
      itemBuilder: (context, index) {
        final product = products[index];
        return SizedBox(
          width: cardWidth,
          child: ProductCard(
            title: product['title'],
            price: product['price'],
            rating: product['rating'],
            image: AssetImage(product['image']),
            isWished: false,
            onWishTap: () {},
            onTap: () {},
          ),
        );
      },
    );
  }
}
