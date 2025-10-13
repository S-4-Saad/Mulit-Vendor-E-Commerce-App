import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:speezu/core/assets/font_family.dart';
import 'package:speezu/presentation/products/bloc/products_bloc.dart';
import 'package:speezu/presentation/products/bloc/products_event.dart';
import 'package:speezu/presentation/products/bloc/products_state.dart';
import 'package:speezu/presentation/products/widgets/dynamic_products_screen.dart';

import '../../core/utils/labels.dart';

class ProductsTabBarScreen extends StatelessWidget {
  final int initialIndex;
  const ProductsTabBarScreen({super.key, this.initialIndex = 0});

  @override
  Widget build(BuildContext context) {
    // Fire initial event so bloc knows which tab to start from
    context.read<ProductsBloc>().add(ChangeTabEvent(initialIndex));

    return BlocBuilder<ProductsBloc, ProductsState>(
      builder: (context, state) {
        return DefaultTabController(
          length: 4,
          initialIndex: state.selectedTabIndex,
          child: Scaffold(
            backgroundColor: Theme.of(context).scaffoldBackgroundColor,
            body: Column(
              children: [
                Container(
                  margin: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.onPrimary,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.08),
                        blurRadius: 20,
                        offset: const Offset(0, 4),
                        spreadRadius: 0,
                      ),
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.03),
                        blurRadius: 12,
                        offset: const Offset(0, 2),
                      ),
                    ],
                    border: Border.all(
                      color: Theme.of(context).colorScheme.onSecondary.withValues(alpha: 0.1),
                      width: 1,
                    ),
                  ),
                  child: TabBar(
                    physics: BouncingScrollPhysics(),

                    splashBorderRadius: BorderRadius.circular(10),
                    dividerColor: Colors.transparent,
                    isScrollable: true,
                    indicatorSize: TabBarIndicatorSize.tab,
                    onTap: (index) {
                      context.read<ProductsBloc>().add(ChangeTabEvent(index));
                    },
                    indicator: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      gradient: LinearGradient(
                        colors: [
                          Theme.of(context).colorScheme.primary,
                          Theme.of(context).colorScheme.primary.withValues(alpha: 0.85),
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.35),
                          blurRadius: 12,
                          offset: const Offset(0, 4),
                          spreadRadius: -2,
                        ),
                      ],
                    ),
                    labelColor: Colors.white,
                    unselectedLabelColor: Theme.of(context).colorScheme.onSecondary.withValues(alpha: 0.6),
                    labelStyle: const TextStyle(
                      fontFamily: FontFamily.fontsPoppinsSemiBold,
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 0.3,
                    ),
                    unselectedLabelStyle: const TextStyle(
                      fontFamily: FontFamily.fontsPoppinsSemiBold,
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      letterSpacing: 0.2,
                    ),
                    tabs: [
                      _buildTab(Labels.food, Icons.restaurant_menu_rounded),
                      _buildTab(Labels.superMarket, Icons.shopping_cart_rounded),
                      _buildTab(Labels.retailStore, Icons.store_rounded),
                      _buildTab(Labels.pharmacy, Icons.medical_services_rounded),
                    ],
                  ),
                )
                // Container(
                //   margin: const EdgeInsets.symmetric(
                //     horizontal: 16,
                //     vertical: 8,
                //   ),
                //   padding: const EdgeInsets.all(6),
                //   decoration: BoxDecoration(
                //     color: Theme.of(context).colorScheme.onPrimary,
                //     borderRadius: BorderRadius.circular(16),
                //     boxShadow: [
                //       BoxShadow(
                //         color: Colors.black.withValues(alpha: 0.05),
                //         blurRadius: 8,
                //         offset: const Offset(0, 4),
                //       ),
                //     ],
                //   ),
                //   child: TabBar(
                //     physics: const BouncingScrollPhysics(),
                //     dividerColor: Colors.transparent,
                //     isScrollable: true,
                //     indicatorSize: TabBarIndicatorSize.tab,
                //     onTap: (index) {
                //       context.read<ProductsBloc>().add(ChangeTabEvent(index));
                //     },
                //     indicator: BoxDecoration(
                //       borderRadius: BorderRadius.circular(12),
                //       color: Theme.of(context).colorScheme.primary,
                //     ),
                //     labelColor: Colors.white,
                //     unselectedLabelColor:
                //         Theme.of(context).colorScheme.onSecondary,
                //     labelStyle: const TextStyle(
                //       fontFamily: FontFamily.fontsPoppinsSemiBold,
                //       fontSize: 14,
                //     ),
                //     tabs: [
                //       Tab(
                //         icon: Padding(
                //           padding: const EdgeInsets.symmetric(horizontal: 15.0),
                //           child: Text(Labels.food),
                //         ),
                //       ),
                //       Tab(
                //         icon: Padding(
                //           padding: const EdgeInsets.symmetric(horizontal: 15.0),
                //           child: Text(Labels.superMarket),
                //         ),
                //       ),
                //       Tab(
                //         icon: Padding(
                //           padding: const EdgeInsets.symmetric(horizontal: 15.0),
                //           child: Text(Labels.retailStore),
                //         ),
                //       ),
                //       Tab(
                //         icon: Padding(
                //           padding: const EdgeInsets.symmetric(horizontal: 15.0),
                //           child: Text(Labels.pharmacy),
                //         ),
                //       ),
                //     ],
                //   ),
                // ),

                , SizedBox(height: 10),
                Expanded(
                  child: TabBarView(
                    physics: const NeverScrollableScrollPhysics(), // 🚫 disables swipe
                    children: [
                      const DynamicProductsScreen(categoryName: 'food'),
                      const DynamicProductsScreen(categoryName: 'supermarket'),
                      const DynamicProductsScreen(categoryName: 'retail stores'),
                      const DynamicProductsScreen(categoryName: 'pharmacy'),
                    ],
                  ),
                ),

                // Tab Content
                // Expanded(
                //   child: TabBarView(
                //     children: [
                //       const DynamicProductsScreen(categoryName: 'food'),
                //       SizedBox(
                //         width: double.infinity,
                //         height: double.infinity,
                //         child: const DynamicProductsScreen(categoryName: 'supermarket'),
                //       ),
                //       SizedBox(
                //         width: double.infinity,
                //         height: double.infinity,
                //         child: const DynamicProductsScreen(categoryName: 'retail stores'),
                //       ),
                //       SizedBox(
                //         width: double.infinity,
                //         height: double.infinity,
                //         child: const DynamicProductsScreen(categoryName: 'pharmacy'),
                //       ),
                //     ],
                //   ),
                // ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildTab(String label, IconData icon) {
    return Tab(
      height: 48,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 18),
            const SizedBox(width: 8),
            Text(label),
          ],
        ),
      ),
    );
  }
}
