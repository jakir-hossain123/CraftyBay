import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../core/app_colors.dart';
import '../../../../core/app_strings.dart';
import '../../cart/view/cart_page.dart';
import '../../categories/viewmodel/category_provider.dart';
import '../../home/view/home_page.dart';
import '../../wishlist/view/wishlist_page.dart';
import '../../../core/widgets/category_card.dart';
import '../../../core/widgets/category_grid_page.dart';

class MainNavPage extends StatefulWidget {
  const MainNavPage({super.key});

  @override
  State<MainNavPage> createState() => _MainNavPageState();
}

class _MainNavPageState extends State<MainNavPage> {
  int _currentIndex = 0;

  final List<Widget> _pages = const [
    HomePage(),
    CategoriesTabPage(),
    CartPage(),
    WishlistPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) => setState(() => _currentIndex = index),
        type: BottomNavigationBarType.fixed,
        selectedItemColor: AppColors.primary,
        unselectedItemColor: AppColors.textSecondary,
        backgroundColor: Colors.white,
        elevation: 8,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            activeIcon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.grid_view_outlined),
            activeIcon: Icon(Icons.grid_view),
            label: 'Categories',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.shopping_basket_outlined),
            activeIcon: Icon(Icons.shopping_basket),
            label: 'Cart',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.card_giftcard_outlined),
            activeIcon: Icon(Icons.card_giftcard),
            label: 'Wish',
          ),
        ],
      ),
    );
  }
}

class CategoriesTabPage extends StatelessWidget {
  const CategoriesTabPage({super.key});

  @override
  Widget build(BuildContext context) {
    final categoryProvider = context.watch<CategoryProvider>();
    final categories = categoryProvider.categories;

    return CategoryGridPage(
      title: AppStrings.allCategories,
      itemCount: categories.isNotEmpty ? categories.length : 4,
      itemBuilder: (context, index) {
        if (categories.isNotEmpty) {
          final cat = categories[index];
          return CategoryCard(
            title: cat.title,
            imageUrl: cat.icon,
            onTap: () {},
          );
        } else {
          final defaults = [
            {'title': 'Electronics', 'icon': Icons.tv},
            {'title': 'Food', 'icon': Icons.fastfood},
            {'title': 'Fashion', 'icon': Icons.diamond},
            {'title': 'Furniture', 'icon': Icons.weekend},
          ];
          final cat = defaults[index % defaults.length];
          return CategoryCard(
            title: cat['title'] as String,
            icon: cat['icon'] as IconData,
            onTap: () {},
          );
        }
      },
    );
  }
}
