import 'package:flutter/material.dart';
import '../../../../core/app_colors.dart';

class ProductColorSelector extends StatelessWidget {
  final List<String> options;
  final int selectedIndex;
  final ValueChanged<int> onColorSelected;

  const ProductColorSelector({
    super.key,
    required this.options,
    required this.selectedIndex,
    required this.onColorSelected,
  });

  static const Map<String, Color> _namedColors = {
    'black': AppColors.swatchBlack,
    'blue': AppColors.swatchBlue,
    'brown': AppColors.swatchBrown,
    'gray': AppColors.swatchGrey,
    'grey': AppColors.swatchGrey,
    'dark gray': AppColors.swatchDarkGrey,
    'dark grey': AppColors.swatchDarkGrey,
    'green': Colors.green,
    'navy': Color(0xFF001F3F),
    'orange': Colors.orange,
    'pink': Colors.pink,
    'purple': Colors.purple,
    'red': Colors.red,
    'teal': AppColors.primary,
    'white': Colors.white,
    'yellow': Colors.yellow,
  };

  Color _colorFor(String name) {
    final normalized = name.trim().toLowerCase();
    final namedColor = _namedColors[normalized];
    if (namedColor != null) return namedColor;

    final hex = normalized.replaceFirst('#', '').replaceFirst('0x', '');
    if (RegExp(r'^[0-9a-f]{6}$').hasMatch(hex)) {
      return Color(int.parse('ff$hex', radix: 16));
    }
    if (RegExp(r'^[0-9a-f]{8}$').hasMatch(hex)) {
      return Color(int.parse(hex, radix: 16));
    }
    return AppColors.swatchGrey;
  }

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
        Wrap(
          spacing: 16,
          runSpacing: 8,
          children: List.generate(options.length, (index) {
            final isSelected = index == selectedIndex;
            return GestureDetector(
              onTap: () => onColorSelected(index),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 32,
                    height: 32,
                    decoration: BoxDecoration(
                      color: _colorFor(options[index]),
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: isSelected
                            ? AppColors.primary
                            : AppColors.border,
                        width: isSelected ? 2 : 1,
                      ),
                    ),
                    child: isSelected
                        ? Center(
                            child: Icon(
                              Icons.check,
                              size: 16,
                              color: _colorFor(options[index]) == Colors.white
                                  ? AppColors.textPrimary
                                  : Colors.white,
                            ),
                          )
                        : null,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    options[index],
                    style: const TextStyle(
                      fontSize: 11,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            );
          }),
        ),
      ],
    );
  }
}
