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
    {
      "text": Labels.searchFood,
      "icon": Icons.fastfood,
      "color": Colors.deepOrange,
    },
    {
      "text": Labels.searchSuperMarketProducts,
      "icon": Icons.local_grocery_store,
      "color": Colors.teal,
    },
    {
      "text": Labels.searchMedicine,
      "icon": Icons.medical_services,
      "color": Colors.indigo,
    },
    {
      "text": Labels.searchRetailProducts,
      "icon": Icons.shopping_bag,
      "color": Colors.brown,
    },
  ];

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SearchCubit, int>(
      builder: (context, index) {
        final item = _searchItems[index];

        return GestureDetector(
          onTap: onSearchTap,
          child: AnimatedContainer(

            duration: const Duration(milliseconds: 400),
            curve: Curves.easeInOut,
            height: context.heightPct(.055),
            width: double.infinity,
            margin: const EdgeInsets.only(left: 5, bottom: 0,right: 5,top:0),
            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.onPrimary,
              borderRadius: BorderRadius.circular(5),
              border: Border.all(
                color: item["color"].withOpacity(0.5),
                width: 1,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.08),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Row(
              children: [
                Container(
                  clipBehavior: Clip.antiAlias,
                  padding: const EdgeInsets.all(5),
                  decoration: BoxDecoration(
                    color: item["color"].withOpacity(0.15),
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: Icon(item["icon"], color: item["color"], size: 20),
                ),
                const SizedBox(width: 14),
                Expanded( // 👈 ensures the text takes all remaining space
                  child: AnimatedSwitcher(
                    duration: const Duration(milliseconds: 600),
                    transitionBuilder: (child, animation) {
                      final slideAnimation = Tween<Offset>(
                        begin: const Offset(0.2, 0), // slide from right
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
                    child: Align( // 👈 keeps it pinned to the start
                      alignment: Alignment.centerLeft,
                      key: ValueKey(item["text"]),
                      child: Text(
                        item["text"],
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.onSecondary,
                          fontFamily: FontFamily.fontsPoppinsRegular,
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
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
