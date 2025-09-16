import 'package:flutter/material.dart';
import 'package:speezu/core/utils/media_querry_extention.dart';

import '../core/assets/font_family.dart';

class CustomActionContainer extends StatelessWidget {
  final String text;
  final IconData icon;
  final VoidCallback onTap;

  const CustomActionContainer({
    super.key,
    required this.text,
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.onPrimary,
        border: Border.all(
          color: Theme.of(
            context,
          ).colorScheme.onSecondary.withValues(alpha: .21),
        ),
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Theme.of(
              context,
            ).colorScheme.onSecondary.withValues(alpha: .1),
            blurRadius: 6,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Text
          Expanded(
            child: Text(
              text,
              style: TextStyle(
                fontFamily:
                FontFamily
                    .fontsPoppinsRegular, // replace with your FontFamily
                color: Theme.of(context).colorScheme.onSecondary,
                fontSize: context.scaledFont(
                  12,
                ), // replace with context.scaledFont(12) if you use extensions
              ),
              overflow: TextOverflow.ellipsis,
              maxLines: 2,
            ),
          ),
          const SizedBox(width: 10),
          // Action Button
          IconButton(
            style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all(
                Theme.of(context).colorScheme.primary,
              ),
              padding: MaterialStateProperty.all(const EdgeInsets.all(12)),
            ),
            color: Theme.of(context).colorScheme.onPrimary,
            onPressed: onTap,
            icon: Icon(icon),
          ),
        ],
      ),
    );
  }
}
