import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../core/app_assets.dart';
import '../../../../core/app_colors.dart';
import '../../../../data/services/cache/cache_service.dart';
import '../../../../domain/entities/product_details.dart';
import '../../../core/auth_navigation.dart';
import '../../../core/widgets/cart_bottom_bar.dart';
import '../../cart/viewmodel/cart_provider.dart';
import '../../wishlist/viewmodel/wishlist_provider.dart';
import '../viewmodel/product_details_provider.dart';
import '../widget/product_color_selector.dart';
import '../widget/product_description_section.dart';
import '../widget/product_header_section.dart';
import '../widget/product_image_carousel.dart';
import '../widget/product_size_selector.dart';

class ProductDetailsPage extends StatelessWidget {
  final String? productId;

  const ProductDetailsPage({super.key, this.productId});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) =>
          ProductDetailsProvider()..fetchProductDetails(productId ?? ''),
      child: _ProductDetailsContent(productId: productId),
    );
  }
}

class _ProductDetailsContent extends StatefulWidget {
  final String? productId;

  const _ProductDetailsContent({required this.productId});

  @override
  State<_ProductDetailsContent> createState() => _ProductDetailsContentState();
}

class _ProductDetailsContentState extends State<_ProductDetailsContent> {
  int _currentBannerIndex = 0;
  int _selectedColorIndex = 0;
  int _selectedSizeIndex = 0;
  int _quantity = 1;

  String _formatPrice(num price) => '\$$price';

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadWishlistForSignedInUser();
    });
  }

  Future<void> _loadWishlistForSignedInUser() async {
    if (!await CacheService.hasToken() || !mounted) return;
    final wishlistProvider = context.read<WishlistProvider>();
    if (!wishlistProvider.hasLoaded) {
      await wishlistProvider.fetchWishlist();
    }
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<ProductDetailsProvider>();
    final wishlistProvider = context.watch<WishlistProvider>();
    final cartProvider = context.watch<CartProvider>();
    final product = provider.product;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text(
          'Product Details',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w500,
            color: AppColors.textPrimary,
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, size: 18),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: product == null
          ? _buildLoadingOrError(provider)
          : _buildProductDetails(product, wishlistProvider),
      bottomNavigationBar: product == null
          ? null
          : CartBottomBar(
              label: product.quantity > 0 ? 'Price' : 'Out of Stock',
              price: _formatPrice(product.currentPrice),
              buttonText: product.quantity > 0 ? 'Add To Cart' : 'Unavailable',
              onButtonPressed: product.quantity > 0 && !cartProvider.isMutating
                  ? () => _addToCart(product)
                  : null,
            ),
    );
  }

  Widget _buildLoadingOrError(ProductDetailsProvider provider) {
    if (provider.isLoading) {
      return const Center(
        child: CircularProgressIndicator(color: AppColors.primary),
      );
    }

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              provider.errorMessage ?? 'Unable to load product details.',
              textAlign: TextAlign.center,
              style: const TextStyle(color: AppColors.textSecondary),
            ),
            const SizedBox(height: 12),
            TextButton(
              onPressed: () =>
                  provider.fetchProductDetails(widget.productId ?? ''),
              child: const Text('Retry'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProductDetails(
    ProductDetails product,
    WishlistProvider wishlistProvider,
  ) {
    final colorIndex = product.colors.isEmpty
        ? 0
        : _selectedColorIndex.clamp(0, product.colors.length - 1).toInt();
    final sizeIndex = product.sizes.isEmpty
        ? 0
        : _selectedSizeIndex.clamp(0, product.sizes.length - 1).toInt();

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ProductImageCarousel(
            currentIndex: _currentBannerIndex,
            images: product.photos,
            onPageChanged: (index) =>
                setState(() => _currentBannerIndex = index),
          ),
          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ProductHeaderSection(
                  title: product.title,
                  quantity: _quantity,
                  onIncrement: _quantity < product.quantity
                      ? () => setState(() => _quantity++)
                      : null,
                  onDecrement: () => setState(() {
                    if (_quantity > 1) _quantity--;
                  }),
                  isWished: wishlistProvider.isWished(product.id),
                  onWishlistTap: () => _toggleWishlist(product),
                ),
                const SizedBox(height: 12),
                _buildPrice(product),
                if (product.colors.isNotEmpty) ...[
                  const SizedBox(height: 20),
                  ProductColorSelector(
                    options: product.colors,
                    selectedIndex: colorIndex,
                    onColorSelected: (index) =>
                        setState(() => _selectedColorIndex = index),
                  ),
                ],
                if (product.sizes.isNotEmpty) ...[
                  const SizedBox(height: 20),
                  ProductSizeSelector(
                    options: product.sizes,
                    selectedIndex: sizeIndex,
                    onSizeSelected: (index) =>
                        setState(() => _selectedSizeIndex = index),
                  ),
                ],
                const SizedBox(height: 20),
                ProductDescriptionSection(description: product.description),
                const SizedBox(height: 24),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPrice(ProductDetails product) {
    final regularPrice = product.regularPrice;
    return Row(
      children: [
        Text(
          _formatPrice(product.currentPrice),
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w700,
            color: AppColors.primary,
          ),
        ),
        if (regularPrice != null && regularPrice > product.currentPrice) ...[
          const SizedBox(width: 10),
          Text(
            _formatPrice(regularPrice),
            style: const TextStyle(
              fontSize: 14,
              color: AppColors.textSecondary,
              decoration: TextDecoration.lineThrough,
            ),
          ),
        ],
      ],
    );
  }

  Future<void> _addToCart(ProductDetails product) async {
    if (!await AuthNavigation.requireLogin(context)) return;
    if (!mounted) return;
    final color = product.colors.isEmpty
        ? null
        : product.colors[_selectedColorIndex
              .clamp(0, product.colors.length - 1)
              .toInt()];
    final size = product.sizes.isEmpty
        ? null
        : product.sizes[_selectedSizeIndex
              .clamp(0, product.sizes.length - 1)
              .toInt()];
    final selectedOptions = [
      if (color != null) 'Color: $color',
      if (size != null) 'Size: $size',
    ];

    final success = await context.read<CartProvider>().addProduct(
      productId: product.id,
      title: product.title,
      subtitle: selectedOptions.join(', '),
      priceString: _formatPrice(product.currentPrice),
      price: product.currentPrice.toDouble(),
      quantity: _quantity,
      image: product.photos.isNotEmpty ? product.photos.first : AppAssets.shoe,
      color: color,
      size: size,
    );
    if (!mounted) return;
    if (!success) {
      _showRequestError(context.read<CartProvider>().errorMessage);
      return;
    }
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Added to cart successfully!'),
        duration: Duration(seconds: 2),
      ),
    );
  }

  Future<void> _toggleWishlist(ProductDetails product) async {
    if (!await AuthNavigation.requireLogin(context)) return;
    if (!mounted) return;
    final success = await context.read<WishlistProvider>().toggleProduct(
      productId: product.id,
      title: product.title,
      price: _formatPrice(product.currentPrice),
      rating: 0,
      image: product.photos.isNotEmpty ? product.photos.first : AppAssets.shoe,
    );
    if (!mounted) return;
    if (!success) {
      _showRequestError(context.read<WishlistProvider>().errorMessage);
      return;
    }
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('Wishlist updated.')));
  }

  void _showRequestError(String? message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message ?? 'Request failed. Please try again.')),
    );
  }
}
