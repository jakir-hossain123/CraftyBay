import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../core/app_colors.dart';
import '../../../../data/models/brand_model.dart';
import '../../../core/image_source.dart';
import '../viewmodel/brand_details_provider.dart';

class BrandDetailsPage extends StatelessWidget {
  final String brandId;

  const BrandDetailsPage({super.key, required this.brandId});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => BrandDetailsProvider()..fetchBrandDetails(brandId),
      child: _BrandDetailsContent(brandId: brandId),
    );
  }
}

class _BrandDetailsContent extends StatelessWidget {
  final String brandId;

  const _BrandDetailsContent({required this.brandId});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<BrandDetailsProvider>();
    final brand = provider.brand;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(
          brand?.title ?? 'Brand Details',
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
      body: brand == null
          ? _buildLoadingOrError(context, provider)
          : _buildBrandDetails(brand),
    );
  }

  Widget _buildLoadingOrError(
    BuildContext context,
    BrandDetailsProvider provider,
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
              provider.errorMessage ?? 'Unable to load brand details.',
              textAlign: TextAlign.center,
              style: const TextStyle(color: AppColors.textSecondary),
            ),
            const SizedBox(height: 12),
            TextButton(
              onPressed: () => provider.fetchBrandDetails(brandId),
              child: const Text('Retry'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBrandDetails(BrandModel brand) {
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
              child: brand.icon.isEmpty
                  ? const Icon(
                      Icons.storefront_outlined,
                      size: 72,
                      color: AppColors.primary,
                    )
                  : Image(
                      image: imageProviderFor(brand.icon),
                      fit: BoxFit.contain,
                      errorBuilder: (context, error, stackTrace) => const Icon(
                        Icons.storefront_outlined,
                        size: 72,
                        color: AppColors.primary,
                      ),
                    ),
            ),
          ),
          const SizedBox(height: 28),
          Text(
            brand.title,
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w700,
              color: AppColors.textPrimary,
            ),
          ),
          if (brand.slug.isNotEmpty) ...[
            const SizedBox(height: 6),
            Text(
              brand.slug,
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
            brand.description.isEmpty
                ? 'No description available.'
                : brand.description,
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
