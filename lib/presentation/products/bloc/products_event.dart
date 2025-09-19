import 'package:equatable/equatable.dart';

abstract class ProductsEvent extends Equatable{}

class ChangeTabEvent extends ProductsEvent{
  final int index;
  ChangeTabEvent(this.index);

  @override
  List<Object?> get props => [index];
}