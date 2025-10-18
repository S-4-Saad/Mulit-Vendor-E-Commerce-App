import 'package:flutter/material.dart';
import 'package:speezu/core/utils/labels.dart';
import 'package:speezu/widgets/rating_display_widget.dart';

import '../core/assets/font_family.dart';
import 'app_cache_image.dart';

class ShopBox extends StatelessWidget {
  const ShopBox({
    super.key,
    required this.imageUrl,
    required this.shopName,
    required this.shopDescription,
    required this.shopRating,
    required this.onShopBoxTap,
    required this.onDirectionTap,
    required this.isOpen,
    required this.isDelivering,
  });
  final String imageUrl;
  final String shopName;
  final String shopDescription;
  final double shopRating;
  final VoidCallback onShopBoxTap;
  final VoidCallback onDirectionTap;
  final bool isOpen;
  final bool isDelivering;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onShopBoxTap,
      child: Container(
        clipBehavior: Clip.antiAlias,
        margin: EdgeInsets.only(right: 8, bottom: 5, top: 5),

        width: 270,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: Theme.of(context).colorScheme.onPrimary,
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withValues(alpha: 0.2),
              spreadRadius: 1,
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          children: [
            Stack(
              alignment: Alignment.bottomLeft,
              children: [
                AppCacheImage(
                  imageUrl: imageUrl,
                  height: 130,
                  round: 0,
                  width: 270,
                  boxFit: BoxFit.cover,
                ),
                Positioned(
                  bottom: 10,

                  left: 10,
                  child: Row(
                    children: [
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: isOpen ? Colors.green : Colors.red,
                          borderRadius: BorderRadius.circular(50),
                        ),
                        child: Center(
                          child: Text(
                            isOpen ? Labels.open : Labels.closed,
                            style: TextStyle(
                              color: Colors.white,
                              fontFamily: FontFamily.fontsPoppinsRegular,
                              fontSize: 12,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(width: 10),
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: isDelivering ? Colors.blue : Colors.orange,
                          borderRadius: BorderRadius.circular(50),
                        ),
                        child: Center(
                          child: Text(
                            isDelivering ? Labels.delivery : Labels.pickUp,
                            style: TextStyle(
                              color: Colors.white,
                              fontFamily: FontFamily.fontsPoppinsRegular,
                              fontSize: 12,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),

            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    width: 180,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          shopName,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontFamily: FontFamily.fontsPoppinsSemiBold,
                            fontSize: 16,
                            color: Theme.of(context).colorScheme.primary,
                            height: 1,
                          ),
                        ),
                        Text(
                          shopDescription,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontFamily: FontFamily.fontsPoppinsRegular,
                            fontSize: 13,
                            color: Theme.of(context).colorScheme.onSecondary,
                          ),
                        ),
                        RatingDisplayWidget(rating: shopRating, starSize: 17),
                      ],
                    ),
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Theme.of(context).colorScheme.primary,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5),
                      ),
                      padding: EdgeInsets.symmetric(horizontal: 8),

                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      elevation: 0,
                    ),
                    onPressed: onDirectionTap,
                    child: Icon(
                      Icons.directions,
                      color: Colors.white,
                      size: 25,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ShopBoxBigWidget extends StatelessWidget {
  const ShopBoxBigWidget({
    super.key,
    required this.imageUrl,
    required this.shopName,
    required this.shopDescription,
    required this.shopRating,
    required this.onShopBoxTap,
    required this.onDirectionTap,
    required this.isOpen,
    required this.isDelivering,
  });
  final String imageUrl;
  final String shopName;
  final String shopDescription;
  final double shopRating;
  final VoidCallback onShopBoxTap;
  final VoidCallback onDirectionTap;
  final bool isOpen;
  final bool isDelivering;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onShopBoxTap,
      child: Container(
        clipBehavior: Clip.antiAlias,
        margin: EdgeInsets.only(right: 5, bottom: 5, top: 5, left: 5),

        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: Theme.of(context).colorScheme.onPrimary,
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withValues(alpha: 0.2),
              spreadRadius: 1,
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          children: [
            Stack(
              alignment: Alignment.bottomLeft,
              children: [
                AppCacheImage(
                  imageUrl: imageUrl,
                  height: 200,
                  round: 0,
                  width: double.infinity,
                  boxFit: BoxFit.cover,
                ),
                Positioned(
                  bottom: 10,

                  left: 10,
                  child: Row(
                    children: [
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: isOpen ? Colors.green : Colors.red,
                          borderRadius: BorderRadius.circular(50),
                        ),
                        child: Center(
                          child: Text(
                            isOpen ? Labels.open : Labels.closed,
                            style: TextStyle(
                              color: Colors.white,
                              fontFamily: FontFamily.fontsPoppinsRegular,
                              fontSize: 12,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(width: 10),
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: isDelivering ? Colors.blue : Colors.orange,
                          borderRadius: BorderRadius.circular(50),
                        ),
                        child: Center(
                          child: Text(
                            isDelivering ? Labels.delivery : Labels.pickUp,
                            style: TextStyle(
                              color: Colors.white,
                              fontFamily: FontFamily.fontsPoppinsRegular,
                              fontSize: 12,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Positioned(
                  top: 10,

                  right: 10,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.5),
                      borderRadius: BorderRadius.circular(50),
                    ),
                    child: RatingDisplayWidget(
                      rating: shopRating,
                      starSize: 17,
                    ),
                  ),
                ),
              ],
            ),

            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          shopName,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontFamily: FontFamily.fontsPoppinsSemiBold,
                            fontSize: 18,
                            color: Theme.of(context).colorScheme.primary,
                            height: 1,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          shopDescription,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontFamily: FontFamily.fontsPoppinsRegular,
                            fontSize: 13,
                            color: Theme.of(context).colorScheme.onSecondary,
                          ),
                        ),
                      ],
                    ),
                  ),
                  // ElevatedButton(
                  //   style: ElevatedButton.styleFrom(
                  //     backgroundColor: Theme.of(context).colorScheme.primary,
                  //     shape: RoundedRectangleBorder(
                  //       borderRadius: BorderRadius.circular(5),
                  //     ),
                  //     padding: EdgeInsets.symmetric(horizontal: 8),
                  //
                  //     tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  //     elevation: 0,
                  //   ),
                  //   onPressed: onDirectionTap,
                  //   child: Icon(
                  //     Icons.directions,
                  //     color: Colors.white,
                  //     size: 25,
                  //   ),
                  // ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
