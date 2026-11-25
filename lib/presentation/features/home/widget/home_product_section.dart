import 'package:flutter/material.dart';
import '../../../core/widgets/product_card.dart';
import '../../../core/widgets/product_section_list.dart';

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
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
      child: ProductSectionList(
        title: title,
        onSeeAllPressed: () {},
        itemCount: products.length,
        itemBuilder: (context, index) {
          final product = products[index];
          return ProductCard(
            title: product['title'],
            price: product['price'],
            rating: product['rating'],
            imagePath: product['image'],
            actionIcon: Icons.favorite_border,
            onActionPressed: () {},
            onTap: () {},
          );
        },
      ),
    );
  }
}
