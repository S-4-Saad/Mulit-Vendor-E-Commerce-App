import 'package:flutter/material.dart';
import 'package:speezu/core/utils/labels.dart';

class EmptyFavouritesWidget extends StatelessWidget {
  const EmptyFavouritesWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(40.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Premium animated heart icon with gradient
            TweenAnimationBuilder<double>(
              duration: const Duration(milliseconds: 1500),
              tween: Tween(begin: 0.8, end: 1.0),
              curve: Curves.easeInOut,
              builder: (context, scale, child) {
                return Transform.scale(
                  scale: scale,
                  child: child,
                );
              },
              child: Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: LinearGradient(
                    colors: [
                      Colors.pink.shade100,
                      Colors.red.shade100,
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.pink.withOpacity(0.3),
                      blurRadius: 30,
                      spreadRadius: 5,
                    ),
                  ],
                ),
                child: Icon(
                  Icons.favorite_outline_rounded,
                  size: 80,
                  color: Colors.pink.shade400,
                ),
              ),
            ),
            const SizedBox(height: 32),

            // Main title
            Text(
              Labels.noFavouritesYet,
              style: TextStyle(
                color: Theme.of(context).colorScheme.onSecondary,
                fontSize: 24,
                fontWeight: FontWeight.bold,
                letterSpacing: 0.5,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 12),

            // Description
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Text(
              Labels.startAddingFavProducts,
                style: TextStyle(
                  color: Theme.of(context).colorScheme.onSecondary.withValues(alpha: .5),
                  fontSize: 15,
                  height: 1.6,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: 32),

            // Decorative elements
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildDecorativeIcon(Icons.star_rounded, Colors.amber),
                const SizedBox(width: 16),
                _buildDecorativeIcon(Icons.favorite_rounded, Colors.pink),
                const SizedBox(width: 16),
                _buildDecorativeIcon(Icons.shopping_bag_rounded, Colors.blue),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDecorativeIcon(IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        shape: BoxShape.circle,
      ),
      child: Icon(
        icon,
        size: 24,
        color: color.withOpacity(0.7),
      ),
    );
  }
}

// Usage:
// const PremiumEmptyFavouritesWidget()