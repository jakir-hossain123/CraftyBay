import 'package:flutter/material.dart';
import '../../../../core/app_strings.dart';
import '../../../../data/models/category_model.dart';
import '../../../core/widgets/category_card.dart';
import '../../../core/widgets/category_grid_page.dart';
import '../../../core/widgets/product_section.dart';

class HomeCategorySection extends StatelessWidget {
  final List<CategoryModel> categories;

  const HomeCategorySection({
    super.key,
    required this.categories,
  });

  @override
  Widget build(BuildContext context) {
    final displayCategories = categories.isEmpty
        ? [
            {'title': 'Electronics', 'icon': Icons.tv},
            {'title': 'Food', 'icon': Icons.fastfood},
            {'title': 'Fashion', 'icon': Icons.diamond},
            {'title': 'Furniture', 'icon': Icons.weekend},
          ]
        : categories;

    return ProductSection(
      title: AppStrings.allCategories,
      onSeeAllTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => CategoryGridPage(
              title: AppStrings.allCategories,
              itemCount: displayCategories.length,
              itemBuilder: (context, index) {
                final cat = displayCategories[index];
                final title = cat is CategoryModel ? cat.title : (cat as Map)['title'];
                final iconUrl = cat is CategoryModel ? cat.icon : null;
                final iconData = cat is Map ? cat['icon'] : Icons.category;

                return CategoryCard(
                  title: title,
                  icon: iconData is IconData ? iconData : Icons.category,
                  imageUrl: iconUrl,
                  onTap: () {},
                );
              },
            ),
          ),
        );
      },
      itemCount: displayCategories.length,
      itemSpacing: 12.0,
      itemBuilder: (context, index) {
        final cat = displayCategories[index];
        final title = cat is CategoryModel ? cat.title : (cat as Map)['title'];
        final iconUrl = cat is CategoryModel ? cat.icon : null;
        final iconData = cat is Map ? cat['icon'] : Icons.category;

        return SizedBox(
          width: 75,
          child: CategoryCard(
            title: title,
            icon: iconData is IconData ? iconData : Icons.category,
            imageUrl: iconUrl,
            onTap: () {},
          ),
        );
      },
    );
  }
}
