import 'package:equatable/equatable.dart';
import '../../../models/product_detail_model.dart';

abstract class CartEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class AddToCart extends CartEvent {
  final ProductDetail product;
  final int quantity;
  final String? variationParentName;
  final String? variationParentValue;
  final String? variationChildName;
  final String? variationChildValue;

  AddToCart({
    required this.product,
    required this.quantity,
    this.variationParentName,
    this.variationParentValue,
    this.variationChildName,
    this.variationChildValue,
  });

  @override
  List<Object?> get props => [
        product,
        quantity,
        variationParentName,
        variationParentValue,
        variationChildName,
        variationChildValue,
      ];
}

class RemoveFromCart extends CartEvent {
  final String cartItemId;

  RemoveFromCart({required this.cartItemId});

  @override
  List<Object?> get props => [cartItemId];
}

class UpdateCartItemQuantity extends CartEvent {
  final String cartItemId;
  final int newQuantity;

  UpdateCartItemQuantity({
    required this.cartItemId,
    required this.newQuantity,
  });

  @override
  List<Object?> get props => [cartItemId, newQuantity];
}

class IncrementCartItemQuantity extends CartEvent {
  final String cartItemId;

  IncrementCartItemQuantity({required this.cartItemId});

  @override
  List<Object?> get props => [cartItemId];
}

class DecrementCartItemQuantity extends CartEvent {
  final String cartItemId;

  DecrementCartItemQuantity({required this.cartItemId});

  @override
  List<Object?> get props => [cartItemId];
}

class ClearCart extends CartEvent {}

class UpdateDeliveryFee extends CartEvent {
  final double deliveryFee;

  UpdateDeliveryFee({required this.deliveryFee});

  @override
  List<Object?> get props => [deliveryFee];
}

class UpdateTaxRate extends CartEvent {
  final double taxRate;

  UpdateTaxRate({required this.taxRate});

  @override
  List<Object?> get props => [taxRate];
}

class ClearCartForNewStore extends CartEvent {
  final String newStoreId;

  ClearCartForNewStore({required this.newStoreId});

  @override
  List<Object?> get props => [newStoreId];
}
