import 'package:flutter/material.dart';
import '../../../../core/app_assets.dart';
import '../../../../data/models/brand_model.dart';
import '../../../../data/models/product_model.dart';
import '../../../core/widgets/product_card.dart';
import '../../../core/widgets/product_grid_page.dart';
import '../../../core/widgets/product_section.dart';
import '../view/brand_details_page.dart';
import '../../product_details/view/dummy_product_details_page.dart';

class HomeProductSection extends StatelessWidget {
  final String title;
  final List<dynamic> items;

  const HomeProductSection({
    super.key,
    required this.title,
    required this.items,
  });

  @override
  Widget build(BuildContext context) {
    const cardWidth = 125.0;
    const spacing = 12.0;

    return ProductSection(
      title: title,
      onSeeAllTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => ProductGridPage(
              title: title,
              itemCount: items.length,
              itemBuilder: (context, index) {
                final item = items[index];
                if (item is BrandModel) {
                  return ProductCard(
                    title: item.title,
                    price: item.slug,
                    rating: 5.0,
                    image: item.icon.isNotEmpty
                        ? NetworkImage(item.icon)
                        : const AssetImage(AppAssets.shoe) as ImageProvider,
                    isWished: false,
                    onWishTap: () {},
                    onTap: () => _openBrandDetails(context, item),
                  );
                } else if (item is ProductModel) {
                  return ProductCard(
                    title: item.title,
                    price: item.price,
                    rating: item.rating,
                    productId: item.id,
                    image: item.image.isNotEmpty
                        ? NetworkImage(item.image)
                        : const AssetImage(AppAssets.shoe) as ImageProvider,
                    isWished: false,
                  );
                } else {
                  final product = item as Map<String, dynamic>;
                  return ProductCard(
                    title: product['title'],
                    price: product['price'],
                    rating: product['rating'],
                    image: AssetImage(product['image']),
                    isWished: false,
                    allowLocalWishlist: true,
                    onTap: () => _openDummyProductDetails(context, product),
                  );
                }
              },
            ),
          ),
        );
      },
      itemCount: items.length,
      itemSpacing: spacing,
      itemBuilder: (context, index) {
        final item = items[index];
        if (item is BrandModel) {
          return SizedBox(
            width: cardWidth,
            child: ProductCard(
              title: item.title,
              price: item.slug,
              rating: 5.0,
              image: item.icon.isNotEmpty
                  ? NetworkImage(item.icon)
                  : const AssetImage(AppAssets.shoe) as ImageProvider,
              isWished: false,
              onWishTap: () {},
              onTap: () => _openBrandDetails(context, item),
            ),
          );
        } else if (item is ProductModel) {
          return SizedBox(
            width: cardWidth,
            child: ProductCard(
              title: item.title,
              price: item.price,
              rating: item.rating,
              productId: item.id,
              image: item.image.isNotEmpty
                  ? NetworkImage(item.image)
                  : const AssetImage(AppAssets.shoe) as ImageProvider,
              isWished: false,
            ),
          );
        } else {
          final product = item as Map<String, dynamic>;
          return SizedBox(
            width: cardWidth,
            child: ProductCard(
              title: product['title'],
              price: product['price'],
              rating: product['rating'],
              image: AssetImage(product['image']),
              isWished: false,
              allowLocalWishlist: true,
              onTap: () => _openDummyProductDetails(context, product),
            ),
          );
        }
      },
    );
  }

  void _openBrandDetails(BuildContext context, BrandModel brand) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => BrandDetailsPage(brandId: brand.id)),
    );
  }

  void _openDummyProductDetails(
    BuildContext context,
    Map<String, dynamic> product,
  ) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => DummyProductDetailsPage(
          title: product['title']?.toString() ?? '',
          price: product['price']?.toString() ?? '',
          image: product['image']?.toString() ?? AppAssets.shoe,
        ),
      ),
    );
  }
}
