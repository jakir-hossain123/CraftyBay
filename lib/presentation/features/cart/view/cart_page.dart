import 'package:flutter/material.dart';
import '../../../../core/app_assets.dart';
import '../../../../core/app_colors.dart';
import '../../../core/widgets/cart_bottom_bar.dart';
import '../../../core/widgets/cart_item_card.dart';

class CartPage extends StatefulWidget {
  const CartPage({super.key});

  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  final List<Map<String, dynamic>> _cartItems = List.generate(
    4,
    (index) => {
      'title': 'New Year Special Shoe',
      'subtitle': 'Color: Red, Size: X',
      'price': '\$100',
      'quantity': 1,
      'image': AppAssets.shoe,
    },
  );

  @override
  Widget build(BuildContext context) {
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
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: _cartItems.length,
        itemBuilder: (context, index) {
          final item = _cartItems[index];
          return CartItemCard(
            image: AssetImage(item['image']),
            title: item['title'],
            subtitle: item['subtitle'],
            price: item['price'],
            quantity: item['quantity'],
            onIncrement: () {
              setState(() {
                item['quantity']++;
              });
            },
            onDecrement: () {
              setState(() {
                if (item['quantity'] > 1) item['quantity']--;
              });
            },
            onDelete: () {
              setState(() {
                _cartItems.removeAt(index);
              });
            },
          );
        },
      ),
      bottomNavigationBar: CartBottomBar(
        label: 'Total Price',
        price: '\$100,000.00',
        buttonText: 'Checkout',
        onButtonPressed: () {},
      ),
    );
  }
}
