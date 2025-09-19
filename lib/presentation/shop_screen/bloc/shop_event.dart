import 'package:equatable/equatable.dart';

abstract class ShopEvent extends Equatable{
  @override
  List<Object?> get props => [];
}

class ChangeTabEvent extends ShopEvent{
  final int index;
  ChangeTabEvent(this.index);

  @override
  List<Object?> get props => [index];
}

class LoadShopDetailEvent extends ShopEvent {
  final int storeId;
  LoadShopDetailEvent({required this.storeId});
  
  @override
  List<Object?> get props => [storeId];
}