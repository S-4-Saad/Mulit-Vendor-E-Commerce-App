import 'package:flutter/material.dart';

import '../core/assets/font_family.dart';
import '../core/utils/currency_icon.dart';
import '../core/utils/labels.dart';
import 'app_cache_image.dart';

class OrderDetailsProductTile extends StatelessWidget {
  const OrderDetailsProductTile({
    super.key,
    required this.imageUrl,
    required this.productName,
    this.variationParentName,
    this.variationParentValue,
    this.variationChildName,
    this.variationChildValue,
    required this.price,
    required this.originalPrice,
    required this.onTrackTap,
    required this.shopName,
    required this.onReviewTap,
  });

  final String imageUrl;
  final String productName;
  final String? variationParentName;
  final String? variationParentValue;
  final String? variationChildName;
  final String? variationChildValue;
  final String shopName;
  final VoidCallback onReviewTap;
  final VoidCallback onTrackTap;
  final String price;
  final String originalPrice;

  @override
  Widget build(BuildContext context) {
    bool isDiscounted = price != originalPrice;

    return LayoutBuilder(
      builder: (context, constraints) {
        final tileWidth = constraints.maxWidth;

        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15.0),
          child: Stack(
            children: [
              Container(
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
                child: Column(
                  children: [
                    SizedBox(height: 5),
                    Row(
                      children: [
                        SizedBox(width: isDiscounted ? 55 : 10),
                        Icon(
                          Icons.store_mall_directory_outlined,
                          color: Theme.of(context).colorScheme.onSecondary,
                          size: 27,
                        ),
                        SizedBox(width: 5),
                        Text(
                          productName,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontFamily: FontFamily.fontsPoppinsRegular,
                            fontSize: 15,
                            color: Theme.of(context).colorScheme.onSecondary,
                          ),
                        ),
                        Spacer(),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            tapTargetSize:
                            MaterialTapTargetSize
                                .shrinkWrap, // removes extra margin
                            visualDensity: VisualDensity.compact,
                            minimumSize: Size(0, 30),
                            backgroundColor: Color(0xFFffbf00),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(5),
                            ),

                            padding: EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 5,
                            ),
                          ),
                          onPressed: onReviewTap,
                          child: Text(
                            Labels.giveReview,
                            style: TextStyle(
                              fontFamily: FontFamily.fontsPoppinsRegular,
                              color: Colors.white,
                            ),
                          ),
                        ),
                        SizedBox(width: 10),
                      ],
                    ),
                    SizedBox(height: 5),
                    Divider(
                      height: 0,
                      color: Theme.of(
                        context,
                      ).colorScheme.outline.withValues(alpha: .3),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(10),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          /// Product Image
                          AppCacheImage(
                            imageUrl: imageUrl,
                            height: 80,
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
                                    fontSize: 14,
                                    color:
                                    Theme.of(
                                      context,
                                    ).colorScheme.onSecondary,
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
                                      fontFamily:
                                      FontFamily.fontsPoppinsRegular,
                                      fontSize: 13,
                                      color:
                                      Theme.of(
                                        context,
                                      ).colorScheme.onSecondary,
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
                                      fontFamily:
                                      FontFamily.fontsPoppinsRegular,
                                      fontSize: 13,
                                      color:
                                      Theme.of(
                                        context,
                                      ).colorScheme.onSecondary,
                                    ),
                                  ),

                                /// Price Row
                                Row(
                                  children: [
                                    Text(
                                      "${CurrencyIcon.currencyIcon}$price",
                                      style: TextStyle(
                                        fontFamily:
                                        FontFamily.fontsPoppinsSemiBold,
                                        fontSize: 16,
                                        color:
                                        Theme.of(
                                          context,
                                        ).colorScheme.primary,
                                      ),
                                    ),
                                    const SizedBox(width: 6),
                                    if (isDiscounted)
                                      Flexible(
                                        child: Text(
                                          "${CurrencyIcon.currencyIcon}$originalPrice",
                                          overflow: TextOverflow.ellipsis,
                                          style: TextStyle(
                                            fontFamily:
                                            FontFamily.fontsPoppinsRegular,
                                            fontSize: 12,
                                            color: Theme.of(context)
                                                .colorScheme
                                                .onSecondary
                                                .withValues(alpha: .5),
                                            decoration:
                                            TextDecoration.lineThrough,
                                          ),
                                        ),
                                      ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          IconButton(
                            onPressed: () {},
                            icon: Icon(Icons.arrow_forward_ios_outlined),
                          ),
                        ],
                      ),
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
                      horizontal: 10,
                      vertical: 3,
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
                      style: const TextStyle(color: Colors.white, fontSize: 13),
                    ),
                  ),
                ),
            ],
          ),
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
