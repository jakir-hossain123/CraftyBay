import 'package:flutter/material.dart';
import '../../../../core/app_assets.dart';
import '../../../../core/app_colors.dart';
import '../../../core/widgets/cart_bottom_bar.dart';
import '../../cart/model/cart_manager.dart';
import '../widget/product_color_selector.dart';
import '../widget/product_description_section.dart';
import '../widget/product_header_section.dart';
import '../widget/product_image_carousel.dart';
import '../widget/product_size_selector.dart';

class ProductDetailsPage extends StatefulWidget {
  const ProductDetailsPage({super.key});

  @override
  State<ProductDetailsPage> createState() => _ProductDetailsPageState();
}

class _ProductDetailsPageState extends State<ProductDetailsPage> {
  int _currentBannerIndex = 0;
  int _selectedColorIndex = 1;
  int _selectedSizeIndex = 1;
  int _quantity = 1;
  bool _isWished = false;

  @override
  Widget build(BuildContext context) {
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
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ProductImageCarousel(
              currentIndex: _currentBannerIndex,
              onPageChanged: (index) => setState(() => _currentBannerIndex = index),
            ),
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ProductHeaderSection(
                    quantity: _quantity,
                    onIncrement: () => setState(() => _quantity++),
                    onDecrement: () => setState(() {
                      if (_quantity > 1) _quantity--;
                    }),
                    isWished: _isWished,
                    onWishlistTap: () => setState(() => _isWished = !_isWished),
                  ),
                  const SizedBox(height: 20),
                  ProductColorSelector(
                    selectedIndex: _selectedColorIndex,
                    onColorSelected: (index) => setState(() => _selectedColorIndex = index),
                  ),
                  const SizedBox(height: 20),
                  ProductSizeSelector(
                    selectedIndex: _selectedSizeIndex,
                    onSizeSelected: (index) => setState(() => _selectedSizeIndex = index),
                  ),
                  const SizedBox(height: 20),
                  const ProductDescriptionSection(),
                  const SizedBox(height: 24),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: CartBottomBar(
        label: 'Price',
        price: '\$1,000',
        buttonText: 'Add To Cart',
        onButtonPressed: () {
          CartManager().addItem(
            title: 'Happy New Year Special Shoe',
            subtitle: 'Color: ${_selectedColorIndex == 1 ? 'Teal' : 'Black'}, Size: ${ProductSizeSelector.sizes[_selectedSizeIndex]}',
            priceString: '\$1,000',
            price: 1000.0,
            quantity: _quantity,
            image: AppAssets.shoe,
          );
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Added to cart successfully!'),
              duration: Duration(seconds: 2),
            ),
          );
        },
      ),
    );
  }
}
