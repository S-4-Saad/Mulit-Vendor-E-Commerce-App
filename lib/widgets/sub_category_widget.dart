
import 'package:flutter/material.dart';
import 'package:speezu/widgets/image_type_extention.dart';

import '../core/assets/font_family.dart';
import '../core/utils/currency_icon.dart';
import 'app_cache_image.dart';

class SubCategoryBox extends StatefulWidget {
  final String imageUrl;
  final String title;
  final double? boxWidget;
  final VoidCallback onTap;
  final double? imageHeight;
  final EdgeInsets marginPadding;
  final bool isSelected;

  const SubCategoryBox({
    super.key,
    required this.imageUrl,
    required this.onTap,
    required this.title,
    this.isSelected=false,
    this.marginPadding =  const EdgeInsets.symmetric(horizontal: 3, vertical: 5),
    this.boxWidget,
    this.imageHeight,
  });

  @override
  _SubCategoryBoxState createState() => _SubCategoryBoxState();
}

class _SubCategoryBoxState extends State<SubCategoryBox> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _slideAnimation;
  late Animation<Color?> _colorAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    )..repeat(reverse: true);

    _slideAnimation = Tween<double>(begin: -5, end: 5).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOutSine),
    );

    _colorAnimation = ColorTween(
      begin: Color(0xFF008080),
      end: Color(0xFF008080).withValues(alpha: 0.7),
    ).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    return GestureDetector(
      onTap: widget.onTap,
      child: Container(
        margin:widget. marginPadding,
        width: widget.boxWidget ?? 115,
        clipBehavior: Clip.antiAlias,
        decoration: BoxDecoration(
          color:widget.isSelected?Theme.of(context).colorScheme.primary.withValues(alpha: .1): Theme.of(context).colorScheme.onPrimary,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color:widget.isSelected?Theme.of(context).colorScheme.primary:  Theme.of(context).colorScheme.outline.withValues(alpha: 0.15),
            width: 1,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 4,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image Section
            CustomImageView(
              width: double.infinity,
              height: widget.imageHeight ?? 90,

              fit: BoxFit.cover,
              imagePath: widget.imageUrl,
            ),
            // Details Section
            Padding(
              padding: EdgeInsets.all(6),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Price Box with Slide Animation
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 6, vertical: 4),
                    decoration: BoxDecoration(
                      color: widget.isSelected?Theme.of(context).colorScheme.onPrimary: Theme.of(context).colorScheme.primary.withValues(alpha: 0.08),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        AnimatedBuilder(
                          animation: _controller,
                          builder: (context, child) {
                            return Transform.translate(
                              offset: Offset(_slideAnimation.value, 0),
                              child: Text(
                              widget.title,
                                style: TextStyle(
                                  fontFamily: FontFamily.fontsPoppinsSemiBold,
                                  fontSize: 10,
                                  color: Theme.of(context).colorScheme.onSecondary,
                                  shadows: [
                                    Shadow(
                                      blurRadius: 4,
                                      color: _colorAnimation.value!.withOpacity(0.3),
                                      offset: Offset(0, 0),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                      ],
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