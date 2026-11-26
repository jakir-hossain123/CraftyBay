import 'package:crafty_bay/core/app_colors.dart';
import 'package:crafty_bay/core/app_strings.dart';
import 'package:crafty_bay/presentation/features/home/viewmodel/home_provider.dart';
import 'package:crafty_bay/presentation/features/home/widget/home_app_bar.dart';
import 'package:crafty_bay/presentation/features/home/widget/home_banner_carousel.dart';
import 'package:crafty_bay/presentation/features/home/widget/home_category_section.dart';
import 'package:crafty_bay/presentation/features/home/widget/home_product_section.dart';
import 'package:crafty_bay/presentation/features/home/widget/home_search_bar.dart';
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
      context.read<HomeProvider>().loadHomeData();
    });
  }

  @override
  Widget build(BuildContext context) {
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
            HomeBannerCarousel(slides: homeProvider.slides),
            const SizedBox(height: 20),
            HomeCategorySection(categories: homeProvider.categories),
            const SizedBox(height: 8),
            HomeProductSection(
              title: AppStrings.popular,
              products: homeProvider.products,
            ),
            HomeProductSection(
              title: AppStrings.special,
              products: homeProvider.products,
            ),
            HomeProductSection(
              title: AppStrings.newArrival,
              products: homeProvider.products,
            ),
          ],
        ),
      ),
    );
  }
}
