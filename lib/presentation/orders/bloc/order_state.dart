import 'package:equatable/equatable.dart';
import '../../../models/order_model.dart';

enum OrderStatus { initial, loading, success, error }
enum CancelOrderStatus { initial, loading, success, error }

class OrderState extends Equatable {
  final int selectedTabIndex;
  final OrderStatus status;
  final CancelOrderStatus cancelOrderStatus;
  final List<OrderModel> activeOrders;
  final List<OrderModel> completedOrders;
  final List<OrderModel> cancelledOrders;
  final String? errorMessage;

  const OrderState({
    this.selectedTabIndex = 0,
    this.status = OrderStatus.initial,
    this.cancelOrderStatus = CancelOrderStatus.initial,
    this.activeOrders = const [],
    this.completedOrders = const [],
    this.cancelledOrders = const [],
    this.errorMessage,
  });

  OrderState copyWith({
    int? selectedTabIndex,
    OrderStatus? status,
    CancelOrderStatus? cancelOrderStatus,
    List<OrderModel>? activeOrders,
    List<OrderModel>? completedOrders,
    List<OrderModel>? cancelledOrders,
    String? errorMessage,
  }) {
    return OrderState(
      selectedTabIndex: selectedTabIndex ?? this.selectedTabIndex,
      status: status ?? this.status,
      cancelOrderStatus: cancelOrderStatus ?? this.cancelOrderStatus,
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
        cancelOrderStatus,
      ];
}
