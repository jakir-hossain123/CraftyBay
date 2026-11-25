import 'package:flutter/material.dart';
import '../../../../core/app_colors.dart';

class ProductColorSelector extends StatelessWidget {
  final int selectedIndex;
  final ValueChanged<int> onColorSelected;

  const ProductColorSelector({
    super.key,
    required this.selectedIndex,
    required this.onColorSelected,
  });

  static const List<Color> colors = [
    AppColors.swatchBlack,
    AppColors.swatchBlue,
    AppColors.swatchBrown,
    AppColors.swatchGrey,
    AppColors.swatchDarkGrey,
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Color',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: 12),
        Row(
          children: List.generate(colors.length, (index) {
            final isSelected = index == selectedIndex;
            return GestureDetector(
              onTap: () => onColorSelected(index),
              child: Container(
                margin: const EdgeInsets.only(right: 12),
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  color: colors[index],
                  shape: BoxShape.circle,
                ),
                child: isSelected
                    ? const Center(
                        child: Icon(
                          Icons.check,
                          size: 16,
                          color: Colors.white,
                        ),
                      )
                    : null,
              ),
            );
          }),
        ),
      ],
    );
  }
}
