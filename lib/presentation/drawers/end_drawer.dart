import 'package:flutter/material.dart';
import 'package:speezu/core/assets/font_family.dart';
import 'package:speezu/core/utils/media_querry_extention.dart';
import '../../core/utils/labels.dart';

class EndDrawer extends StatelessWidget {
  const EndDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final titleStyle = TextStyle(
      fontSize: context.scaledFont(14),
      color: theme.colorScheme.primary,
      fontFamily: FontFamily.fontsPoppinsSemiBold,
    );

    final subTitleStyle = TextStyle(
      fontSize: context.scaledFont(12),
      color: theme.colorScheme.secondary,
      fontFamily: FontFamily.fontsPoppinsRegular,
    );

    return SafeArea(
      child: Drawer(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        child: Column(
          children: [
            // ---- Header ----
            Container(
              color: theme.colorScheme.secondary.withValues(alpha: .1),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    Labels.filters,
                    style: TextStyle(
                      fontSize: context.scaledFont(16),
                      fontFamily: FontFamily.fontsPoppinsSemiBold,
                      color: theme.colorScheme.onSecondary,
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      // TODO: Clear all filters
                    },
                    child: Text(
                      Labels.clear,
                      style: TextStyle(
                        fontSize: context.scaledFont(12),
                        fontFamily: FontFamily.fontsPoppinsRegular,
                        color: theme.colorScheme.error,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Divider(
              height: 0,
              thickness: 1,
              color: theme.colorScheme.onSecondary.withValues(alpha: .3),
            ),

            // ---- Scrollable Filters ----
            Expanded(
              child: ListView(
                padding: const EdgeInsets.all(12),
                children: [
                  _buildFilterSection(
                    context,
                    title: Labels.openedRestaurants,
                    children: [
                      CheckboxListTile(
                        title: Text(Labels.opened, style: subTitleStyle),
                        value: true,
                        onChanged: (value) {},
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  _buildFilterSection(
                    context,
                    title: Labels.deliveryOrPickUp,
                    children: [
                      CheckboxListTile(
                        title: Text(Labels.delivery, style: subTitleStyle),
                        value: true,
                        onChanged: (value) {},
                      ),
                      CheckboxListTile(
                        title: Text(Labels.pickUp, style: subTitleStyle),
                        value: false,
                        onChanged: (value) {},
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  _buildFilterSection(
                    context,
                    title: Labels.fields,
                    children: [
                      CheckboxListTile(
                        title: Text(Labels.all, style: subTitleStyle),
                        value: true,
                        onChanged: (value) {},
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // ---- Footer Buttons ----
            Padding(
              padding: const EdgeInsets.all(12),
              child: Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () {
                        // TODO: Reset action
                      },
                      style: OutlinedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                        side: BorderSide(color: theme.colorScheme.secondary),
                      ),
                      child: Text(
                        Labels.reset,
                        style: TextStyle(
                          fontFamily: FontFamily.fontsPoppinsSemiBold,
                          color: theme.colorScheme.secondary,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).maybePop(); // close drawer
                        // TODO: Apply filter
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: theme.colorScheme.primary,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                      child: Text(
                        Labels.apply,
                        style: TextStyle(
                          fontFamily: FontFamily.fontsPoppinsSemiBold,
                          color: theme.colorScheme.onPrimary,
                        ),
                      ),
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

  Widget _buildFilterSection(
    BuildContext context, {
    required String title,
    required List<Widget> children,
  }) {
    final theme = Theme.of(context);

    return ExpansionTile(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(5),
        side: BorderSide(color: Theme.of(context).colorScheme.onSecondary),
      ),
      collapsedShape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(5),
        side: BorderSide(color: Theme.of(context).colorScheme.secondary),
      ),
      collapsedBackgroundColor: Theme.of(context).scaffoldBackgroundColor,
      collapsedTextColor: Theme.of(context).colorScheme.onPrimary,
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      initiallyExpanded: true,
      tilePadding: const EdgeInsets.symmetric(horizontal: 16),
      title: Text(
        title,
        style: TextStyle(
          fontSize: context.scaledFont(14),
          fontFamily: FontFamily.fontsPoppinsSemiBold,
          color: theme.colorScheme.onSecondary,
        ),
      ),
      childrenPadding: const EdgeInsets.symmetric(horizontal: 8),
      children: children,
    );
  }
}
