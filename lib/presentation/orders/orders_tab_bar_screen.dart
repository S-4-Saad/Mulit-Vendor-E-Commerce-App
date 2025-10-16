import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:speezu/core/assets/font_family.dart';
import 'package:speezu/presentation/orders/bloc/order_state.dart';
import 'package:speezu/presentation/orders/bloc/orders_bloc.dart';
import 'package:speezu/presentation/orders/orders_tab_screens/completed_orders_screen.dart';

import '../../core/utils/labels.dart';
import 'bloc/orders_event.dart';
import 'orders_tab_screens/active_orders_screen.dart';
import 'orders_tab_screens/cancelled_orders_screen.dart';

class OrdersTabBarScreen extends StatelessWidget {
  final int initialIndex;
  const OrdersTabBarScreen({super.key, this.initialIndex = 0});

  @override
  Widget build(BuildContext context) {
    context.read<OrdersBloc>().add(ChangeOrdersTabEvent(initialIndex));
    List<Color> _getTabGradientColors(int index) {
      switch (index) {
        case 0: // Active
          return const [Color(0xFF10B981), Color(0xFF059669)];
        case 1: // Completed (blue)
          return const [Color(0xFF3B82F6), Color(0xFF2563EB)];
        case 2: // Cancelled (red)
          return const [Color(0xFFEF4444), Color(0xFFDC2626)];
        default:
          return [Colors.grey, Colors.grey];
      }
    }


    return BlocBuilder<OrdersBloc, OrderState>(
      builder: (context, state) {
        return DefaultTabController(
          length: 3,
          initialIndex: state.selectedTabIndex,
          child: Scaffold(
            backgroundColor: Theme.of(context).scaffoldBackgroundColor,
            body: Column(
              children: [
                // Premium Tab Bar
                Container(
                  margin: const EdgeInsets.fromLTRB(16, 12, 16, 0),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.onPrimary,
                    borderRadius: BorderRadius.circular(10),
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
                      padding: EdgeInsets.zero,
                      indicatorPadding: EdgeInsets.zero,
                      labelPadding: EdgeInsets.zero,
                      physics: const BouncingScrollPhysics(),
                      splashBorderRadius: BorderRadius.circular(12),
                      dividerColor: Colors.transparent,
                      isScrollable: true,
                      tabAlignment: TabAlignment.start,
                      indicatorSize: TabBarIndicatorSize.tab,
                      onTap: (index) {
                        context.read<OrdersBloc>().add(ChangeOrdersTabEvent(index));
                      },
                      indicator: BoxDecoration(
                        gradient: LinearGradient(
                          colors: _getTabGradientColors(state.selectedTabIndex),
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.3),
                            blurRadius: 8,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      labelColor: Colors.white,
                      unselectedLabelColor: Theme.of(context).colorScheme.onSecondary.withValues(alpha: 0.6),
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
                          label: Labels.activeOrders,
                          icon: Icons.shopping_bag_rounded,
                          gradient: [Color(0xFF10B981), Color(0xFF059669)],
                        ),
                        _buildPremiumTab(
                          label: Labels.completedOrders,
                          icon: Icons.check_circle_rounded,
                          gradient: [Color(0xFF3B82F6), Color(0xFF2563EB)],
                        ),
                        _buildPremiumTab(
                          label: Labels.cancelledOrders,
                          icon: Icons.cancel_rounded,
                          gradient: [Color(0xFFEF4444), Color(0xFFDC2626)],
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 16),

                // Tab Content
                Expanded(
                  child: TabBarView(
                    physics: const NeverScrollableScrollPhysics(),
                    children: const [
                      ActiveOrdersScreen(),
                      CompletedOrdersScreen(),
                      CancelledOrdersScreen(),
                    ],
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
      height: 52,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Icon with gradient background
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

// Alternative: Chip Style Orders Tab Bar
class OrdersTabBarScreenChipStyle extends StatelessWidget {
  final int initialIndex;
   OrdersTabBarScreenChipStyle({super.key, this.initialIndex = 0});

  final List<Map<String, dynamic>> _tabs =  [
    {
      'label': Labels.activeOrders,
      'icon': Icons.shopping_bag_rounded,
      'color': Color(0xFF10B981),
    },
    {
      'label': Labels.completedOrders,
      'icon': Icons.check_circle_rounded,
      'color': Color(0xFF3B82F6),
    },
    {
      'label': Labels.cancelledOrders,
      'icon': Icons.cancel_rounded,
      'color': Color(0xFFEF4444),
    },
  ];

  @override
  Widget build(BuildContext context) {
    context.read<OrdersBloc>().add(ChangeOrdersTabEvent(initialIndex));

    return BlocBuilder<OrdersBloc, OrderState>(
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
                  separatorBuilder: (context, index) => const SizedBox(width: 12),
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
                        context.read<OrdersBloc>().add(ChangeOrdersTabEvent(index));
                      },
                    );
                  },
                ),
              ),

              // Tab Content with IndexedStack for better performance
              Expanded(
                child: IndexedStack(
                  index: state.selectedTabIndex,
                  children: const [
                    ActiveOrdersScreen(),
                    CompletedOrdersScreen(),
                    CancelledOrdersScreen(),
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
          gradient: isSelected
              ? LinearGradient(
            colors: [color, color.withValues(alpha: 0.85)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          )
              : null,
          color: isSelected ? null : Theme.of(context).colorScheme.surface,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected
                ? Colors.transparent
                : Theme.of(context).colorScheme.outline.withValues(alpha: 0.15),
            width: 1,
          ),
          boxShadow: isSelected
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
                color: isSelected
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
                color: isSelected
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

// Minimal Style: Simple Pills
class OrdersTabBarScreenMinimal extends StatelessWidget {
  final int initialIndex;
  const OrdersTabBarScreenMinimal({super.key, this.initialIndex = 0});

  @override
  Widget build(BuildContext context) {
    context.read<OrdersBloc>().add(ChangeOrdersTabEvent(initialIndex));

    return BlocBuilder<OrdersBloc, OrderState>(
      builder: (context, state) {
        return Scaffold(
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          body: Column(
            children: [
              // Minimal Pill Tabs
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.surface,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: Theme.of(context).colorScheme.outline.withValues(alpha: 0.1),
                  ),
                ),
                child: Row(
                  children: [
                    _buildMinimalTab(
                      context: context,
                      label: 'Active',
                      icon: Icons.pending_rounded,
                      isSelected: state.selectedTabIndex == 0,
                      onTap: () => context.read<OrdersBloc>().add( ChangeOrdersTabEvent(0)),
                    ),
                    _buildMinimalTab(
                      context: context,
                      label: 'Completed',
                      icon: Icons.check_circle_rounded,
                      isSelected: state.selectedTabIndex == 1,
                      onTap: () => context.read<OrdersBloc>().add( ChangeOrdersTabEvent(1)),
                    ),
                    _buildMinimalTab(
                      context: context,
                      label: 'Cancelled',
                      icon: Icons.cancel_rounded,
                      isSelected: state.selectedTabIndex == 2,
                      onTap: () => context.read<OrdersBloc>().add( ChangeOrdersTabEvent(2)),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 16),

              Expanded(
                child: IndexedStack(
                  index: state.selectedTabIndex,
                  children: const [
                    ActiveOrdersScreen(),
                    CompletedOrdersScreen(),
                    CancelledOrdersScreen(),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildMinimalTab({
    required BuildContext context,
    required String label,
    required IconData icon,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 250),
          curve: Curves.easeOutCubic,
          padding: const EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(
            color: isSelected
                ? Theme.of(context).colorScheme.primary
                : Colors.transparent,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                icon,
                size: 20,
                color: isSelected
                    ? Colors.white
                    : Theme.of(context).colorScheme.onSecondary.withValues(alpha: 0.6),
              ),
              const SizedBox(height: 4),
              Text(
                label,
                style: TextStyle(
                  fontFamily: FontFamily.fontsPoppinsRegular,
                  fontSize: 12,
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                  color: isSelected
                      ? Colors.white
                      : Theme.of(context).colorScheme.onSecondary.withValues(alpha: 0.6),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}