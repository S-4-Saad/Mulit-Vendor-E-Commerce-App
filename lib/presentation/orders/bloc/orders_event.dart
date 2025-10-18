import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

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
   final BuildContext context;
  CancelOrderEvent({required this.orderId, required this.reason, required this.context});

  @override
  List<Object?> get props => [orderId, reason, context];
}