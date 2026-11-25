import 'package:flutter/material.dart';
import '../../../../core/app_colors.dart';
import '../../reviews/view/reviews_page.dart';

class ProductHeaderSection extends StatelessWidget {
  final int quantity;
  final VoidCallback onIncrement;
  final VoidCallback onDecrement;
  final bool isWished;
  final VoidCallback onWishlistTap;

  const ProductHeaderSection({
    super.key,
    required this.quantity,
    required this.onIncrement,
    required this.onDecrement,
    required this.isWished,
    required this.onWishlistTap,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Expanded(
              child: Text(
                'Happy New Year Special Deal\nSave 30%',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                  height: 1.3,
                ),
              ),
            ),
            const SizedBox(width: 12),
            Row(
              children: [
                _buildStepperButton(
                  icon: Icons.remove,
                  onPressed: onDecrement,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  child: Text(
                    quantity.toString().padLeft(2, '0'),
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textPrimary,
                    ),
                  ),
                ),
                _buildStepperButton(
                  icon: Icons.add,
                  isPrimary: true,
                  onPressed: onIncrement,
                ),
              ],
            ),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            const Icon(Icons.star, size: 18, color: AppColors.accent),
            const SizedBox(width: 4),
            const Text(
              '4.8',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(width: 12),
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const ReviewsPage()),
                );
              },
              child: const Text(
                'Reviews',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: AppColors.primary,
                ),
              ),
            ),
            const Spacer(),
            GestureDetector(
              onTap: onWishlistTap,
              child: Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: AppColors.primary,
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Icon(
                  isWished ? Icons.favorite : Icons.favorite_border,
                  size: 18,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildStepperButton({
    required IconData icon,
    VoidCallback? onPressed,
    bool isPrimary = false,
  }) {
    return InkWell(
      onTap: onPressed,
      borderRadius: BorderRadius.circular(6),
      child: Container(
        width: 28,
        height: 28,
        decoration: BoxDecoration(
          color: isPrimary ? AppColors.primary : AppColors.surface,
          borderRadius: BorderRadius.circular(6),
        ),
        child: Icon(
          icon,
          size: 16,
          color: isPrimary ? Colors.white : AppColors.textSecondary,
        ),
      ),
    );
  }
}
