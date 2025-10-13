import 'package:flutter/material.dart';
import 'package:speezu/core/utils/media_querry_extention.dart';

import '../core/assets/font_family.dart';
import 'app_cache_image.dart';
import 'rating_display_widget.dart';

class ProductReviewBox extends StatelessWidget {
  const ProductReviewBox({
    super.key,
    required this.userName,
    required this.review,
    required this.rating,
    // required this.imgUrl,
  });

  final String userName;
  final String review;
  final double rating;
  // final String imgUrl;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(height: context.heightPct(.01)),
        Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    RatingDisplayWidget(
                      rating: rating,
                      starSize: context.scaledFont(16),
                    ),
                    SizedBox(width: 8),
                    Text(
                      userName,
                      style: TextStyle(
                        fontSize: 15,
                        fontFamily: FontFamily.fontsPoppinsMedium,
                        color: Theme.of(context).colorScheme.outline,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 5),
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

            // AppCacheImage(
            //   imageUrl: imgUrl,
            //   height: context.heightPct(.07),
            //   width: context.heightPct(.07),
            //   round: 5,
            // ),
          ],
        ),
      ],
    );
  }
}