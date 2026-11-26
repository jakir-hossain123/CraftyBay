import 'package:crafty_bay/core/app_colors.dart';
import 'package:crafty_bay/core/app_strings.dart';
import 'package:crafty_bay/presentation/features/categories/viewmodel/category_provider.dart';
import 'package:crafty_bay/presentation/features/home/viewmodel/brand_provider.dart';
import 'package:crafty_bay/presentation/features/home/viewmodel/home_provider.dart';
import 'package:crafty_bay/presentation/features/home/viewmodel/slide_provider.dart';
import 'package:crafty_bay/presentation/features/home/widget/home_app_bar.dart';
import 'package:crafty_bay/presentation/features/home/widget/home_banner_carousel.dart';
import 'package:crafty_bay/presentation/features/home/widget/home_category_section.dart';
import 'package:crafty_bay/presentation/features/home/widget/home_product_section.dart';
import 'package:crafty_bay/presentation/features/home/widget/home_search_bar.dart';
import 'package:crafty_bay/presentation/features/products/viewmodel/product_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<SlideProvider>().fetchSlides();
      context.read<CategoryProvider>().fetchCategories();
      context.read<BrandProvider>().fetchBrands();
      context.read<ProductProvider>().fetchProducts();
    });
  }

  @override
  Widget build(BuildContext context) {
    final slideProvider = context.watch<SlideProvider>();
    final categoryProvider = context.watch<CategoryProvider>();
    final brandProvider = context.watch<BrandProvider>();
    final productProvider = context.watch<ProductProvider>();
    final homeProvider = context.watch<HomeProvider>();

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.only(bottom: 24),
          children: [
            const HomeAppBar(),
            const SizedBox(height: 8),
            const HomeSearchBar(),
            const SizedBox(height: 16),
            HomeBannerCarousel(slides: slideProvider.slides),
            const SizedBox(height: 20),
            HomeCategorySection(categories: categoryProvider.categories),
            const SizedBox(height: 8),
            HomeProductSection(
              title: 'Brands',
              items: brandProvider.brands.isNotEmpty
                  ? brandProvider.brands
                  : homeProvider.products,
            ),
            HomeProductSection(
              title: 'Products',
              items: productProvider.products.isNotEmpty
                  ? productProvider.products
                  : homeProvider.products,
            ),
            HomeProductSection(
              title: AppStrings.newArrival,
              items: homeProvider.products,
            ),
          ],
        ),
      ),
    );
  }
}
