import 'package:flutter/material.dart';
import '../../../../core/app_assets.dart';
import '../../../../core/app_colors.dart';

class HomeBannerCarousel extends StatefulWidget {
  const HomeBannerCarousel({super.key});

  @override
  State<HomeBannerCarousel> createState() => _HomeBannerCarouselState();
}

class _HomeBannerCarouselState extends State<HomeBannerCarousel> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        children: [
          Container(
            height: 150,
            decoration: BoxDecoration(
              color: AppColors.primaryDark,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Row(
              children: [
                Expanded(
                  flex: 4,
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Image.asset(
                      AppAssets.shoe,
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
                Expanded(
                  flex: 5,
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(20, 12, 14, 12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          'Happy New Year\nSpecial Deal\nSave 30%',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            height: 1.6,
                          ),
                        ),
                        const SizedBox(height: 8),
                        SizedBox(
                          height: 28,
                          width: 100,
                          child: ElevatedButton(
                            onPressed: () {},
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.white,
                              foregroundColor: AppColors.primary,
                              padding: const EdgeInsets.symmetric(horizontal: 14),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            child: const Text(
                              'Buy Now',
                              style: TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 6),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(4, (index) {
              final isActive = index == _currentIndex;
              return GestureDetector(
                onTap: () => setState(() => _currentIndex = index),
                child: Container(
                  margin: const EdgeInsets.symmetric(horizontal: 3),
                  width: isActive ? 14 : 6,
                  height: 6,
                  decoration: BoxDecoration(
                    color: isActive ? AppColors.primary : AppColors.surface,
                    borderRadius: BorderRadius.circular(3),
                    border: isActive
                        ? null
                        : Border.all(color: AppColors.border, width: 1),
                  ),
                ),
              );
            }),
          ),
        ],
      ),
    );
  }
}
