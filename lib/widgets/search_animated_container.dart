import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:speezu/core/assets/font_family.dart';
import 'package:speezu/core/utils/media_querry_extention.dart';
import 'package:speezu/presentation/search_products/search_prompt_screen.dart';
import '../core/utils/labels.dart';

class SearchContainer extends StatefulWidget {
  final double? height;

  const SearchContainer({super.key, this.height = 40});

  @override
  State<SearchContainer> createState() => _SearchContainerState();
}

class _SearchContainerState extends State<SearchContainer> {
  bool _isPressed = false;



  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> searchItems = [
      {
        "text": Labels.searchFood,
        "icon": Icons.restaurant_rounded,
        "accentColor": Color(0xFFFF6B6B),
      },
      {
        "text": Labels.searchSuperMarketProducts,
        "icon": Icons.shopping_basket_rounded,
        "accentColor": Color(0xFF4ECDC4),
      },
      {
        "text": Labels.searchMedicine,
        "icon": Icons.local_hospital_rounded,
        "accentColor": Color(0xFF667EEA),
      },
      {
        "text": Labels.searchRetailProducts,
        "icon": Icons.shopping_bag_rounded,
        "accentColor": Color(0xFFD66D75),
      },
    ];
    return BlocBuilder<SearchCubit, int>(
      builder: (context, index) {
        final item = searchItems[index];
        final accentColor = item["accentColor"] as Color;

        return GestureDetector(
          onTapDown: (_) => setState(() => _isPressed = true),
          onTapUp: (_) => setState(() => _isPressed = false),
          onTapCancel: () => setState(() => _isPressed = false),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => SearchPromptScreen()),
            );
          },
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            curve: Curves.easeOutCubic,
            height: widget.height,
            constraints: BoxConstraints(minHeight: 48),
            margin: const EdgeInsets.symmetric(horizontal: 0),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.onPrimary,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(
                color: Theme.of(
                  context,
                ).colorScheme.onSecondary.withValues(alpha: 0.2),
                width: 1,
              ),
              boxShadow:
                  _isPressed
                      ? [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.05),
                          blurRadius: 4,
                          offset: const Offset(0, 1),
                        ),
                      ]
                      : [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.06),
                          blurRadius: 12,
                          offset: const Offset(0, 4),
                        ),
                        BoxShadow(
                          color: accentColor.withValues(alpha: 0.08),
                          blurRadius: 16,
                          offset: const Offset(0, 2),
                        ),
                      ],
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 5),
              child: Row(
                children: [
                  // Icon container with subtle accent
                  Icon(item["icon"], color: accentColor),

                  const SizedBox(width: 14),

                  // Animated text
                  Expanded(
                    child: AnimatedSwitcher(
                      duration: const Duration(milliseconds: 500),
                      switchInCurve: Curves.easeOutCubic,
                      switchOutCurve: Curves.easeInCubic,
                      transitionBuilder: (child, animation) {
                        final slideAnimation = Tween<Offset>(
                          begin: const Offset(0.15, 0),
                          end: Offset.zero,
                        ).animate(
                          CurvedAnimation(
                            parent: animation,
                            curve: Curves.easeOutCubic,
                          ),
                        );

                        return SlideTransition(
                          position: slideAnimation,
                          child: FadeTransition(
                            opacity: animation,
                            child: child,
                          ),
                        );
                      },
                      child: Align(
                        alignment: Alignment.centerLeft,
                        key: ValueKey(item["text"]),
                        child: Text(
                          item["text"],
                          style: TextStyle(
                            color: Theme.of(
                              context,
                            ).colorScheme.onSecondary.withValues(alpha: 0.85),
                            fontFamily: FontFamily.fontsPoppinsRegular,
                            fontSize: 15,
                            fontWeight: FontWeight.w500,
                            letterSpacing: 0.1,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(width: 12),

                  // Search icon
                  Icon(
                    Icons.search_rounded,
                    color: Theme.of(context).colorScheme.primary,
                    size: 18,
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

class SearchCubit extends Cubit<int> {
  late Timer _timer;
  final int totalItems = 4;

  SearchCubit() : super(0) {
    _startCycling();
  }

  void _startCycling() {
    _timer = Timer.periodic(const Duration(seconds: 3), (timer) {
      int nextIndex = (state + 1) % totalItems;
      emit(nextIndex);
    });
  }

  @override
  Future<void> close() {
    _timer.cancel();
    return super.close();
  }
}
