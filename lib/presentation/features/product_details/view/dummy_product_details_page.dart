import 'package:flutter/material.dart';
import '../../../../core/app_colors.dart';
import '../../../core/widgets/cart_bottom_bar.dart';
import '../../cart/model/cart_manager.dart';
import '../widget/product_color_selector.dart';
import '../widget/product_description_section.dart';
import '../widget/product_header_section.dart';
import '../widget/product_image_carousel.dart';
import '../widget/product_size_selector.dart';

class DummyProductDetailsPage extends StatefulWidget {
  final String title;
  final String price;
  final String image;

  const DummyProductDetailsPage({
    super.key,
    required this.title,
    required this.price,
    required this.image,
  });

  @override
  State<DummyProductDetailsPage> createState() =>
      _DummyProductDetailsPageState();
}

class _DummyProductDetailsPageState extends State<DummyProductDetailsPage> {
  static const _colors = ['Black', 'Teal'];
  static const _sizes = ['X', 'XL', '2L', 'XXL'];
  static const _description =
      'A comfortable everyday shoe made with quality materials.';

  int _selectedColorIndex = 0;
  int _selectedSizeIndex = 0;
  int _quantity = 1;
  bool _isWished = false;

  double get _numericPrice =>
      double.tryParse(widget.price.replaceAll(RegExp(r'[^0-9.]'), '')) ?? 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Product Details'),
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
              currentIndex: 0,
              images: [widget.image],
              onPageChanged: (_) {},
            ),
            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ProductHeaderSection(
                    title: widget.title,
                    quantity: _quantity,
                    onIncrement: () => setState(() => _quantity++),
                    onDecrement: () {
                      if (_quantity > 1) {
                        setState(() => _quantity--);
                      }
                    },
                    isWished: _isWished,
                    onWishlistTap: () => setState(() => _isWished = !_isWished),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    widget.price,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                      color: AppColors.primary,
                    ),
                  ),
                  const SizedBox(height: 20),
                  ProductColorSelector(
                    options: _colors,
                    selectedIndex: _selectedColorIndex,
                    onColorSelected: (index) =>
                        setState(() => _selectedColorIndex = index),
                  ),
                  const SizedBox(height: 20),
                  ProductSizeSelector(
                    options: _sizes,
                    selectedIndex: _selectedSizeIndex,
                    onSizeSelected: (index) =>
                        setState(() => _selectedSizeIndex = index),
                  ),
                  const SizedBox(height: 20),
                  const ProductDescriptionSection(description: _description),
                  const SizedBox(height: 24),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: CartBottomBar(
        label: 'Price',
        price: widget.price,
        buttonText: 'Add To Cart',
        onButtonPressed: () {
          CartManager().addItem(
            title: widget.title,
            subtitle:
                'Color: ${_colors[_selectedColorIndex]}, Size: ${_sizes[_selectedSizeIndex]}',
            priceString: widget.price,
            price: _numericPrice,
            quantity: _quantity,
            image: widget.image,
          );
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Added to cart successfully!')),
          );
        },
      ),
    );
  }
}
