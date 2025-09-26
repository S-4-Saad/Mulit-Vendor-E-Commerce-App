import 'package:bloc/bloc.dart';
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
  }

  void _changeTab(ChangeOrdersTabEvent event, Emitter<OrderState> emit) {
    emit(state.copyWith(selectedTabIndex: event.index));
  }

  Future<void> _loadOrders(LoadOrdersEvent event, Emitter<OrderState> emit) async {
    emit(state.copyWith(status: OrderStatus.loading));

    await ApiService.getMethod(
      apiUrl: orderHistoryUrl,
      authHeader: true,
      executionMethod: (bool success, dynamic response) async {
        if (success && response['success'] == true) {
          final ordersResponse = OrdersResponse.fromJson(response);
          
          // Separate orders by status
          final activeOrders = ordersResponse.orders
              .where((order) => order.status.toLowerCase() == 'active')
              .toList();
          
          final completedOrders = ordersResponse.orders
              .where((order) => order.status.toLowerCase() == 'completed')
              .toList();

          emit(state.copyWith(
            status: OrderStatus.success,
            activeOrders: activeOrders,
            completedOrders: completedOrders,
            errorMessage: null,
          ));
        } else {
          emit(state.copyWith(
            status: OrderStatus.error,
            errorMessage: response['message'] ?? 'Failed to load orders',
          ));
        }
      },
    );
  }

  Future<void> _refreshOrders(RefreshOrdersEvent event, Emitter<OrderState> emit) async {
    add(LoadOrdersEvent());
  }
}
