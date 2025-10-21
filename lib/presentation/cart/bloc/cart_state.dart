import 'package:equatable/equatable.dart';
import 'package:speezu/models/coupon_model.dart';
import '../../../models/cart_model.dart';
import '../../../models/address_model.dart';
import '../../../models/card_details_model.dart';
import '../../../models/payment_model.dart';
import 'cart_event.dart';

enum CartStatus { initial, loading, success, error }
enum AddressLoadStatus { initial, loading, success, error }
enum CouponLoading { initial, loading, success, error }
enum CouponStatus { initial, wrong, success,notApplicable }

class CartState extends Equatable {
  final CartStatus status;
  final CouponLoading couponLoading;
  final AddressLoadStatus addressLoadStatus;
  final Cart cart;
  final String? errorMessage;
  final CouponModel? couponModel;
  final CouponStatus couponStatus;

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
    this.couponStatus = CouponStatus.initial,
    this.couponLoading = CouponLoading.initial,
    this.addressLoadStatus = AddressLoadStatus.initial,
    this.cart = const Cart(),
    this.errorMessage,
    this.selectedMethod,
    this.selectedAddress,
    this.couponModel,
    this.deliveryInstructions,
    this.selectedCard,
    this.paymentResult,
    this.addresses = const [],
    this.orderPlacedSuccessfully = false,
  });

  CartState copyWith({
    CartStatus? status,
    CouponLoading? couponLoading,
    AddressLoadStatus? addressLoadStatus,
    Cart? cart,
    String? errorMessage,
    CouponStatus? couponStatus,
    CheckoutMethod? selectedMethod,
    AddressModel? selectedAddress,
    CouponModel? couponModel,
    String? deliveryInstructions,
    CardDetailsModel? selectedCard,
    PaymentResult? paymentResult,
    List<AddressModel>? addresses,
    bool? orderPlacedSuccessfully,

  }) {
    return CartState(
      status: status ?? this.status,
      cart: cart ?? this.cart,
      couponLoading: couponLoading ?? this.couponLoading,
      errorMessage: errorMessage ?? this.errorMessage,
      addressLoadStatus: addressLoadStatus ?? this.addressLoadStatus,
      couponStatus: couponStatus ?? this.couponStatus,
      selectedMethod: selectedMethod ?? this.selectedMethod,
      selectedAddress: selectedAddress ?? this.selectedAddress,
      couponModel: couponModel ?? this.couponModel,
      deliveryInstructions: deliveryInstructions ?? this.deliveryInstructions,
      selectedCard: selectedCard ?? this.selectedCard,
      paymentResult: paymentResult ?? this.paymentResult,
      addresses: addresses ?? this.addresses,
      orderPlacedSuccessfully:
          orderPlacedSuccessfully ?? this.orderPlacedSuccessfully,
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
  int getItemCountForStore(String storeId) =>
      cart.getItemCountForStore(storeId);

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
    orderPlacedSuccessfully,
    couponModel,
    couponStatus,
    couponLoading,
    addressLoadStatus,
  ];
}
