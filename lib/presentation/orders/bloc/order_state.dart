import 'package:equatable/equatable.dart';
import '../../../models/order_model.dart';

enum OrderStatus { initial, loading, success, error }

class OrderState extends Equatable {
  final int selectedTabIndex;
  final OrderStatus status;
  final List<OrderModel> activeOrders;
  final List<OrderModel> completedOrders;
  final List<OrderModel> cancelledOrders;
  final String? errorMessage;

  const OrderState({
    this.selectedTabIndex = 0,
    this.status = OrderStatus.initial,
    this.activeOrders = const [],
    this.completedOrders = const [],
    this.cancelledOrders = const [],
    this.errorMessage,
  });

  OrderState copyWith({
    int? selectedTabIndex,
    OrderStatus? status,
    List<OrderModel>? activeOrders,
    List<OrderModel>? completedOrders,
    List<OrderModel>? cancelledOrders,
    String? errorMessage,
  }) {
    return OrderState(
      selectedTabIndex: selectedTabIndex ?? this.selectedTabIndex,
      status: status ?? this.status,
      activeOrders: activeOrders ?? this.activeOrders,

      completedOrders: completedOrders ?? this.completedOrders,
      cancelledOrders: cancelledOrders ?? this.cancelledOrders,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [
        selectedTabIndex,
        status,
        activeOrders,
        completedOrders,
        cancelledOrders,
        errorMessage,
      ];
}
