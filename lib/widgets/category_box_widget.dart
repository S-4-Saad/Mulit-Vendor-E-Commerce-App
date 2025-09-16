import 'package:flutter/material.dart';
import 'package:speezu/core/utils/media_querry_extention.dart';

import '../core/assets/font_family.dart';
import 'image_type_extention.dart';

class CategoryBoxWidget extends StatelessWidget {
  const CategoryBoxWidget({
    super.key,
    required this.title,
    required this.imageUrl,
    required this.onTap,
  });
  final String title;
  final String imageUrl;
  final VoidCallback onTap;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 3,vertical: 5),
      child: GestureDetector(
        onTap: onTap,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(

              height: 80,
              width: 80,
              // padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.onPrimary,
                borderRadius: BorderRadius.circular(5),
                boxShadow: [
                  BoxShadow(
                    color: Theme.of(
                      context,
                    ).colorScheme.onSecondary.withValues(alpha: .2),
                    spreadRadius: 2,
                    blurRadius: 5,
                    offset: const Offset(1, 1), // changes position of shadow
                  ),
                ],
              ),
              child: Center(
                child: CustomImageView(
                  imagePath: imageUrl,
                  fit: BoxFit.fitWidth,
                  // width: context.heightPct(.9),
                  // height: context.heightPct(.3),
                ),
              ),
            ),
            SizedBox(
              height: context.heightPct(.005),
            ),


            SizedBox(
              width: context.heightPct(.1),
              child: Center(
                child: Text(
                  title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: context.scaledFont(10),
                    fontFamily: FontFamily.fontsPoppinsSemiBold,
                    color: Theme.of(context).colorScheme.onSecondary,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}