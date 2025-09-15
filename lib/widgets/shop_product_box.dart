import 'package:flutter/material.dart';
import 'package:speezu/widgets/rating_display_widget.dart';

import '../core/assets/font_family.dart';
import '../core/utils/labels.dart';
import 'app_cache_image.dart';

class ShopProductBox extends StatelessWidget {
  const ShopProductBox({super.key, required this.shopImageUrl, this.rating=50, this.shopName='',required this.onViewStoreTap, required this.categoryName});

  final String  shopImageUrl;
  final double rating;
  final String shopName;
  final String categoryName;
  final VoidCallback onViewStoreTap;

  @override
  Widget build(BuildContext context) {

    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    return   Container(
      padding: EdgeInsets.symmetric(
        horizontal: 10,
        vertical: 10,
      ),
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
        children: [
          Row(
            children: [
              AppCacheImage(
                imageUrl: shopImageUrl,
                height: 60,
                width:width*0.21 ,
                round: 5,
              ),
              SizedBox(width: 8),
              Column(crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      categoryName,
                      style: TextStyle(
                          color: Theme.of(context).colorScheme.onSecondary,
                          fontSize: 12,
                          fontFamily:FontFamily.fontsPoppinsRegular,
                          height: 1

                      ),
                    ),

                    SizedBox(
                      width: 130,
                      child: Text(
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        shopName,
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.onSecondary,
                          fontSize: 14,
                          fontFamily:FontFamily.fontsPoppinsSemiBold,

                        ),
                      ),
                    ),

                    RatingDisplayWidget(rating: rating,starSize: 15,)
                  ]
              ),
              Spacer(),
              GestureDetector(
                onTap: onViewStoreTap,
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color:Theme.of(context).colorScheme.primary,
                    borderRadius: BorderRadius.circular(3),

                  ),
                  child: Text(Labels.viewStore,style: TextStyle(
                    color:Theme.of(context).colorScheme.onPrimary,
                    fontSize: 12,
                    fontFamily: FontFamily.fontsPoppinsSemiBold,

                  ),),
                ),
              )
            ],
          ),

        ],
      ),
    );
  }
}
