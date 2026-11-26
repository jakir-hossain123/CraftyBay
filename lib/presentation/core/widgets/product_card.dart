import 'package:crafty_bay/core/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../features/wishlist/viewmodel/wishlist_provider.dart';
import '../../features/product_details/view/product_details_page.dart';
import '../auth_navigation.dart';

/// Reusable product tile: image, title, price, rating and wishlist button.
///
/// Used by Home, Product list, Wishlist, etc. Receives all data and
/// callbacks via parameters — no provider access or hardcoded text.
class ProductCard extends StatelessWidget {
  const ProductCard({
    super.key,
    required this.image,
    required this.title,
    required this.price,
    required this.rating,
    this.productId,
    this.width,
    this.isWished = false,
    this.allowLocalWishlist = false,
    this.onTap,
    this.onWishTap,
  });

  final ImageProvider image;
  final String title;
  final String price;
  final double rating;
  final String? productId;

  /// Fixed width (e.g. in a horizontal list). Leave null inside a grid.
  final double? width;
  final bool isWished;
  final bool allowLocalWishlist;
  final VoidCallback? onTap;
  final VoidCallback? onWishTap;

  @override
  Widget build(BuildContext context) {
    final canOpenDetails = productId != null && productId!.isNotEmpty;
    final wishlistProvider = context.watch<WishlistProvider>();
    final wishlistKey = canOpenDetails
        ? productId!
        : WishlistProvider.localProductId(title);
    final productIsWished =
        isWished ||
        ((canOpenDetails || allowLocalWishlist) &&
            wishlistProvider.isWished(wishlistKey));

    return GestureDetector(
      onTap:
          onTap ??
          (canOpenDetails
              ? () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => ProductDetailsPage(productId: productId),
                    ),
                  );
                }
              : null),
      child: Container(
        width: width,
        decoration: BoxDecoration(
          color: AppColors.cardBackground,
          borderRadius: BorderRadius.circular(8),
          boxShadow: const [
            BoxShadow(
              color: AppColors.border,
              blurRadius: 8,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AspectRatio(
              aspectRatio: 1.4,
              child: Container(
                decoration: BoxDecoration(
                  color: AppColors.primaryLight,
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(8),
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Image(image: image, fit: BoxFit.cover),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(8, 8, 8, 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w500,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      Expanded(
                        // Scales price + rating down so narrow grid cells never overflow.
                        child: FittedBox(
                          fit: BoxFit.scaleDown,
                          alignment: Alignment.centerLeft,
                          child: Row(
                            children: [
                              Text(
                                price,
                                style: const TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w700,
                                  color: AppColors.primary,
                                ),
                              ),
                              const SizedBox(width: 10),
                              const Icon(
                                Icons.star,
                                size: 16,
                                color: AppColors.accent,
                              ),
                              const SizedBox(width: 2),
                              Text(
                                rating.toString(),
                                style: const TextStyle(
                                  fontSize: 11,
                                  color: AppColors.textSecondary,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(width: 6),
                      GestureDetector(
                        onTap:
                            onWishTap ??
                            (canOpenDetails || allowLocalWishlist
                                ? () => _toggleWishlist(context)
                                : null),
                        child: Container(
                          padding: const EdgeInsets.all(3),
                          decoration: BoxDecoration(
                            color: AppColors.primary,
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Icon(
                            productIsWished
                                ? Icons.favorite
                                : Icons.favorite_border,
                            size: 14,
                            color: AppColors.textOnPrimary,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _toggleWishlist(BuildContext context) async {
    if (!await AuthNavigation.requireLogin(context)) return;
    if (!context.mounted) return;
    if (productId == null || productId!.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'This demo product is not available in the wishlist API.',
          ),
        ),
      );
      return;
    }
    final provider = context.read<WishlistProvider>();
    if (provider.isMutating) return;
    final success = await context.read<WishlistProvider>().toggleProduct(
      productId: productId ?? '',
      title: title,
      price: price,
      rating: rating,
      image: image is NetworkImage
          ? (image as NetworkImage).url
          : image is AssetImage
          ? (image as AssetImage).assetName
          : '',
    );
    if (!success && context.mounted) {
      final message = context.read<WishlistProvider>().errorMessage;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(message ?? 'Wishlist request failed.')),
      );
    }
  }
}
