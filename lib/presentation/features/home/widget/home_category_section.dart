import 'package:flutter/material.dart';
import '../../../../core/app_strings.dart';
import '../../../core/widgets/category_card.dart';
import '../../../core/widgets/product_section_list.dart';

class HomeCategorySection extends StatelessWidget {
  final List<Map<String, dynamic>> categories;

  const HomeCategorySection({
    super.key,
    required this.categories,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: ProductSectionList(
        title: AppStrings.allCategories,
        onSeeAllPressed: () {},
        itemCount: categories.length,
        height: 100,
        itemWidth: 80,
        itemBuilder: (context, index) {
          final cat = categories[index];
          return CategoryCard(
            title: cat['title'],
            icon: cat['icon'],
            onTap: () {},
          );
        },
      ),
    );
  }
}
