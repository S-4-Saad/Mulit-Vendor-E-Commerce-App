import 'package:flutter/material.dart';
import 'package:speezu/core/utils/labels.dart';

class NoProductsWidget extends StatelessWidget {
  const NoProductsWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(50.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Premium animated box icon with gradient
            TweenAnimationBuilder<double>(
              duration: const Duration(milliseconds: 1200),
              tween: Tween(begin: 0.0, end: 1.0),
              curve: Curves.elasticOut,
              builder: (context, value, child) {
                return Transform.translate(
                  offset: Offset(0, -20 * (1 - value)),
                  child: Opacity(
                    opacity: value.clamp(0.0, 1.0), // ✅ safe value
                    child: child,
                  ),
                );
              },
              child: Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: LinearGradient(
                    colors: [Theme.of(context).colorScheme.primary.withValues(alpha: .05), Theme.of(context).colorScheme.primary.withValues(alpha: .1)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Theme.of(context).colorScheme.primary.withValues(alpha: .2),
                      blurRadius: 25,
                      spreadRadius: 5,
                    ),
                  ],
                ),
                child: Icon(
                  Icons.inventory_2_outlined,
                  size: 72,
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
            ),

            const SizedBox(height: 28),

            // Main title
            Text(
              Labels.noProductsAvailable,
              style: TextStyle(
                color: Theme.of(context).colorScheme.onSecondary.withValues(alpha: .8),
                fontSize: 22,
                fontWeight: FontWeight.bold,
                letterSpacing: 0.3,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 12),

            // Description
            Text(
              Labels.weCouldNotFindStoreProducts,
              style: TextStyle(
                color: Theme.of(context).colorScheme.onSecondary.withValues(alpha: .4),
                fontSize: 14,
                height: 1.6,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 28),

            // Decorative wave pattern
            // Row(
            //   mainAxisAlignment: MainAxisAlignment.center,
            //   children: List.generate(5, (index) {
            //     return Padding(
            //       padding: const EdgeInsets.symmetric(horizontal: 3),
            //       child: TweenAnimationBuilder<double>(
            //         duration: Duration(milliseconds: 800 + (index * 100)),
            //         tween: Tween(begin: 0.0, end: 1.0),
            //         curve: Curves.easeInOut,
            //         builder: (context, value, child) {
            //           return Opacity(
            //             opacity: value,
            //             child: Container(
            //               width: 8,
            //               height: 8,
            //               decoration: BoxDecoration(
            //                 shape: BoxShape.circle,
            //                 gradient: LinearGradient(
            //                   colors: [
            //                     Theme.of(context).colorScheme.primary,
            //                     Theme.of(context).colorScheme.primary.withValues(alpha: .2),
            //                   ],
            //                 ),
            //               ),
            //             ),
            //           );
            //         },
            //       ),
            //     );
            //   }),
            // ),
          ],
        ),
      ),
    );
  }
}

// Usage:
// products.isEmpty
//     ? const PremiumNoProductsWidget()
//     : YourProductsList()