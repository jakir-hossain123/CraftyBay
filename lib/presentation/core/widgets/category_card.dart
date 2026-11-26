import 'package:flutter/material.dart';
import '../../../../core/app_colors.dart';

class CategoryCard extends StatelessWidget {
  final String title;
  final IconData? icon;
  final String? imageUrl;
  final VoidCallback? onTap;
  final Color backgroundColor;
  final Color iconColor;
  final Color textColor;

  const CategoryCard({
    super.key,
    required this.title,
    this.icon,
    this.imageUrl,
    this.onTap,
    this.backgroundColor = AppColors.primaryLight,
    this.iconColor = AppColors.primary,
    this.textColor = AppColors.primary,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 64,
            height: 64,
            decoration: BoxDecoration(
              color: backgroundColor,
              borderRadius: BorderRadius.circular(14),
            ),
            child: Center(
              child: imageUrl != null && imageUrl!.isNotEmpty
                  ? ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Image.network(
                        imageUrl!,
                        width: 32,
                        height: 32,
                        fit: BoxFit.contain,
                        errorBuilder: (context, error, stackTrace) => Icon(
                          icon ?? Icons.category,
                          size: 28,
                          color: iconColor,
                        ),
                      ),
                    )
                  : Icon(
                      icon ?? Icons.category,
                      size: 28,
                      color: iconColor,
                    ),
            ),
          ),
          const SizedBox(height: 6),
          Text(
            title,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: textColor,
            ),
          ),
        ],
      ),
    );
  }
}
