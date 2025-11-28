import 'package:bloc/bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:speezu/core/services/urls.dart';
import 'package:speezu/models/order_model.dart';
import 'package:speezu/presentation/orders/bloc/order_state.dart';
import 'package:speezu/presentation/orders/bloc/orders_event.dart';

import '../../../core/services/api_services.dart';

class OrdersBloc extends Bloc<OrdersEvent, OrderState> {
  OrdersBloc() : super(const OrderState()) {
    on<ChangeOrdersTabEvent>(_changeTab);
    on<LoadOrdersEvent>(_loadOrders);
    on<RefreshOrdersEvent>(_refreshOrders);
    on<CancelOrderEvent>(_cancelOrder);
  }

  void _changeTab(ChangeOrdersTabEvent event, Emitter<OrderState> emit) {
    emit(state.copyWith(selectedTabIndex: event.index));
  }

  Future<void> _loadOrders(
    LoadOrdersEvent event,
    Emitter<OrderState> emit,
  ) async {
    emit(state.copyWith(status: OrderStatus.loading));

    await ApiService.getMethod(
      apiUrl: orderHistoryUrl,
      authHeader: true,
      executionMethod: (bool success, dynamic response) async {
        if (success && response['success'] == true) {
          final ordersResponse = OrdersResponse.fromJson(response);

          // Separate orders by status
          final activeOrders =
              ordersResponse.orders
                  .where((order) => order.status.toLowerCase() == 'approved'||order.status.toLowerCase()=="pending"||order.status.toLowerCase()=="pickedup")
                  .toList();
          print('Active Orders $activeOrders}');

          final completedOrders =
              ordersResponse.orders
                  .where((order) => order.status.toLowerCase() == 'completed'|| order.status.toLowerCase()=='delivered')
                  .toList();
          final cancelledOrders =
              ordersResponse.orders
                  .where((order) => order.status.toLowerCase() == 'cancelled'||order.status.toLowerCase()=='rejected')
                  .toList();

          emit(
            state.copyWith(
              status: OrderStatus.success,
              activeOrders: activeOrders,
              completedOrders: completedOrders,
              cancelledOrders: cancelledOrders,
              errorMessage: null,
            ),
          );
        } else {
          emit(
            state.copyWith(
              status: OrderStatus.error,
              errorMessage: response['message'] ?? 'Failed to load orders',
            ),
          );
        }
      },
    );
  }

  Future<void> _cancelOrder(
    CancelOrderEvent event,
    Emitter<OrderState> emit,
  ) async {
    emit(state.copyWith(cancelOrderStatus: CancelOrderStatus.loading));
    final cancelUrl = '$cancelOrderUrl${event.orderId}/cancel';
    print('Cancelling order at URL: $cancelUrl with reason: ${event.reason}');

    await ApiService.postMethod(
      apiUrl: cancelUrl,
      postData: {'cancellation_reason': event.reason},
      authHeader: true,
      executionMethod: (bool success, dynamic response) async {
        if (success && response['success'] == true) {
          emit(
            state.copyWith(
              cancelOrderStatus: CancelOrderStatus.success,
              errorMessage: response['message'] ?? null,
            ),
          );

          // Automatically refresh the orders list after successful cancellation

          add(LoadOrdersEvent());
          Navigator.pop(event.context);
        } else {
          emit(
            state.copyWith(
              cancelOrderStatus: CancelOrderStatus.error,
              errorMessage: response['message'] ?? 'Failed to Cancel orders',
            ),
          );
        }
      },
    );
  }

  Future<void> _refreshOrders(
    RefreshOrdersEvent event,
    Emitter<OrderState> emit,
  ) async {
    add(LoadOrdersEvent());
  }
}
