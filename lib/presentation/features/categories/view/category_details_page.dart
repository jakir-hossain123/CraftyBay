import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../core/app_colors.dart';
import '../../../../data/models/category_model.dart';
import '../../../core/image_source.dart';
import '../viewmodel/category_details_provider.dart';

class CategoryDetailsPage extends StatelessWidget {
  final String categoryId;

  const CategoryDetailsPage({super.key, required this.categoryId});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) =>
          CategoryDetailsProvider()..fetchCategoryDetails(categoryId),
      child: _CategoryDetailsContent(categoryId: categoryId),
    );
  }
}

class _CategoryDetailsContent extends StatelessWidget {
  final String categoryId;

  const _CategoryDetailsContent({required this.categoryId});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<CategoryDetailsProvider>();
    final category = provider.category;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(
          category?.title ?? 'Category Details',
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w500,
            color: AppColors.textPrimary,
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, size: 18),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: category == null
          ? _buildLoadingOrError(context, provider)
          : _buildCategoryDetails(category),
    );
  }

  Widget _buildLoadingOrError(
    BuildContext context,
    CategoryDetailsProvider provider,
  ) {
    if (provider.isLoading) {
      return const Center(
        child: CircularProgressIndicator(color: AppColors.primary),
      );
    }

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              provider.errorMessage ?? 'Unable to load category details.',
              textAlign: TextAlign.center,
              style: const TextStyle(color: AppColors.textSecondary),
            ),
            const SizedBox(height: 12),
            TextButton(
              onPressed: () => context
                  .read<CategoryDetailsProvider>()
                  .fetchCategoryDetails(categoryId),
              child: const Text('Retry'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCategoryDetails(CategoryModel category) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Container(
              width: 160,
              height: 160,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(16),
              ),
              child: category.icon.isEmpty
                  ? const Icon(
                      Icons.category_outlined,
                      size: 72,
                      color: AppColors.primary,
                    )
                  : Image(
                      image: imageProviderFor(category.icon),
                      fit: BoxFit.contain,
                      errorBuilder: (context, error, stackTrace) => const Icon(
                        Icons.category_outlined,
                        size: 72,
                        color: AppColors.primary,
                      ),
                    ),
            ),
          ),
          const SizedBox(height: 28),
          Text(
            category.title,
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w700,
              color: AppColors.textPrimary,
            ),
          ),
          if (category.slug.isNotEmpty) ...[
            const SizedBox(height: 6),
            Text(
              category.slug,
              style: const TextStyle(
                fontSize: 14,
                color: AppColors.textSecondary,
              ),
            ),
          ],
          const SizedBox(height: 20),
          const Text(
            'About',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            category.description.isEmpty
                ? 'No description available.'
                : category.description,
            style: const TextStyle(
              fontSize: 14,
              height: 1.6,
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }
}
