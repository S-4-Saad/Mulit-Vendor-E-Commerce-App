import 'package:equatable/equatable.dart';
import '../../../models/cart_model.dart';
import '../../../models/address_model.dart';
import '../../../models/card_details_model.dart';
import '../../../models/payment_model.dart';
import 'cart_event.dart';

enum CartStatus { initial, loading, success, error }

class CartState extends Equatable {
  final CartStatus status;
  final Cart cart;
  final String? errorMessage;
  
  // Checkout related fields
  final CheckoutMethod? selectedMethod;
  final AddressModel? selectedAddress;
  final String? deliveryInstructions;
  final CardDetailsModel? selectedCard;
  final PaymentResult? paymentResult;
  final List<AddressModel> addresses;
  final bool orderPlacedSuccessfully;

  const CartState({
    this.status = CartStatus.initial,
    this.cart = const Cart(),
    this.errorMessage,
    this.selectedMethod,
    this.selectedAddress,
    this.deliveryInstructions,
    this.selectedCard,
    this.paymentResult,
    this.addresses = const [],
    this.orderPlacedSuccessfully = false,
  });

  CartState copyWith({
    CartStatus? status,
    Cart? cart,
    String? errorMessage,
    CheckoutMethod? selectedMethod,
    AddressModel? selectedAddress,
    String? deliveryInstructions,
    CardDetailsModel? selectedCard,
    PaymentResult? paymentResult,
    List<AddressModel>? addresses,
    bool? orderPlacedSuccessfully,
  }) {
    return CartState(
      status: status ?? this.status,
      cart: cart ?? this.cart,
      errorMessage: errorMessage ?? this.errorMessage,
      selectedMethod: selectedMethod ?? this.selectedMethod,
      selectedAddress: selectedAddress ?? this.selectedAddress,
      deliveryInstructions: deliveryInstructions ?? this.deliveryInstructions,
      selectedCard: selectedCard ?? this.selectedCard,
      paymentResult: paymentResult ?? this.paymentResult,
      addresses: addresses ?? this.addresses,
      orderPlacedSuccessfully: orderPlacedSuccessfully ?? this.orderPlacedSuccessfully,
    );
  }

  // Helper getters for easy access
  List<CartItem> get items => cart.items;
  int get totalItems => cart.totalItems;
  double get subtotal => cart.subtotal;
  double get taxAmount => cart.taxAmount;
  double get deliveryFee => cart.deliveryFee;
  double get totalAmount => cart.totalAmount;
  bool get isEmpty => cart.isEmpty;
  bool get isNotEmpty => cart.isNotEmpty;
  int get uniqueShopsCount => cart.uniqueShopsCount;
  String? get currentStoreId => cart.currentStoreId;
  
  // Store validation helpers
  bool hasItemsFromStore(String storeId) => cart.hasItemsFromStore(storeId);
  int getItemCountForStore(String storeId) => cart.getItemCountForStore(storeId);

  @override
  List<Object?> get props => [
    status, 
    cart, 
    errorMessage, 
    selectedMethod, 
    selectedAddress, 
    deliveryInstructions,
    selectedCard, 
    paymentResult, 
    addresses,
    orderPlacedSuccessfully
  ];
}
