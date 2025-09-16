import 'package:flutter/material.dart';

import '../core/assets/font_family.dart';
import '../core/utils/currency_icon.dart';
import 'app_cache_image.dart';

class CartListTile extends StatelessWidget {
  const CartListTile({
    super.key,
    required this.imageUrl,
    required this.productName,
    this.variationParentName,
    this.variationParentValue,
    this.variationChildName,
    this.variationChildValue,
    required this.price,
    required this.originalPrice,
    required this.quantity,
    required this.onAdd,
    required this.onRemove,
    required this.onDelete,
  });

  final String imageUrl;
  final String productName;
  final String? variationParentName;
  final String? variationParentValue;
  final String? variationChildName;
  final String? variationChildValue;
  final String price;
  final String originalPrice;
  final int quantity;
  final VoidCallback onAdd;
  final VoidCallback onRemove;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    bool isDiscounted = price != originalPrice;

    return LayoutBuilder(
      builder: (context, constraints) {
        final tileWidth = constraints.maxWidth;
        final textMaxWidth = tileWidth * 0.4; // adaptive instead of fixed

        return Stack(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.onPrimary,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: Theme.of(
                    context,
                  ).colorScheme.outline.withValues(alpha: .3),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withValues(alpha: 0.1),
                    spreadRadius: 1,
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  /// Product Image
                  AppCacheImage(
                    imageUrl: imageUrl,
                    height: 70,
                    width: 80,
                    round: 5,
                  ),
                  const SizedBox(width: 10),

                  /// Middle Column (Product info)
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        /// Product Name
                        Text(
                          productName,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontFamily: FontFamily.fontsPoppinsSemiBold,
                            fontSize: 12,
                            color: Theme.of(context).colorScheme.onSecondary,
                          ),
                        ),

                        /// Parent Variation
                        if (variationParentName != null &&
                            variationParentValue != null)
                          Text(
                            "$variationParentName: $variationParentValue",
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontFamily: FontFamily.fontsPoppinsRegular,
                              fontSize: 11,
                              color: Theme.of(context).colorScheme.onSecondary,
                            ),
                          ),

                        /// Child Variation
                        if (variationChildName != null &&
                            variationChildValue != null)
                          Text(
                            "$variationChildName: $variationChildValue",
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontFamily: FontFamily.fontsPoppinsRegular,
                              fontSize: 11,
                              color: Theme.of(context).colorScheme.onSecondary,
                            ),
                          ),

                        /// Price Row
                        Row(
                          children: [
                            Text(
                              "${CurrencyIcon.currencyIcon}$price",
                              style: TextStyle(
                                fontFamily: FontFamily.fontsPoppinsSemiBold,
                                fontSize: 14,
                                color: Theme.of(context).colorScheme.primary,
                              ),
                            ),
                            const SizedBox(width: 6),
                            if (isDiscounted)
                              Flexible(
                                child: Text(
                                  "${CurrencyIcon.currencyIcon}$originalPrice",
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    fontFamily: FontFamily.fontsPoppinsRegular,
                                    fontSize: 11,
                                    color: Theme.of(context)
                                        .colorScheme
                                        .onSecondary
                                        .withValues(alpha: .5),
                                    decoration: TextDecoration.lineThrough,
                                  ),
                                ),
                              ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  /// Quantity & Delete
                  Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            onPressed: onRemove,
                            icon: const Icon(
                              Icons.remove_circle_outline,
                              size: 20,
                            ),
                          ),
                          Text(
                            quantity.toString(),
                            style: TextStyle(
                              fontSize: 15,
                              fontFamily: FontFamily.fontsPoppinsSemiBold,
                              color: Theme.of(context).colorScheme.onSecondary,
                            ),
                          ),
                          IconButton(
                            onPressed: onAdd,
                            icon: const Icon(
                              Icons.add_circle_outline,
                              size: 20,
                            ),
                          ),
                        ],
                      ),
                      IconButton(
                        padding: EdgeInsets.zero,
                        constraints: const BoxConstraints(),
                        splashRadius: 20,
                        style: ButtonStyle(
                          // backgroundColor: MaterialStateProperty.all(Colors.red.withValues(alpha: .1)),
                          // minimumSize: MaterialStateProperty.all(const Size(10, 10)),
                          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        ),
                        onPressed: onDelete,
                        icon: Icon(
                          Icons.delete_outline,
                          size: 25,
                          color: Theme.of(context).colorScheme.error,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            /// Discount Badge
            if (isDiscounted)
              Positioned(
                top: 0,
                left: 0,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 6,
                    vertical: 2,
                  ),
                  decoration: const BoxDecoration(
                    color: Colors.red,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(12),
                      bottomRight: Radius.circular(12),
                    ),
                  ),
                  child: Text(
                    '-${calculatePercentage(originalPrice, price)}%',
                    style: const TextStyle(color: Colors.white, fontSize: 10),
                  ),
                ),
              ),
          ],
        );
      },
    );
  }

  calculatePercentage(String originalPrice, String discountedPrice) {
    final original = double.tryParse(originalPrice) ?? 0;
    final discounted = double.tryParse(discountedPrice) ?? 0;
    if (original == 0) return 0;
    return ((original - discounted) / original * 100).round();
  }
}