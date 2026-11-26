import 'package:flutter/material.dart';

class ReviewItem {
  final String name;
  final String reviewText;

  ReviewItem({required this.name, required this.reviewText});
}

class ReviewProvider extends ChangeNotifier {
  final List<ReviewItem> _reviews = List.generate(
    5,
    (index) => ReviewItem(
      name: 'Rabbil Hasan',
      reviewText:
          'Reference site about Lorem Ipsum, giving information on its origins, as well as a random Lipsum generator Reference site about Lorem Ipsum, giving information on its origins, as well as a random Lipsum generator',
    ),
  );

  List<ReviewItem> get reviews => _reviews;

  void addReview(String firstName, String lastName, String reviewText) {
    _reviews.insert(
      0,
      ReviewItem(
        name: '$firstName $lastName',
        reviewText: reviewText,
      ),
    );
    notifyListeners();
  }
}
