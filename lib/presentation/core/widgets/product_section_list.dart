import 'package:flutter/material.dart';
import '../../../../core/app_colors.dart';

class ProductSectionList extends StatelessWidget {
  final String title;
  final VoidCallback? onSeeAllPressed;
  final int itemCount;
  final IndexedWidgetBuilder itemBuilder;
  final double height;
  final double itemWidth;

  const ProductSectionList({
    super.key,
    required this.title,
    this.onSeeAllPressed,
    required this.itemCount,
    required this.itemBuilder,
    this.height = 205.0,
    this.itemWidth = 140.0,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: AppColors.textPrimary,
              ),
            ),
            if (onSeeAllPressed != null)
              TextButton(
                onPressed: onSeeAllPressed,
                style: TextButton.styleFrom(
                  padding: EdgeInsets.zero,
                  minimumSize: Size.zero,
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ),
                child: const Text(
                  'See All',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: AppColors.primary,
                  ),
                ),
              ),
          ],
        ),
        const SizedBox(height: 10),
        SizedBox(
          height: height,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: itemCount,
            separatorBuilder: (context, index) => const SizedBox(width: 10),
            itemBuilder: (context, index) {
              return SizedBox(
                width: itemWidth,
                child: itemBuilder(context, index),
              );
            },
          ),
        ),
      ],
    );
  }
}
