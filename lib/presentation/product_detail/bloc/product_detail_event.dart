import 'package:equatable/equatable.dart';

abstract class ProductDetailEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class ShowBottomBar extends ProductDetailEvent {}

class HideBottomBar extends ProductDetailEvent {}

class LoadProductDetail extends ProductDetailEvent {
  final String productId;

  LoadProductDetail({required this.productId});

  @override
  List<Object?> get props => [productId];
}

class IncrementQuantity extends ProductDetailEvent {}

class DecrementQuantity extends ProductDetailEvent {}
