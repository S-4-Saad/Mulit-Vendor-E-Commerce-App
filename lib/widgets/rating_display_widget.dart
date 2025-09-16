import 'package:flutter/material.dart';

class RatingDisplayWidget extends StatelessWidget {
  final double rating; // The rating value (0.0 to 5.0)
  final double starSize;

  const RatingDisplayWidget({
    super.key,
    required this.rating,
    this.starSize = 21, // Default star size
  });

  @override
  Widget build(BuildContext context) {
    // Clamp rating to ensure it’s between 0 and 5
    final clampedRating = rating.clamp(0.0, 5.0);
    final int fullStars = clampedRating.floor(); // Number of full stars
    final bool hasHalfStar = clampedRating - fullStars >= 0.5; // Check for half star
    final int totalStars = 5; // Total stars (fixed at 5)

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(totalStars, (index) {
        if (index < fullStars) {
          // Full star (yellow)
          return Icon(
            Icons.star,
            color:  Theme.of(context).colorScheme.onSurfaceVariant,
            size: starSize, // Responsive star size
          );
        } else if (index == fullStars && hasHalfStar) {
          // Half star (yellow half, grey half)
          return Icon(
            Icons.star_half,
            color: Theme.of(context).colorScheme.onSurfaceVariant,
            size: starSize,
          );
        } else {
          // Empty star (grey)
          return Icon(
            Icons.star_border,
            color: Theme.of(context).colorScheme.outline.withValues(alpha: 0.5),
            size: starSize,
          );
        }
      }),
    );
  }
}