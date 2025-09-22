import 'package:equatable/equatable.dart';

abstract class ProductsEvent extends Equatable{}

class ChangeTabEvent extends ProductsEvent{
  final int index;
  ChangeTabEvent(this.index);

  @override
  List<Object?> get props => [index];
}

class LoadProductsEvent extends ProductsEvent {
  final String categoryName;
  final bool forceReload;
  LoadProductsEvent({required this.categoryName,this.forceReload=false});
  
  @override
  List<Object?> get props => [categoryName];
}