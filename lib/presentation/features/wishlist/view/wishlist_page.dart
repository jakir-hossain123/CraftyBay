import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../core/app_assets.dart';
import '../../../core/image_source.dart';
import '../../../core/widgets/product_card.dart';
import '../../../core/widgets/product_grid_page.dart';
import '../viewmodel/wishlist_provider.dart';
import '../../../../core/app_colors.dart';

class WishlistPage extends StatefulWidget {
  const WishlistPage({super.key});

  @override
  State<WishlistPage> createState() => _WishlistPageState();
}

class _WishlistPageState extends State<WishlistPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final provider = context.read<WishlistProvider>();
      if (!provider.hasLoaded) provider.fetchWishlist();
    });
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<WishlistProvider>();
    final wishlist = provider.wishlist;

    if (provider.isLoading && wishlist.isEmpty) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(color: AppColors.primary),
        ),
      );
    }

    if (provider.errorMessage != null && wishlist.isEmpty) {
      return Scaffold(
        appBar: AppBar(title: const Text('Wish List')),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  provider.errorMessage!,
                  textAlign: TextAlign.center,
                  style: const TextStyle(color: AppColors.textSecondary),
                ),
                const SizedBox(height: 12),
                TextButton(
                  onPressed: provider.fetchWishlist,
                  child: const Text('Retry'),
                ),
              ],
            ),
          ),
        ),
      );
    }

    if (wishlist.isEmpty) {
      return Scaffold(
        appBar: AppBar(title: const Text('Wish List')),
        body: const Center(
          child: Text(
            'Your wishlist is empty',
            style: TextStyle(color: AppColors.textSecondary),
          ),
        ),
      );
    }

    if (provider.errorMessage != null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Wish List')),
        body: Column(
          children: [
            MaterialBanner(
              content: Text(provider.errorMessage!),
              actions: [
                TextButton(
                  onPressed: provider.fetchWishlist,
                  child: const Text('Retry'),
                ),
              ],
            ),
            Expanded(
              child: GridView.builder(
                padding: const EdgeInsets.all(16),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                  childAspectRatio: 0.65,
                ),
                itemCount: wishlist.length,
                itemBuilder: (context, index) =>
                    _buildProductCard(wishlist[index], provider),
              ),
            ),
          ],
        ),
      );
    }

    return ProductGridPage(
      title: 'Wish List',
      itemCount: wishlist.length,
      itemBuilder: (context, index) {
        return _buildProductCard(wishlist[index], provider);
      },
    );
  }

  ProductCard _buildProductCard(WishlistItem item, WishlistProvider provider) {
    return ProductCard(
      title: item.title,
      price: item.price,
      rating: item.rating,
      productId: item.productId,
      image: imageProviderFor(item.image.isEmpty ? AppAssets.shoe : item.image),
      isWished: true,
      onWishTap: provider.isMutating ? null : () => _removeItem(item),
    );
  }

  Future<void> _removeItem(WishlistItem item) async {
    final success = await context.read<WishlistProvider>().removeItem(item);
    if (!success && mounted) {
      final message = context.read<WishlistProvider>().errorMessage;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(message ?? 'Wishlist request failed.')),
      );
    }
  }
}
