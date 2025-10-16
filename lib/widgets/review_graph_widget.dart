import 'package:flutter/material.dart';
import 'package:speezu/widgets/rating_display_widget.dart';

import '../core/assets/font_family.dart';

class ReviewGraphWidget extends StatelessWidget {
  final ReviewData reviewData;

  const ReviewGraphWidget({super.key, required this.reviewData});

  @override
  Widget build(BuildContext context) {
    // Calculate the maximum number of reviews to scale the bars
    final maxReviews = [
      reviewData.oneStar,
      reviewData.twoStar,
      reviewData.threeStar,
      reviewData.fourStar,
      reviewData.fiveStar,
    ].reduce((a, b) => a > b ? a : b);

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.onSecondary.withValues(
          alpha: 0.06,
        ), // Light gray background
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Bar Graph
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildRatingBar(context, 5, reviewData.fiveStar, maxReviews),
                  _buildRatingBar(context, 4, reviewData.fourStar, maxReviews),
                  _buildRatingBar(context, 3, reviewData.threeStar, maxReviews),
                  _buildRatingBar(context, 2, reviewData.twoStar, maxReviews),
                  _buildRatingBar(context, 1, reviewData.oneStar, maxReviews),
                ],
              ),
              // Summary
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    reviewData.averageRating.toStringAsFixed(1),
                    style: TextStyle(
                      fontSize: 40,
                      fontFamily: FontFamily.fontsPoppinsBold,
                      color: Theme.of(context).colorScheme.onSecondary,
                    ),
                  ),
                  RatingDisplayWidget(
                    rating: reviewData.averageRating,
                    starSize: 20,
                  ),
                  SizedBox(height: 10),
                  Text(
                    '${reviewData.totalReviews} Reviews',
                    style: TextStyle(
                      fontSize: 14,
                      fontFamily: FontFamily.fontsPoppinsRegular,
                      color: Theme.of(context).colorScheme.onSecondary,
                    ),
                  ),
                ],
              ),
            ],
          ),
          SizedBox(height: 10),
        ],
      ),
    );
  }

  Widget _buildRatingBar(
    BuildContext context,
    int stars,
    int count,
    int maxReviews,
  ) {
    final barWidth = (count / maxReviews) * 130; // Scale bar width (max 150w)
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Row(
            children: [
              SizedBox(
                width: 15,
                child: Text(
                  stars.toString(),
                  style: TextStyle(
                    fontSize: 15,
                    color: Theme.of(context).colorScheme.onSecondary,
                    fontFamily: FontFamily.fontsPoppinsMedium,
                  ),
                ),
              ),
              Icon(
                Icons.star,
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
            ],
          ),
          SizedBox(width: 10),
          Container(
            height: 8,
            width: barWidth > 0 ? barWidth : 0, // Avoid negative width
            decoration: BoxDecoration(
              color:
                  Theme.of(
                    context,
                  ).colorScheme.primary, // Match the green bars from the image
              borderRadius: BorderRadius.circular(5),
            ),
          ),
          SizedBox(width: 10),
          Text(
            '$count',
            style: TextStyle(
              fontSize: 12,
              color: Theme.of(context).colorScheme.outline,
              fontFamily: FontFamily.fontsPoppinsRegular,
            ),
          ),
        ],
      ),
    );
  }
}

class ReviewData {
  final int oneStar;
  final int twoStar;
  final int threeStar;
  final int fourStar;
  final int fiveStar;
  final int totalReviews;

  ReviewData({
    required this.oneStar,
    required this.twoStar,
    required this.threeStar,
    required this.fourStar,
    required this.fiveStar,
  }) : assert(
         oneStar >= 0 &&
             twoStar >= 0 &&
             threeStar >= 0 &&
             fourStar >= 0 &&
             fiveStar >= 0,
         'Review counts must be non-negative',
       ),
       totalReviews = oneStar + twoStar + threeStar + fourStar + fiveStar;

  // Calculate the average rating dynamically, capped at 5.0
  double get averageRating {
    if (totalReviews == 0) return 0.0;
    final average =
        (1 * oneStar +
            2 * twoStar +
            3 * threeStar +
            4 * fourStar +
            5 * fiveStar) /
        totalReviews;
    return average > 5.0
        ? 5.0
        : average; // Cap at 5.0 (shouldn't happen with valid data)
  }
}
