import 'package:flutter/material.dart';
import '../../../../core/app_colors.dart';
import '../../../core/widgets/cart_bottom_bar.dart';
import '../../../core/widgets/cart_item_card.dart';
import '../model/cart_manager.dart';

class CartPage extends StatefulWidget {
  const CartPage({super.key});

  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  final CartManager _cartManager = CartManager();

  @override
  void initState() {
    super.initState();
    _cartManager.addListener(_onCartChanged);
  }

  @override
  void dispose() {
    _cartManager.removeListener(_onCartChanged);
    super.dispose();
  }

  void _onCartChanged() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final items = _cartManager.items;
    final totalFormatted = '\$${_cartManager.totalPrice.toStringAsFixed(2)}';

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
      ),
      body: items.isEmpty
          ? const Center(
              child: Text(
                'Your cart is empty',
                style: TextStyle(fontSize: 16, color: AppColors.textSecondary),
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: items.length,
              itemBuilder: (context, index) {
                final item = items[index];
                return CartItemCard(
                  image: AssetImage(item.image),
                  title: item.title,
                  subtitle: item.subtitle,
                  price: item.priceString,
                  quantity: item.quantity,
                  onIncrement: () => _cartManager.incrementQuantity(index),
                  onDecrement: () => _cartManager.decrementQuantity(index),
                  onDelete: () => _cartManager.removeItem(index),
                );
              },
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
}
