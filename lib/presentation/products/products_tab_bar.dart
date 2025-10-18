import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:speezu/core/assets/font_family.dart';
import 'package:speezu/presentation/products/bloc/products_bloc.dart';
import 'package:speezu/presentation/products/bloc/products_event.dart';
import 'package:speezu/presentation/products/bloc/products_state.dart';
import 'package:speezu/presentation/products/widgets/dynamic_products_screen.dart';

import '../../core/utils/labels.dart';

class ProductsTabBarScreen extends StatefulWidget {
  final int initialIndex;
  const ProductsTabBarScreen({super.key, this.initialIndex = 0});

  @override
  State<ProductsTabBarScreen> createState() => _ProductsTabBarScreenState();
}

class _ProductsTabBarScreenState extends State<ProductsTabBarScreen> {

  @override
  void initState() {
    context.read<ProductsBloc>().add(LoadProductsEvent(categoryName: 'food'));
    super.initState();
  }

  Widget build(BuildContext context) {
    // context.read<ProductsBloc>().add(ChangeTabEvent(widget.initialIndex));

    return BlocBuilder<ProductsBloc, ProductsState>(
      builder: (context, state) {
        return DefaultTabController(
          length: 4,
          initialIndex: state.selectedTabIndex,
          child: Scaffold(
            backgroundColor: Theme.of(context).scaffoldBackgroundColor,
            body: Column(
              children: [
                // Premium Custom Tab Bar
                // ProductsTabContainer(
                //   onTabChanged: (index) {
                //     context.read<ProductsBloc>().add(ChangeTabEvent(index));
                //   },
                // ),
                const SizedBox(height: 16),

                // Tab Content
                Expanded(
                  child: BlocBuilder<ProductsBloc, ProductsState>(
                    builder: (context, state) {
                      switch (state.selectedTabIndex) {
                        case 0:
                          return const DynamicProductsScreen(
                            categoryName: 'food',
                          );
                        case 1:
                          return const DynamicProductsScreen(
                            categoryName: 'supermarket',
                          );
                        case 2:
                          return const DynamicProductsScreen(
                            categoryName: 'retailstore',
                          );
                        case 3:
                          return const DynamicProductsScreen(
                            categoryName: 'pharmacy',
                          );
                        default:
                          return const SizedBox();
                      }
                    },
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildPremiumTab({
    required String label,
    required IconData icon,
    required List<Color> gradient,
  }) {
    return Tab(
      height: 50,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Icon with gradient background (only visible when not selected)
            Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors:
                      gradient.map((c) => c.withValues(alpha: 0.12)).toList(),
                ),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(icon, size: 16),
            ),
            const SizedBox(width: 10),
            Text(label),
          ],
        ),
      ),
    );
  }
}

// Alternative Modern Chip Style Tab Bar
class ProductsTabBarScreenChipStyle extends StatelessWidget {
  final int initialIndex;
  ProductsTabBarScreenChipStyle({super.key, this.initialIndex = 0});

  final List<Map<String, dynamic>> _tabs = [
    {
      'label': Labels.food,
      'icon': Icons.restaurant_rounded,
      'color': const Color(0xFFFF6B6B),
    },
    {
      'label': Labels.superMarket,
      'icon': Icons.shopping_cart_rounded,
      'color': const Color(0xFF4ECDC4),
    },
    {
      'label': Labels.retailStore,
      'icon': Icons.store_rounded,
      'color': const Color(0xFFD66D75),
    },
    {
      'label': Labels.pharmacy,
      'icon': Icons.medical_services_rounded,
      'color': const Color(0xFF667EEA),
    },
  ];

  @override
  Widget build(BuildContext context) {
    context.read<ProductsBloc>().add(ChangeTabEvent(initialIndex));

    return BlocBuilder<ProductsBloc, ProductsState>(
      builder: (context, state) {
        return Scaffold(
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          body: Column(
            children: [
              // Chip Style Tab Bar
              Container(
                height: 60,
                margin: const EdgeInsets.symmetric(vertical: 12),
                child: ListView.separated(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  scrollDirection: Axis.horizontal,
                  physics: const BouncingScrollPhysics(),
                  itemCount: _tabs.length,
                  separatorBuilder:
                      (context, index) => const SizedBox(width: 12),
                  itemBuilder: (context, index) {
                    final tab = _tabs[index];
                    final isSelected = state.selectedTabIndex == index;

                    return _buildChipTab(
                      context: context,
                      label: tab['label'],
                      icon: tab['icon'],
                      color: tab['color'],
                      isSelected: isSelected,
                      onTap: () {
                        context.read<ProductsBloc>().add(ChangeTabEvent(index));
                      },
                    );
                  },
                ),
              ),

              // Tab Content
              Expanded(
                child: IndexedStack(
                  index: state.selectedTabIndex,
                  children: const [
                    DynamicProductsScreen(categoryName: 'food'),
                    DynamicProductsScreen(categoryName: 'supermarket'),
                    DynamicProductsScreen(categoryName: 'retail stores'),
                    DynamicProductsScreen(categoryName: 'pharmacy'),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildChipTab({
    required BuildContext context,
    required String label,
    required IconData icon,
    required Color color,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOutCubic,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        decoration: BoxDecoration(
          gradient:
              isSelected
                  ? LinearGradient(
                    colors: [color, color.withValues(alpha: 0.85)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  )
                  : null,
          color: isSelected ? null : Theme.of(context).colorScheme.surface,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color:
                isSelected
                    ? Colors.transparent
                    : Theme.of(
                      context,
                    ).colorScheme.outline.withValues(alpha: 0.15),
            width: 1,
          ),
          boxShadow:
              isSelected
                  ? [
                    BoxShadow(
                      color: color.withValues(alpha: 0.3),
                      blurRadius: 12,
                      offset: const Offset(0, 4),
                    ),
                  ]
                  : [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.04),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color:
                    isSelected
                        ? Colors.white.withValues(alpha: 0.2)
                        : color.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                icon,
                size: 18,
                color: isSelected ? Colors.white : color,
              ),
            ),
            const SizedBox(width: 10),
            Text(
              label,
              style: TextStyle(
                fontFamily: FontFamily.fontsPoppinsSemiBold,
                fontSize: 14,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                color:
                    isSelected
                        ? Colors.white
                        : Theme.of(context).colorScheme.onSecondary,
                letterSpacing: 0.2,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ProductsTabContainer extends StatelessWidget {
  final ValueChanged<int>? onTabChanged;

  const ProductsTabContainer({super.key, this.onTabChanged});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProductsBloc, ProductsState>(
      buildWhen: (previous, current) =>
      previous.selectedTabIndex != current.selectedTabIndex,
      builder: (context, state) {
        return DefaultTabController(
          length: 4,
          initialIndex: state.selectedTabIndex,
          child: Builder(builder: (context) {
            final TabController controller = DefaultTabController.of(context);

            // Keep TabController in sync with bloc state
            if (controller.index != state.selectedTabIndex) {
              controller.animateTo(state.selectedTabIndex);
            }

            controller.addListener(() {
              if (!controller.indexIsChanging) {
                final newIndex = controller.index;

                // Avoid re-triggering for the same index
                if (state.selectedTabIndex != newIndex) {
                  context.read<ProductsBloc>().add(ChangeTabEvent(newIndex));
                  onTabChanged?.call(newIndex);
                }
              }
            });

            return Container(
              margin: const EdgeInsets.fromLTRB(16, 12, 16, 0),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.onPrimary,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.1),
                    blurRadius: 12,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: TabBar(
                  controller: controller,
                  isScrollable: true,
                  tabAlignment: TabAlignment.start,
                  physics: const BouncingScrollPhysics(),
                  indicatorSize: TabBarIndicatorSize.tab,
                  dividerColor: Colors.transparent,
                  padding: EdgeInsets.zero,
                  indicatorPadding: EdgeInsets.zero,
                  labelPadding: EdgeInsets.zero,
                  splashBorderRadius: BorderRadius.circular(12),
                  indicator: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Theme.of(context).colorScheme.primary,
                        Theme.of(context)
                            .colorScheme
                            .primary
                            .withValues(alpha: 0.9),
                      ],
                    ),
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Theme.of(context)
                            .colorScheme
                            .primary
                            .withValues(alpha: 0.3),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  labelColor: Colors.white,
                  unselectedLabelColor: Theme.of(context)
                      .colorScheme
                      .onSecondary
                      .withValues(alpha: 0.6),
                  labelStyle: const TextStyle(
                    fontFamily: FontFamily.fontsPoppinsSemiBold,
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 0.2,
                  ),
                  unselectedLabelStyle: const TextStyle(
                    fontFamily: FontFamily.fontsPoppinsRegular,
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                  ),
                  tabs: [
                    _buildPremiumTab(
                      label: Labels.food,
                      icon: Icons.restaurant_rounded,
                      gradient: [
                        const Color(0xFFFF6B6B),
                        const Color(0xFFFF8E53)
                      ],
                    ),
                    _buildPremiumTab(
                      label: Labels.superMarket,
                      icon: Icons.shopping_cart_rounded,
                      gradient: [
                        const Color(0xFF4ECDC4),
                        const Color(0xFF44A08D)
                      ],
                    ),
                    _buildPremiumTab(
                      label: Labels.retailStore,
                      icon: Icons.store_rounded,
                      gradient: [
                        const Color(0xFFD66D75),
                        const Color(0xFFE29587)
                      ],
                    ),
                    _buildPremiumTab(
                      label: Labels.pharmacy,
                      icon: Icons.medical_services_rounded,
                      gradient: [
                        const Color(0xFF667EEA),
                        const Color(0xFF764BA2)
                      ],
                    ),
                  ],
                ),
              ),
            );
          }),
        );
      },
    );
  }

  Widget _buildPremiumTab({
    required String label,
    required IconData icon,
    required List<Color> gradient,
  }) {
    return Tab(
      height: 50,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: gradient.map((c) => c.withValues(alpha: 0.12)).toList(),
                ),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(icon, size: 16),
            ),
            const SizedBox(width: 10),
            Text(label),
          ],
        ),
      ),
    );
  }
}
