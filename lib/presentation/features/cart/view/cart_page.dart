import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../core/app_assets.dart';
import '../../../../core/app_colors.dart';
import '../../../core/image_source.dart';
import '../../../core/widgets/cart_bottom_bar.dart';
import '../../../core/widgets/cart_item_card.dart';
import '../viewmodel/cart_provider.dart';

class CartPage extends StatefulWidget {
  const CartPage({super.key});

  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final provider = context.read<CartProvider>();
      if (!provider.hasLoaded) provider.fetchCart();
    });
  }

  @override
  Widget build(BuildContext context) {
    final cartProvider = context.watch<CartProvider>();
    final items = cartProvider.items;
    final totalFormatted = '\$${cartProvider.totalPrice.toStringAsFixed(2)}';

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text(
          'Cart',
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
        actions: [
          IconButton(
            tooltip: 'Refresh cart',
            onPressed: cartProvider.isLoading ? null : cartProvider.fetchCart,
            icon: const Icon(Icons.refresh),
          ),
        ],
      ),
      body: cartProvider.isLoading && items.isEmpty
          ? const Center(
              child: CircularProgressIndicator(color: AppColors.primary),
            )
          : cartProvider.errorMessage != null && items.isEmpty
          ? _buildError(cartProvider)
          : items.isEmpty
          ? const Center(
              child: Text(
                'Your cart is empty',
                style: TextStyle(fontSize: 16, color: AppColors.textSecondary),
              ),
            )
          : Column(
              children: [
                if (cartProvider.errorMessage != null)
                  _buildErrorNotice(cartProvider),
                Expanded(
                  child: ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: items.length,
                    itemBuilder: (context, index) {
                      final item = items[index];
                      return CartItemCard(
                        image: imageProviderFor(
                          item.image.isEmpty ? AppAssets.shoe : item.image,
                        ),
                        title: item.title,
                        subtitle: item.subtitle,
                        price: item.priceString,
                        quantity: item.quantity,
                        onIncrement: cartProvider.isMutating
                            ? null
                            : () => _updateQuantity(item, item.quantity + 1),
                        onDecrement:
                            cartProvider.isMutating || item.quantity <= 1
                            ? null
                            : () => _updateQuantity(item, item.quantity - 1),
                        onDelete: cartProvider.isMutating
                            ? null
                            : () => _removeItem(item),
                      );
                    },
                  ),
                ),
              ],
            ),
      bottomNavigationBar: CartBottomBar(
        label: 'Total Price',
        price: totalFormatted,
        buttonText: 'Checkout',
        onButtonPressed: () {
          if (items.isEmpty) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Your cart is empty!')),
            );
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Proceeding to Checkout...')),
            );
          }
        },
      ),
    );
  }

  Widget _buildError(CartProvider provider) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              provider.errorMessage ?? 'Unable to load cart.',
              textAlign: TextAlign.center,
              style: const TextStyle(color: AppColors.textSecondary),
            ),
            const SizedBox(height: 12),
            TextButton(
              onPressed: provider.fetchCart,
              child: const Text('Retry'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildErrorNotice(CartProvider provider) {
    return MaterialBanner(
      content: Text(provider.errorMessage!),
      actions: [
        TextButton(onPressed: provider.fetchCart, child: const Text('Retry')),
      ],
    );
  }

  Future<void> _updateQuantity(CartItem item, int quantity) async {
    final success = await context.read<CartProvider>().updateQuantity(
      item,
      quantity,
    );
    if (!success && mounted) _showError();
  }

  Future<void> _removeItem(CartItem item) async {
    final success = await context.read<CartProvider>().removeItem(item);
    if (!success && mounted) _showError();
  }

  void _showError() {
    final message = context.read<CartProvider>().errorMessage;
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message ?? 'Cart request failed.')));
  }
}
