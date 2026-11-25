import 'package:flutter/material.dart';
import '../../../../core/app_assets.dart';
import '../../../../core/app_colors.dart';

class ProductImageCarousel extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onPageChanged;

  const ProductImageCarousel({
    super.key,
    required this.currentIndex,
    required this.onPageChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 240,
      width: double.infinity,
      decoration: const BoxDecoration(
        color: AppColors.primaryLight,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Image.asset(
                AppAssets.shoe,
                fit: BoxFit.contain,
              ),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(4, (index) {
              final isActive = index == currentIndex;
              return GestureDetector(
                onTap: () => onPageChanged(index),
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
