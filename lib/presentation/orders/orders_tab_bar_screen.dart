import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:speezu/core/assets/font_family.dart';
import 'package:speezu/presentation/orders/bloc/order_state.dart';
import 'package:speezu/presentation/orders/bloc/orders_bloc.dart';
import 'package:speezu/presentation/orders/orders_tab_screens/cancelled_orders_screen.dart';
import 'package:speezu/presentation/orders/orders_tab_screens/completed_orders_screen.dart';

import '../../core/utils/labels.dart';
import 'bloc/orders_event.dart';
import 'orders_tab_screens/active_orders_screen.dart';

class OrdersTabBarScreen extends StatefulWidget {
  const OrdersTabBarScreen({super.key});

  @override
  State<OrdersTabBarScreen> createState() => _OrdersTabBarScreenState();


}

class _OrdersTabBarScreenState extends State<OrdersTabBarScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);

    // Dispatch initial index
    context.read<OrdersBloc>().add(ChangeOrdersTabEvent(_tabController.index));

    // Listen to swipe/tab changes
    _tabController.addListener(() {
      if (_tabController.indexIsChanging == false) {
        context.read<OrdersBloc>().add(ChangeOrdersTabEvent(_tabController.index));
      }
    });
  }
  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    // Fire initial event so bloc knows which tab to start from
    context.read<OrdersBloc>().add(ChangeOrdersTabEvent(0));

    return BlocBuilder<OrdersBloc, OrderState>(
      builder: (context, state) {
        return DefaultTabController(
          length: 3,
          initialIndex: state.selectedTabIndex,
          child: Scaffold(
            backgroundColor: Theme.of(context).scaffoldBackgroundColor,
            body: Column(
              children: [
                Container(
                  margin: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.onPrimary,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.05),
                        blurRadius: 8,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: TabBar(
                    controller: _tabController,
                    physics: const BouncingScrollPhysics(),
                    dividerColor: Colors.transparent,
                    isScrollable: true,
                    indicatorSize: TabBarIndicatorSize.tab,
                    onTap: (index) {
                      context.read<OrdersBloc>().add(
                        ChangeOrdersTabEvent(index),
                      );
                    },
                    indicator: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      color:
                          state.selectedTabIndex == 0
                              ? Colors.blue
                              : state.selectedTabIndex == 1
                              ? Colors.green
                              : Colors.red,
                    ),
                    labelColor: Colors.white,
                    unselectedLabelColor:
                        Theme.of(context).colorScheme.onSecondary,
                    labelStyle: const TextStyle(
                      fontFamily: FontFamily.fontsPoppinsSemiBold,
                      fontSize: 14,
                    ),
                    tabs: [
                      Tab(
                        icon: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 15.0),
                          child: Text(Labels.activeOrders),
                        ),
                      ),
                      Tab(
                        icon: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 15.0),
                          child: Text(Labels.completedOrders),
                        ),
                      ),
                      Tab(
                        icon: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 15.0),
                          child: Text(Labels.cancelledOrders),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 10),

                // Tab Content
                Expanded(
                  child: TabBarView(
                    controller: _tabController,
                    children: [
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
}
