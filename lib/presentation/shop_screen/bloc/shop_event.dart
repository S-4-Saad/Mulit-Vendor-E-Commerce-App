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

class LoadCategoriesEvent extends ShopEvent {
  final int storeId;
  LoadCategoriesEvent({required this.storeId});
  
  @override
  List<Object?> get props => [storeId];
}

class LoadProductsEvent extends ShopEvent {
  final int storeId;
  final String categoryId;
  LoadProductsEvent({required this.storeId, required this.categoryId});
  
  @override
  List<Object?> get props => [storeId, categoryId];
}

class ClearStoreDataEvent extends ShopEvent {
  ClearStoreDataEvent();
  
  @override
  List<Object?> get props => [];
}
class FetchShopReviewsEvent extends ShopEvent {
  final int storeId;
  FetchShopReviewsEvent({required this.storeId, });

  @override
  List<Object?> get props => [storeId];
}