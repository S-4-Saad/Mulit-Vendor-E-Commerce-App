import 'package:equatable/equatable.dart';

import '../../../models/product_detail_model.dart';
import '../../../models/cart_model.dart';
import '../../../models/address_model.dart';
import '../../../models/card_details_model.dart';
import '../../../models/payment_model.dart';

enum CheckoutMethod { pickup, delivery }

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
  final String? variationParentId;
  final String? variationChildId;
  final double? calculatedPrice; // Pre-calculated price from product detail
  final double?
  calculatedOriginalPrice; // Pre-calculated original price from product detail

  AddToCart({
    required this.product,
    required this.quantity,
    this.variationParentName,
    this.variationParentValue,
    this.variationChildName,
    this.variationChildValue,
    this.variationParentId,
    this.variationChildId,
    this.calculatedPrice,
    this.calculatedOriginalPrice,
  });

  @override
  List<Object?> get props => [
    product,
    quantity,
    variationParentName,
    variationParentValue,
    variationChildName,
    variationChildValue,
    variationParentId,
    variationChildId,
    calculatedPrice,
    calculatedOriginalPrice,
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

  UpdateCartItemQuantity({required this.cartItemId, required this.newQuantity});

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

class AuthenticationRequired extends CartEvent {
  final String message;

  AuthenticationRequired({required this.message});

  @override
  List<Object?> get props => [message];
}

class LoadCartFromStorage extends CartEvent {}

class SaveCartToStorage extends CartEvent {
  final Cart cart;

  SaveCartToStorage({required this.cart});

  @override
  List<Object?> get props => [cart];
}

class ClearCartOnLogout extends CartEvent {}

// Checkout related events
class SetCheckoutMethod extends CartEvent {
  final CheckoutMethod method;

  SetCheckoutMethod({required this.method});

  @override
  List<Object?> get props => [method];
}

class SetSelectedAddress extends CartEvent {
  final AddressModel? address;

  SetSelectedAddress({this.address});

  @override
  List<Object?> get props => [address];
}

class SetDeliveryInstructions extends CartEvent {
  final String? instructions;

  SetDeliveryInstructions({this.instructions});

  @override
  List<Object?> get props => [instructions];
}

class SetAddresses extends CartEvent {
  final List<AddressModel> addresses;

  SetAddresses({required this.addresses});

  @override
  List<Object?> get props => [addresses];
}

class SetSelectedCard extends CartEvent {
  final CardDetailsModel? card;

  SetSelectedCard({this.card});

  @override
  List<Object?> get props => [card];
}

class SetPaymentResult extends CartEvent {
  final PaymentResult? paymentResult;

  SetPaymentResult({this.paymentResult});

  @override
  List<Object?> get props => [paymentResult];
}

class ProcessOrder extends CartEvent {
  final String paymentMethod;
  final PaymentResult? paymentResult;
  final CardDetailsModel? selectedCard;

  ProcessOrder({
    required this.paymentMethod,
    this.paymentResult,
    this.selectedCard,
  });

  @override
  List<Object?> get props => [paymentMethod, paymentResult, selectedCard];
}

class PostOrder extends CartEvent {
  final String paymentMethod;
  final PaymentResult? paymentResult;
  final CardDetailsModel? selectedCard;

  PostOrder({
    required this.paymentMethod,
    this.paymentResult,
    this.selectedCard,
  });

  @override
  List<Object?> get props => [paymentMethod, paymentResult, selectedCard];
}

class ResetCheckout extends CartEvent {}

class ResetCartStatus extends CartEvent {}

class CouponCodeChanged extends CartEvent {
  final String code;
  CouponCodeChanged(this.code);
  @override
  List<Object?> get props => [code];
}

class ResetCouponStatus extends CartEvent {}
