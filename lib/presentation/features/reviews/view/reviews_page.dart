import 'package:flutter/material.dart';
import '../../../../core/app_colors.dart';
import '../../../core/widgets/review_bottom_bar.dart';
import '../../../core/widgets/review_item_card.dart';
import '../../create_review/view/create_review_page.dart';

class ReviewsPage extends StatelessWidget {
  const ReviewsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final reviews = List.generate(
      5,
      (index) => {
        'name': 'Rabbil Hasan',
        'review':
            'Reference site about Lorem Ipsum, giving information on its origins, as well as a random Lipsum generator Reference site about Lorem Ipsum, giving information on its origins, as well as a random Lipsum generator',
      },
    );

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text(
          'Reviews',
          style: TextStyle(
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
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: reviews.length,
        itemBuilder: (context, index) {
          final review = reviews[index];
          return ReviewItemCard(
            name: review['name']!,
            reviewText: review['review']!,
          );
        },
      ),
      bottomNavigationBar: ReviewBottomBar(
        title: 'Reviews (${reviews.length})',
        onActionPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const CreateReviewPage()),
          );
        },
      ),
    );
  }
}
