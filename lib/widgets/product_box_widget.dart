import 'package:flutter/material.dart';
import '../core/assets/font_family.dart';
import '../core/utils/currency_icon.dart';
import 'app_cache_image.dart';

class ProductBox extends StatelessWidget {
  const ProductBox({
    super.key,
    required this.onProductTap,
    required this.productTitle,
    required this.productPrice,
    required this.productImageUrl,
    required this.productOriginalPrice,
    this.productRating = 0.0,
    this.productWidth = 165.0,
    this.marginPadding = const Padding(padding: EdgeInsets.only(right: 5, left: 5)),
    // this.isProductDiscounted = false,
    this.currencySymbol = CurrencyIcon.currencyIcon,
    this.productCategory,
    this.isProductFavourite = false,
    required this.onFavouriteTap,
  });

  final VoidCallback onProductTap;
  final double productWidth;
  final String productImageUrl;
  final String productTitle;
  final double productPrice;
  final double productOriginalPrice;
  final Padding marginPadding;
  final double productRating;
  final String currencySymbol;
  final String? productCategory;
  final bool isProductFavourite;
  final VoidCallback onFavouriteTap;

  @override
  Widget build(BuildContext context) {
    bool hasDiscount = productPrice < productOriginalPrice;
    double discount = 0.0;
    if (hasDiscount) {
      discount =
          ((productOriginalPrice - productPrice) / productOriginalPrice) * 100;
    }

    return GestureDetector(
      onTap: onProductTap,
      child: Stack(
        alignment: Alignment.topRight,
        children: [
          Container(
            width: productWidth,
            margin: marginPadding.padding,
            padding: EdgeInsets.all(10),
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
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Product Image with error handling
                Stack(
                  alignment: Alignment.topLeft,
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(7),
                      child: SizedBox(
                        // height:  heightRequire?155.h:null,
                        child: AppCacheImage(
                          height: 155,
                          width: double.infinity,
                          round: 7,
                          imageUrl:
                              productImageUrl.isEmpty
                                  ? 'https://codup.co/wp-content/uploads/2021/06/How-To-Fix-Failed-to-load-resource-net-ERR_BLOCKED_BY_CLIENT-Error.png-1.webp'
                                  : productImageUrl,
                        ),
                      ),
                    ),
                    if (hasDiscount)
                      Container(
                        height: 17,
                        width: 33,
                        decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.onSecondary,
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(7),
                            bottomRight: Radius.circular(7),
                          ),
                        ),
                        child: Center(
                          child: Text(
                            '${discount.toStringAsFixed(0)}%',
                            style: TextStyle(
                              fontFamily: FontFamily.fontsPoppinsSemiBold,
                              color: Theme.of(context).colorScheme.onPrimary,
                              fontSize: 8,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
                SizedBox(height: 5),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    if (productCategory != null && productCategory!.isNotEmpty)
                      Flexible(
                        child: Text(
                          productCategory!,
                          style: TextStyle(
                            fontFamily: FontFamily.fontsPoppinsLight,
                            color: Theme.of(
                              context,
                            ).colorScheme.onSecondary.withValues(alpha: .5),
                            fontSize: 8,
                          ),
                        ),
                      ),
                    if (productRating > 0)
                      Row(
                        children: [
                          Icon(
                            Icons.star,
                            color:
                                Theme.of(context).colorScheme.onSurfaceVariant,
                            size: 13,
                          ),
                          SizedBox(width: 3),
                          Text(
                            '(${productRating.toStringAsFixed(1)})',
                            style: TextStyle(
                              fontFamily: FontFamily.fontsPoppinsLight,
                              color: Theme.of(
                                context,
                              ).colorScheme.onSecondary.withValues(alpha: .5),
                              fontSize: 8,
                            ),
                          ),
                        ],
                      ),
                  ],
                ),

                Text(
                  productTitle.isEmpty ? 'Unnamed Product' : productTitle,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontFamily: FontFamily.fontsPoppinsSemiBold,
                    color: Theme.of(context).colorScheme.onSecondary,
                    fontSize: 9,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                SizedBox(height: 5),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Flexible(
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '$currencySymbol${productPrice.toStringAsFixed(1)}',
                            style: TextStyle(
                              fontFamily: FontFamily.fontsPoppinsSemiBold,
                              color: Theme.of(context).colorScheme.primary,
                              fontSize: 10,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          if (hasDiscount)
                            Padding(
                              padding: EdgeInsets.only(left: 5),
                              child: Text(
                                '$currencySymbol${productOriginalPrice.toStringAsFixed(1)}',
                                style: TextStyle(
                                  fontFamily: FontFamily.fontsPoppinsSemiBold,
                                  color: Theme.of(context)
                                      .colorScheme
                                      .onSecondary
                                      .withValues(alpha: 0.6),
                                  fontSize: 8,
                                  decoration: TextDecoration.lineThrough,
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),
                  ],
                ),


              ],
            ),
          ),
          Positioned(
            top: 8,
            right: 8,
            child: FloatingActionButton(
              heroTag: 'favourite_$productTitle',
              onPressed: onFavouriteTap,

              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(200),
              ),
              splashColor: Theme.of(
                context,
              ).colorScheme.primary.withValues(alpha: .2),
              mini: true,
              backgroundColor: Theme.of(
                context,
              ).colorScheme.onPrimary.withValues(alpha: .9),
              child: Icon(
                isProductFavourite
                    ? Icons.favorite
                    : Icons.favorite_border,
                color:
                    isProductFavourite
                        ? Theme.of(context).colorScheme.onTertiary
                        : Theme.of(
                          context,
                        ).colorScheme.onSecondary.withValues(alpha: .7),
                size: 20,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
