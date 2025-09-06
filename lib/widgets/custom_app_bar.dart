import 'package:flutter/material.dart';
import 'package:speezu/core/utils/media_querry_extention.dart';

import '../core/assets/font_family.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  const CustomAppBar({
    super.key,
    required this.title,
    this.action,
    this.requireBackButton = true,
    this.backgroundColor, // Default background color
    this.backIcon = Icons.arrow_back_sharp, // Default back icon
    this.elevation = 0.0, // Default elevation
  });

  final String title;
  final Widget? action;
  final bool
  requireBackButton; // Simplified from nullable to required with default
  final Color? backgroundColor; // New: Customizable background
  final IconData backIcon; // New: Customizable back icon
  final double elevation; // New: Elevation for shadow

  @override
  Widget build(BuildContext context) {
    return AppBar(
      scrolledUnderElevation: 0,
      backgroundColor:
          backgroundColor ?? Theme.of(context).colorScheme.secondary,
      centerTitle: true,
      elevation: elevation,
      leading:
          requireBackButton
              ? IconButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: Icon(
                  backIcon,
                  color: Theme.of(context).colorScheme.onPrimary,
                  size: context.scaledFont(23),
                ),
              )
              : const SizedBox.shrink(),
      title: Text(
        title,
        style: TextStyle(
          color: Theme.of(context).colorScheme.onPrimary,
          fontFamily: FontFamily.fontsPoppinsSemiBold,

          fontSize: context.scaledFont(19),
        ),
      ),
      actions: [action ?? const SizedBox.shrink()],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
