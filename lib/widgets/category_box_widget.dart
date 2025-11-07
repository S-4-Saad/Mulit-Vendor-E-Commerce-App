import 'package:flutter/material.dart';
import 'package:speezu/core/utils/media_querry_extention.dart';
import '../core/assets/font_family.dart';
import '../routes/route_names.dart';
import 'image_type_extention.dart';

class ResponsiveCategorySection extends StatelessWidget {
  const ResponsiveCategorySection({
    super.key,
    required this.productCategories,
  });

  final List<dynamic> productCategories;

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isTablet = screenWidth >= 600;

    if (isTablet) {
      // Premium Tablet Layout - Chip Style with Icons
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Wrap(
          spacing: 12,
          runSpacing: 12,
          children: productCategories.map((category) {
            return PremiumCategoryChip(
              title: category.name,
              imageUrl: category.imageUrl,
              onTap: () {
                Navigator.pushNamed(
                  context,
                  RouteNames.categoryScreen,
                  arguments: {
                    'categoryName': category.name,
                    'categoryId': category.categoryId,
                  },
                );
              },
            );
          }).toList(),
        ),
      );
    } else {
      // Original Horizontal Scroll for Mobile
      return SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: productCategories.map((category) {
            return CategoryBoxWidget(
              title: category.name,
              imageUrl: category.imageUrl,
              onTap: () {
                Navigator.pushNamed(
                  context,
                  RouteNames.categoryScreen,
                  arguments: {
                    'categoryName': category.name,
                    'categoryId': category.categoryId,
                  },
                );
              },
            );
          }).toList(),
        ),
      );
    }
  }
}

// Premium Chip/Pill Design for Tablets - NO BOXES!
class PremiumCategoryChip extends StatefulWidget {
  const PremiumCategoryChip({
    super.key,
    required this.title,
    required this.imageUrl,
    required this.onTap,
  });

  final String title;
  final String imageUrl;
  final VoidCallback onTap;

  @override
  State<PremiumCategoryChip> createState() => _PremiumCategoryChipState();
}

class _PremiumCategoryChipState extends State<PremiumCategoryChip> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeOut,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          decoration: BoxDecoration(
            color: _isHovered
                ? Theme.of(context).colorScheme.primary.withValues(alpha: 0.12)
                : Theme.of(context).colorScheme.onPrimary,
            borderRadius: BorderRadius.circular(50),
            border: Border.all(
              color: _isHovered
                  ? Theme.of(context).colorScheme.primary.withValues(alpha: 0.3)
                  : Theme.of(context).colorScheme.onSecondary.withValues(alpha: 0.1),
              width: 1.5,
            ),
            boxShadow: _isHovered
                ? [
              BoxShadow(
                color: Theme.of(context)
                    .colorScheme
                    .primary
                    .withValues(alpha: 0.15),
                blurRadius: 12,
                offset: const Offset(0, 4),
              ),
            ]
                : [
              BoxShadow(
                color: Theme.of(context)
                    .colorScheme
                    .onSecondary
                    .withValues(alpha: 0.06),
                blurRadius: 6,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Category Icon/Image
              Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.08),
                ),
                child: ClipOval(
                  child: Padding(
                    padding: const EdgeInsets.all(6),
                    child: CustomImageView(
                      imagePath: widget.imageUrl,
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              // Category Title
              Text(
                widget.title,
                style: TextStyle(
                  fontSize: 14,
                  fontFamily: FontFamily.fontsPoppinsSemiBold,
                  color: _isHovered
                      ? Theme.of(context).colorScheme.primary
                      : Theme.of(context).colorScheme.onSecondary,
                  letterSpacing: 0.2,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// Original Mobile Widget
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
      padding: const EdgeInsets.symmetric(horizontal: 3, vertical: 5),
      child: GestureDetector(
        onTap: onTap,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              height: 80,
              width: 80,
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.onPrimary,
                borderRadius: BorderRadius.circular(5),
                boxShadow: [
                  BoxShadow(
                    color: Theme.of(context)
                        .colorScheme
                        .onSecondary
                        .withValues(alpha: .2),
                    spreadRadius: 2,
                    blurRadius: 5,
                    offset: const Offset(1, 1),
                  ),
                ],
              ),
              child: Center(
                child: CustomImageView(
                  imagePath: imageUrl,
                  fit: BoxFit.fitWidth,
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