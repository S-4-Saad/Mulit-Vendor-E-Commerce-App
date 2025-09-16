import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:speezu/core/assets/font_family.dart';
import 'package:speezu/core/utils/media_querry_extention.dart';
import '../core/utils/labels.dart';

class SearchContainer extends StatelessWidget {
  SearchContainer({super.key, required this.onSearchTap});
  final VoidCallback onSearchTap;

  final List<Map<String, dynamic>> _searchItems = [
    {"text": Labels.searchFood, "icon": Icons.fastfood, "color": Colors.orange},
    {"text": Labels.searchSuperMarketProducts, "icon": Icons.local_grocery_store, "color": Colors.green},
    {"text": Labels.searchMedicine, "icon": Icons.medical_services, "color": Colors.red},
    {"text": Labels.searchRetailProducts, "icon": Icons.shopping_bag, "color": Colors.blue},
  ];

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SearchCubit, int>(
      builder: (context, index) {
        final item = _searchItems[index];

        return GestureDetector(
          onTap: onSearchTap,
          child: AnimatedContainer(

            duration: const Duration(milliseconds: 500),
            clipBehavior: Clip.hardEdge,
            curve: Curves.easeInOut,
            height: context.heightPct(.05),
            width: double.infinity,
            margin: const EdgeInsets.symmetric(horizontal: 5, vertical: 10),
            padding: const EdgeInsets.symmetric(horizontal: 16),
            decoration: BoxDecoration(
              color: item["color"].withOpacity(0.1),
              borderRadius: BorderRadius.circular(5),
              border: Border.all(color: item["color"], width: 1.2),
            ),
            child: Row(
              children: [
                Icon(item["icon"], color: item["color"]),
                const SizedBox(width: 12),
                Expanded(
                  child: AnimatedSwitcher(
                    duration: const Duration(milliseconds: 600),
                    transitionBuilder: (child, animation) {
                      final slideAnimation = Tween<Offset>(
                        begin: const Offset(1.0, 0), // start off-screen right
                        end: Offset.zero,
                      ).animate(CurvedAnimation(
                        parent: animation,
                        curve: Curves.easeOut,
                      ));

                      return SlideTransition(
                        position: slideAnimation,
                        child: FadeTransition(
                          opacity: animation,
                          child: child,
                        ),
                      );
                    },
                    child: Text(
                      item["text"],
                      key: ValueKey(item["text"]),
                      style: TextStyle(
                        color: item["color"],
                        fontFamily: FontFamily.fontsPoppinsRegular,
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
              ],
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
