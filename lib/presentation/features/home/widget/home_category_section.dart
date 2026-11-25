import 'package:flutter/material.dart';
import '../../../../core/app_strings.dart';
import '../../../core/widgets/category_card.dart';
import '../../../core/widgets/product_section.dart';

class HomeCategorySection extends StatelessWidget {
  final List<Map<String, dynamic>> categories;

  const HomeCategorySection({
    super.key,
    required this.categories,
  });

  @override
  Widget build(BuildContext context) {
    return ProductSection(
      title: AppStrings.allCategories,
      onSeeAllTap: () {},
      itemCount: categories.length,
      itemSpacing: 12.0,
      itemBuilder: (context, index) {
        final cat = categories[index];
        return SizedBox(
          width: 75,
          child: CategoryCard(
            title: cat['title'],
            icon: cat['icon'],
            onTap: () {},
          ),
        );
      },
    );
  }
}
