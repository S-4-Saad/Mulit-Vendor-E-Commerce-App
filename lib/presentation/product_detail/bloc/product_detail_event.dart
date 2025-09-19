import 'package:equatable/equatable.dart';

abstract class ProductDetailEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class ShowBottomBar extends ProductDetailEvent {}

class HideBottomBar extends ProductDetailEvent {}
