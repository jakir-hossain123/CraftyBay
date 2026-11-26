import 'package:flutter/material.dart';
import '../../../../core/app_assets.dart';
import '../../../../core/app_colors.dart';
import '../../../core/image_source.dart';

class ProductImageCarousel extends StatefulWidget {
  final int currentIndex;
  final List<String> images;
  final ValueChanged<int> onPageChanged;

  const ProductImageCarousel({
    super.key,
    required this.currentIndex,
    required this.images,
    required this.onPageChanged,
  });

  @override
  State<ProductImageCarousel> createState() => _ProductImageCarouselState();
}

class _ProductImageCarouselState extends State<ProductImageCarousel> {
  late final PageController _pageController;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: widget.currentIndex);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final imageCount = widget.images.isEmpty ? 1 : widget.images.length;

    return Container(
      height: 240,
      width: double.infinity,
      decoration: const BoxDecoration(color: AppColors.primaryLight),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: PageView.builder(
                controller: _pageController,
                itemCount: imageCount,
                onPageChanged: widget.onPageChanged,
                itemBuilder: (context, index) {
                  if (widget.images.isEmpty) {
                    return Image.asset(AppAssets.shoe, fit: BoxFit.contain);
                  }
                  return Image(
                    image: imageProviderFor(widget.images[index]),
                    fit: BoxFit.contain,
                    errorBuilder: (context, error, stackTrace) =>
                        Image.asset(AppAssets.shoe, fit: BoxFit.contain),
                  );
                },
              ),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(imageCount, (index) {
              final isActive = index == widget.currentIndex;
              return GestureDetector(
                onTap: () => _pageController.animateToPage(
                  index,
                  duration: const Duration(milliseconds: 250),
                  curve: Curves.easeInOut,
                ),
                child: Container(
                  margin: const EdgeInsets.symmetric(horizontal: 4),
                  width: isActive ? 16 : 8,
                  height: 8,
                  decoration: BoxDecoration(
                    color: isActive ? AppColors.primary : AppColors.surface,
                    borderRadius: BorderRadius.circular(4),
                    border: isActive
                        ? null
                        : Border.all(color: AppColors.border, width: 1),
                  ),
                ),
              );
            }),
          ),
          const SizedBox(height: 12),
        ],
      ),
    );
  }
}
