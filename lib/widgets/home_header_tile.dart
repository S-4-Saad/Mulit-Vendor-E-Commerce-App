import 'package:flutter/material.dart';
import 'package:speezu/core/utils/media_querry_extention.dart';

import '../core/assets/font_family.dart';
import '../core/utils/labels.dart';

class HomeHeaderTile extends StatelessWidget {
  const HomeHeaderTile({
    super.key,
    required this.title,
    required this.onViewAllTap,
  });
  final String title;
  final VoidCallback onViewAllTap;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          maxLines: 1,
          style: TextStyle(
            color: Theme.of(context).colorScheme.onSecondary,
            fontFamily: FontFamily.fontsPoppinsSemiBold,
            fontSize: context.scaledFont(15),
          ),
        ),
        InkWell(
          onTap: onViewAllTap,
          borderRadius: BorderRadius.circular(50),
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(50),
              border: Border.all(
                color: Theme.of(
                  context,
                ).colorScheme.onSecondary.withValues(alpha: .1),
              ),
            ),
            child: Text(
              Labels.viewAll,
              style: TextStyle(
                color: Theme.of(context).colorScheme.onSecondary,
                fontFamily: FontFamily.fontsPoppinsLight,
                fontSize: context.scaledFont(10),
              ),
            ),
          ),
        ),
      ],
    );
  }
}