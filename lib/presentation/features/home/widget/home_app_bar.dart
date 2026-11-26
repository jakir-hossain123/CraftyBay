import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import '../../../../core/app_assets.dart';
import '../../../../core/app_colors.dart';
import '../../auth/auth_redirect.dart';
import '../../auth/viewmodel/auth_provider.dart';
import '../../cart/viewmodel/cart_provider.dart';
import '../../wishlist/viewmodel/wishlist_provider.dart';

class HomeAppBar extends StatelessWidget implements PreferredSizeWidget {
  const HomeAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          SvgPicture.asset(AppAssets.logoNav, height: 28),
          Row(
            children: [
              _buildActionIcon(Icons.person_outline, () {}),
              const SizedBox(width: 8),
              _buildActionIcon(Icons.phone_outlined, () {}),
              const SizedBox(width: 8),
              _buildActionIcon(Icons.notifications_none, () {}),
              const SizedBox(width: 8),
              IconButton(
                tooltip: 'Logout (test)',
                onPressed: () async {
                  final authProvider = context.read<AuthProvider>();
                  final cartProvider = context.read<CartProvider>();
                  final wishlistProvider = context.read<WishlistProvider>();
                  await authProvider.logout();
                  cartProvider.clearRemoteItems();
                  wishlistProvider.clearRemoteItems();
                  if (!context.mounted) return;
                  AuthRedirect.reset();
                  AuthRedirect.toLogin();
                },
                icon: const Icon(Icons.logout, color: AppColors.icon),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildActionIcon(IconData icon, VoidCallback onPressed) {
    return InkWell(
      onTap: onPressed,
      borderRadius: BorderRadius.circular(18),
      child: Container(
        width: 36,
        height: 36,
        decoration: const BoxDecoration(
          color: AppColors.surface,
          shape: BoxShape.circle,
        ),
        child: Icon(icon, size: 20, color: AppColors.icon),
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(56);
}
