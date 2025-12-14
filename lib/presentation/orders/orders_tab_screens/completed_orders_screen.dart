import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:speezu/presentation/order_details/order_details_screen.dart';
import '../../../core/utils/labels.dart';
import '../../../widgets/active_orders_shimmer.dart';
import '../../../widgets/error_widget.dart';
import '../../../widgets/order_card.dart';
import '../bloc/orders_bloc.dart';
import '../bloc/orders_event.dart';
import '../bloc/order_state.dart';

class CompletedOrdersScreen extends StatefulWidget {
  const CompletedOrdersScreen({super.key});

  @override
  State<CompletedOrdersScreen> createState() => _CompletedOrdersScreenState();
}

class _CompletedOrdersScreenState extends State<CompletedOrdersScreen> {
  @override
  void initState() {
    super.initState();
    // Load orders when screen initializes
    context.read<OrdersBloc>().add(LoadOrdersEvent());
  }

  String _formatDateTime(String dateTime) {
    try {
      final parsedDate = DateTime.parse(dateTime);
      return DateFormat('dd MMM, yyyy | hh:mm a').format(parsedDate);
    } catch (e) {
      return dateTime; // Return original if parsing fails
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<OrdersBloc, OrderState>(
        builder: (context, state) {
          if (state.status == OrderStatus.loading) {
            return const ActiveOrdersShimmer();
          }

          if (state.status == OrderStatus.error) {
            return Center(
              child: CustomErrorWidget(
                message: state.errorMessage ?? Labels.error,
                onRetry: () {
                  context.read<OrdersBloc>().add(RefreshOrdersEvent());
                },
              ),
            );
          }

          if (state.completedOrders.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.check_circle_outline,
                    size: 64,
                    color: Colors.grey[400],
                  ),
                  const SizedBox(height: 16),
                  Text(
                    Labels.noCompletedOrders,
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    Labels.youDoNotHaveAnyCompletedOrders,
                    style: Theme.of(context).textTheme.bodyMedium,
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            );
          }

          return RefreshIndicator(
            onRefresh: () async {
              context.read<OrdersBloc>().add(RefreshOrdersEvent());
            },
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: state.completedOrders.length,
              itemBuilder: (context, index) {
                final order = state.completedOrders[index];
                return Padding(
                  padding: const EdgeInsets.only(bottom: 16),
                  child: OrderCard(
                    orderCode: order.orderCode,
                    status: order.status,
                    orderId: order.orderId,
                    customerName: order.customerName,
                    paymentMethod: order.paymentMethod,
                    amount: order.amount,
                    dateTime: _formatDateTime(order.dateTime),
                    onViewDetails: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder:
                              (context) => OrderDetailsScreen(
                                orderId: order.orderId,
                                orderStatus: order.status,
                              ),
                        ),
                      );
                    },
                    onCancel: () {
                      // Completed orders cannot be cancelled
                    },
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}
