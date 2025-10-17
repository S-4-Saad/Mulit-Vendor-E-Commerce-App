import 'package:equatable/equatable.dart';

abstract class OrdersEvent extends Equatable {}

class ChangeOrdersTabEvent extends OrdersEvent {
  final int index;
  ChangeOrdersTabEvent(this.index);

  @override
  List<Object?> get props => [index];
}

class LoadOrdersEvent extends OrdersEvent {
  @override
  List<Object?> get props => [];
}

class RefreshOrdersEvent extends OrdersEvent {
  @override
  List<Object?> get props => [];
}
class CancelOrderEvent extends OrdersEvent {
  final String orderId;
  final String reason;

  CancelOrderEvent({required this.orderId, required this.reason});

  @override
  List<Object?> get props => [orderId, reason];
}