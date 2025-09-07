import 'package:flutter/material.dart';
import 'package:speezu/core/utils/media_querry_extention.dart';

import '../core/assets/font_family.dart';

class FaqsExpansionTile extends StatelessWidget {
  const FaqsExpansionTile({
    super.key,
    required this.title,
    required this.answer,
  });

  final String title;
  final String answer;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 2,
      child: Theme(
        data: theme.copyWith(dividerColor: Colors.transparent),
        child: ExpansionTile(
          collapsedTextColor: theme.colorScheme.onSecondary,
          textColor: theme.colorScheme.onPrimary,
          tilePadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          collapsedShape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          iconColor: theme.primaryColor,
          // collapsedBackgroundColor: theme.colorScheme.onPrimary,
          backgroundColor: theme.colorScheme.secondary,
          collapsedIconColor: theme.colorScheme.outline,
          leading: Icon(Icons.help_outline, color: theme.primaryColor),
          title: Text(
            title,
            style: TextStyle(
              fontFamily: FontFamily.fontsPoppinsSemiBold,
              fontSize: context.scaledFont(14),
            ),
          ),
          children: [
            Container(
              alignment: Alignment.centerLeft,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                border: Border(
                  top: BorderSide(
                    color: Theme.of(context).colorScheme.onSecondary,
                  ),
                ),
                color: theme.colorScheme.onPrimary,
              ),
              child: Text(
                answer,
                style: TextStyle(
                  fontFamily: FontFamily.fontsPoppinsRegular,
                  fontSize: context.scaledFont(12),
                  color: theme.colorScheme.onSecondary,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}