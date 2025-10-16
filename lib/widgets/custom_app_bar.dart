import 'package:flutter/material.dart';
import 'package:speezu/core/utils/media_querry_extention.dart';

import '../core/assets/font_family.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  const CustomAppBar({
    super.key,
    required this.title,
    this.action,
    this.requireBackButton = true,
    this.backgroundColor,
    this.backIcon = Icons.arrow_back_sharp,
    this.elevation = 0.0,
  });

  final String title;
  final Widget? action;
  final bool requireBackButton;
  final Color? backgroundColor;
  final IconData backIcon;
  final double elevation;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            backgroundColor ?? Theme.of(context).colorScheme.onPrimary,
            (backgroundColor ?? Theme.of(context).colorScheme.onPrimary)
                .withValues(alpha: 0.95),
          ],
        ),
        boxShadow: [
          BoxShadow(
            color: Theme.of(context).colorScheme.shadow.withValues(alpha: 0.08),
            offset: const Offset(0, 2),
            blurRadius: 8,
            spreadRadius: 0,
          ),
        ],
      ),
      child: AppBar(
        scrolledUnderElevation: 0,
        backgroundColor: Colors.transparent,
        centerTitle: true,
        elevation: elevation,
        leading: requireBackButton
            ? Container(
          margin: const EdgeInsets.only(left: 8),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              borderRadius: BorderRadius.circular(12),
              onTap: () {
                Navigator.pop(context);
              },
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: Theme.of(context)
                        .colorScheme
                        .secondary
                        .withValues(alpha: 0.1),
                    width: 1,
                  ),
                ),
                child: Icon(
                  backIcon,
                  color: Theme.of(context).colorScheme.onSecondary,
                  size: context.scaledFont(22),
                ),
              ),
            ),
          ),
        )
            : const SizedBox.shrink(),
        title: ShaderMask(
          shaderCallback: (bounds) => LinearGradient(
            colors: [
              Theme.of(context).colorScheme.onSecondary.withValues(alpha: 0.95),
              Theme.of(context).colorScheme.onSecondary.withValues(alpha: 0.85),
            ],
          ).createShader(bounds),
          child: Text(
            title,
            style: TextStyle(
              color: Colors.white,
              fontFamily: FontFamily.fontsPoppinsSemiBold,
              fontSize: context.scaledFont(19),
              letterSpacing: 0.3,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 8),
            child: action ?? const SizedBox.shrink(),
          ),
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Container(
            height: 1,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Colors.transparent,
                  Theme.of(context)
                      .colorScheme
                      .secondary
                      .withValues(alpha: 0.15),
                  Colors.transparent,
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}