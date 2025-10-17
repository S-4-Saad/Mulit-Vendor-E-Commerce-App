import 'package:flutter/material.dart';
import 'package:speezu/core/utils/media_querry_extention.dart';
import '../core/assets/font_family.dart';
import 'rating_display_widget.dart';

class ProductReviewBox extends StatelessWidget {
  const ProductReviewBox({
    super.key,
    required this.userName,
    required this.review,
    required this.rating,
  });

  final String userName;
  final String review;
  final double rating;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: context.heightPct(.01)),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Left side - review content
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    RatingDisplayWidget(
                      rating: rating,
                      starSize: context.scaledFont(16),
                    ),
                    const SizedBox(width: 8),
                    Flexible(
                      child: Text(
                        userName,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 15,
                          fontFamily: FontFamily.fontsPoppinsMedium,
                          color: Theme.of(context).colorScheme.outline,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 5),
                Text(
                  review,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: context.scaledFont(13),
                    fontFamily: FontFamily.fontsPoppinsRegular,
                    color: Theme.of(context).colorScheme.onSecondary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
