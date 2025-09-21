import 'package:equatable/equatable.dart';
import '../../../models/cart_model.dart';

enum CartStatus { initial, loading, success, error }

class CartState extends Equatable {
  final CartStatus status;
  final Cart cart;
  final String? errorMessage;

  const CartState({
    this.status = CartStatus.initial,
    this.cart = const Cart(),
    this.errorMessage,
  });

  CartState copyWith({
    CartStatus? status,
    Cart? cart,
    String? errorMessage,
  }) {
    return CartState(
      status: status ?? this.status,
      cart: cart ?? this.cart,
      errorMessage: errorMessage ?? this.errorMessage,
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
  List<Object?> get props => [status, cart, errorMessage];
}
