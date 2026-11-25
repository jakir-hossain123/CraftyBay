import 'package:flutter/material.dart';
import '../../../../core/app_colors.dart';

class ProductSizeSelector extends StatelessWidget {
  final int selectedIndex;
  final ValueChanged<int> onSizeSelected;

  const ProductSizeSelector({
    super.key,
    required this.selectedIndex,
    required this.onSizeSelected,
  });

  static const List<String> sizes = ['X', 'XL', '2L', 'X'];

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Size',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: 12),
        Row(
          children: List.generate(sizes.length, (index) {
            final isSelected = index == selectedIndex;
            return GestureDetector(
              onTap: () => onSizeSelected(index),
              child: Container(
                margin: const EdgeInsets.only(right: 12),
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: isSelected ? AppColors.primary : Colors.transparent,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: isSelected ? AppColors.primary : AppColors.border,
                  ),
                ),
                child: Center(
                  child: Text(
                    sizes[index],
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: isSelected ? Colors.white : AppColors.textPrimary,
                    ),
                  ),
                ),
              ),
            );
          }),
        ),
      ],
    );
  }
}
