import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:speezu/core/services/urls.dart';
import 'dart:convert';
import 'cart_event.dart';
import 'cart_state.dart';
import '../../../models/cart_model.dart';
import '../../../models/card_details_model.dart';
import '../../../models/payment_model.dart';
import '../../../repositories/user_repository.dart';
import '../../../core/services/api_services.dart';

class CartBloc extends Bloc<CartEvent, CartState> {
  CartBloc() : super(const CartState()) {
    on<AddToCart>(_onAddToCart);
    on<RemoveFromCart>(_onRemoveFromCart);
    on<UpdateCartItemQuantity>(_onUpdateCartItemQuantity);
    on<IncrementCartItemQuantity>(_onIncrementCartItemQuantity);
    on<DecrementCartItemQuantity>(_onDecrementCartItemQuantity);
    on<ClearCart>(_onClearCart);
    on<ClearCartForNewStore>(_onClearCartForNewStore);
    on<UpdateDeliveryFee>(_onUpdateDeliveryFee);
    on<UpdateTaxRate>(_onUpdateTaxRate);
    on<AuthenticationRequired>(_onAuthenticationRequired);
    on<LoadCartFromStorage>(_onLoadCartFromStorage);
    on<SaveCartToStorage>(_onSaveCartToStorage);
    on<ClearCartOnLogout>(_onClearCartOnLogout);

    // Checkout related events
    on<SetCheckoutMethod>(_onSetCheckoutMethod);
    on<SetSelectedAddress>(_onSetSelectedAddress);
    on<SetDeliveryInstructions>(_onSetDeliveryInstructions);
    on<SetAddresses>(_onSetAddresses);
    on<SetSelectedCard>(_onSetSelectedCard);
    on<SetPaymentResult>(_onSetPaymentResult);
    on<ProcessOrder>(_onProcessOrder);
    on<PostOrder>(_onPostOrder);
    on<ResetCheckout>(_onResetCheckout);
    on<ResetCartStatus>(_onResetCartStatus); // Add this line

    // Load cart data on initialization
    add(LoadCartFromStorage());
  }

  // Load cart data from UserRepository
  Future<Cart?> _loadCartFromStorage() async {
    try {
      final userRepository = UserRepository();
      return userRepository.currentCart;
    } catch (e) {
      print('Error loading cart from UserRepository: $e');
      return null;
    }
  }

  // Save cart data to UserRepository
  Future<void> _saveCartToStorage(Cart cart) async {
    try {
      final userRepository = UserRepository();
      await userRepository.setCart(cart);
    } catch (e) {
      print('Error saving cart to UserRepository: $e');
    }
  }

  void _onAddToCart(AddToCart event, Emitter<CartState> emit) {
    try {
      // Create cart item from product
      final newCartItem = CartItem.fromProductDetail(
        event.product,
        event.quantity,
        variationParentName: event.variationParentName,
        variationParentValue: event.variationParentValue,
        variationChildName: event.variationChildName,
        variationChildValue: event.variationChildValue,
        variationParentId: event.variationParentId,
        variationChildId: event.variationChildId,
        storeId: event.product.shop.id.toString(), // Real server store ID
      );

      // Check if cart has items from a different store
      if (state.cart.isNotEmpty &&
          state.cart.currentStoreId != newCartItem.storeId) {
        print(
          'Store conflict detected: Current store: ${state.cart.currentStoreId}, New store: ${newCartItem.storeId}',
        );
        emit(
          state.copyWith(
            status: CartStatus.error,
            errorMessage:
                'STORE_CONFLICT:${newCartItem.storeId}:${state.cart.currentStoreId}',
          ),
        );
        return;
      }

      // Check if item already exists in cart
      final existingItemIndex = state.cart.items.indexWhere(
        (item) => item.id == newCartItem.id,
      );

      List<CartItem> updatedItems;

      if (existingItemIndex != -1) {
        // Update existing item quantity
        final existingItem = state.cart.items[existingItemIndex];
        final updatedItem = existingItem.copyWith(
          quantity: existingItem.quantity + event.quantity,
        );
        updatedItems = List.from(state.cart.items);
        updatedItems[existingItemIndex] = updatedItem;
      } else {
        // Add new item
        updatedItems = [...state.cart.items, newCartItem];
      }

      final updatedCart = state.cart.copyWith(items: updatedItems);

      emit(
        state.copyWith(
          status: CartStatus.success,
          cart: updatedCart,
          errorMessage: null,
        ),
      );

      // Save to local storage
      add(SaveCartToStorage(cart: updatedCart));
    } catch (e) {
      emit(
        state.copyWith(
          status: CartStatus.error,
          errorMessage: 'Failed to add item to cart: ${e.toString()}',
        ),
      );
    }
  }

  void _onRemoveFromCart(RemoveFromCart event, Emitter<CartState> emit) {
    try {
      final updatedItems =
          state.cart.items
              .where((item) => item.id != event.cartItemId)
              .toList();

      final updatedCart = state.cart.copyWith(items: updatedItems);

      emit(
        state.copyWith(
          status: CartStatus.success,
          cart: updatedCart,
          errorMessage: null,
        ),
      );

      // Save to local storage
      add(SaveCartToStorage(cart: updatedCart));
    } catch (e) {
      emit(
        state.copyWith(
          status: CartStatus.error,
          errorMessage: 'Failed to remove item from cart: ${e.toString()}',
        ),
      );
    }
  }

  void _onUpdateCartItemQuantity(
    UpdateCartItemQuantity event,
    Emitter<CartState> emit,
  ) {
    try {
      if (event.newQuantity <= 0) {
        // Remove item if quantity is 0 or negative
        add(RemoveFromCart(cartItemId: event.cartItemId));
        return;
      }

      final updatedItems =
          state.cart.items.map((item) {
            if (item.id == event.cartItemId) {
              return item.copyWith(quantity: event.newQuantity);
            }
            return item;
          }).toList();

      final updatedCart = state.cart.copyWith(items: updatedItems);

      emit(
        state.copyWith(
          status: CartStatus.success,
          cart: updatedCart,
          errorMessage: null,
        ),
      );

      // Save to local storage
      add(SaveCartToStorage(cart: updatedCart));
    } catch (e) {
      emit(
        state.copyWith(
          status: CartStatus.error,
          errorMessage: 'Failed to update item quantity: ${e.toString()}',
        ),
      );
    }
  }

  void _onIncrementCartItemQuantity(
    IncrementCartItemQuantity event,
    Emitter<CartState> emit,
  ) {
    final item = state.cart.items.firstWhere(
      (item) => item.id == event.cartItemId,
      orElse: () => throw Exception('Cart item not found'),
    );

    add(
      UpdateCartItemQuantity(
        cartItemId: event.cartItemId,
        newQuantity: item.quantity + 1,
      ),
    );
  }

  void _onDecrementCartItemQuantity(
    DecrementCartItemQuantity event,
    Emitter<CartState> emit,
  ) {
    final item = state.cart.items.firstWhere(
      (item) => item.id == event.cartItemId,
      orElse: () => throw Exception('Cart item not found'),
    );

    if (item.quantity > 1) {
      add(
        UpdateCartItemQuantity(
          cartItemId: event.cartItemId,
          newQuantity: item.quantity - 1,
        ),
      );
    } else {
      // Remove item if quantity becomes 0
      add(RemoveFromCart(cartItemId: event.cartItemId));
    }
  }

  void _onClearCart(ClearCart event, Emitter<CartState> emit) {
    try {
      final updatedCart = state.cart.copyWith(items: []);

      emit(
        state.copyWith(
          status: CartStatus.success,
          cart: updatedCart,
          errorMessage: null,
          orderPlacedSuccessfully:
              state.orderPlacedSuccessfully, // Preserve the flag
        ),
      );

      // Save to local storage
      add(SaveCartToStorage(cart: updatedCart));
    } catch (e) {
      emit(
        state.copyWith(
          status: CartStatus.error,
          errorMessage: 'Failed to clear cart: ${e.toString()}',
        ),
      );
    }
  }

  void _onClearCartForNewStore(
    ClearCartForNewStore event,
    Emitter<CartState> emit,
  ) {
    try {
      final updatedCart = state.cart.copyWith(items: []);

      emit(
        state.copyWith(
          status: CartStatus.success,
          cart: updatedCart,
          errorMessage: null,
        ),
      );

      // Save to local storage
      add(SaveCartToStorage(cart: updatedCart));
    } catch (e) {
      emit(
        state.copyWith(
          status: CartStatus.error,
          errorMessage: 'Failed to clear cart for new store: ${e.toString()}',
        ),
      );
    }
  }

  void _onUpdateDeliveryFee(UpdateDeliveryFee event, Emitter<CartState> emit) {
    try {
      final updatedCart = state.cart.copyWith(deliveryFee: event.deliveryFee);

      emit(
        state.copyWith(
          status: CartStatus.success,
          cart: updatedCart,
          errorMessage: null,
        ),
      );

      // Save to local storage
      add(SaveCartToStorage(cart: updatedCart));
    } catch (e) {
      emit(
        state.copyWith(
          status: CartStatus.error,
          errorMessage: 'Failed to update delivery fee: ${e.toString()}',
        ),
      );
    }
  }

  void _onUpdateTaxRate(UpdateTaxRate event, Emitter<CartState> emit) {
    try {
      final updatedCart = state.cart.copyWith(taxRate: event.taxRate);

      emit(
        state.copyWith(
          status: CartStatus.success,
          cart: updatedCart,
          errorMessage: null,
        ),
      );

      // Save to local storage
      add(SaveCartToStorage(cart: updatedCart));
    } catch (e) {
      emit(
        state.copyWith(
          status: CartStatus.error,
          errorMessage: 'Failed to update tax rate: ${e.toString()}',
        ),
      );
    }
  }

  void _onAuthenticationRequired(
    AuthenticationRequired event,
    Emitter<CartState> emit,
  ) {
    emit(
      state.copyWith(
        status: CartStatus.error,
        errorMessage: 'AUTHENTICATION_REQUIRED:${event.message}',
      ),
    );
  }

  void _onLoadCartFromStorage(
    LoadCartFromStorage event,
    Emitter<CartState> emit,
  ) async {
    final cart = await _loadCartFromStorage();
    if (cart != null) {
      emit(
        state.copyWith(
          cart: cart,
          status: CartStatus.success,
          errorMessage: null,
        ),
      );
    }
  }

  void _onSaveCartToStorage(
    SaveCartToStorage event,
    Emitter<CartState> emit,
  ) async {
    await _saveCartToStorage(event.cart);
  }

  void _onClearCartOnLogout(ClearCartOnLogout event, Emitter<CartState> emit) {
    // Clear cart data using UserRepository
    final userRepository = UserRepository();
    userRepository.clearCart();

    // Reset cart state
    emit(const CartState());
  }

  // Checkout related event handlers
  void _onSetCheckoutMethod(SetCheckoutMethod event, Emitter<CartState> emit) {
    emit(state.copyWith(selectedMethod: event.method));
  }

  void _onSetSelectedAddress(
    SetSelectedAddress event,
    Emitter<CartState> emit,
  ) {
    emit(state.copyWith(selectedAddress: event.address));
  }

  void _onSetDeliveryInstructions(
    SetDeliveryInstructions event,
    Emitter<CartState> emit,
  ) {
    emit(state.copyWith(deliveryInstructions: event.instructions));
  }

  void _onSetAddresses(SetAddresses event, Emitter<CartState> emit) {
    emit(state.copyWith(addresses: event.addresses));
  }

  void _onSetSelectedCard(SetSelectedCard event, Emitter<CartState> emit) {
    emit(state.copyWith(selectedCard: event.card));
  }

  void _onSetPaymentResult(SetPaymentResult event, Emitter<CartState> emit) {
    emit(state.copyWith(paymentResult: event.paymentResult));
  }

  void _onProcessOrder(ProcessOrder event, Emitter<CartState> emit) {
    // This is where you would handle the order processing logic
    // For now, just emit success status
    emit(
      state.copyWith(
        status: CartStatus.success,
        paymentResult: event.paymentResult,
        selectedCard: event.selectedCard,
      ),
    );
  }

  Future<void> _onPostOrder(PostOrder event, Emitter<CartState> emit) async {
    emit(state.copyWith(status: CartStatus.loading));

    try {
      // Prepare order data
      final orderData = _prepareOrderData(
        paymentMethod: event.paymentMethod,
        paymentResult: event.paymentResult,
        selectedCard: event.selectedCard,
      );

      print('=== POSTING ORDER TO SERVER ===');
      print('Order Data: ${jsonEncode(orderData)}');
      print('================================');

      // Post order to server
      await ApiService.postMethod(
        apiUrl: placeOrderUrl,
        postData: orderData,
        authHeader: true,
        executionMethod: (bool success, dynamic data) async {
          if (success && data['success'] == true) {
            print('Order posted successfully: ${jsonEncode(data)}');

            print('=== CART BLOC SUCCESS ===');
            print('Setting orderPlacedSuccessfully to true');
            print('==========================');

            emit(
              state.copyWith(
                status: CartStatus.success,
                paymentResult: event.paymentResult,
                selectedCard: event.selectedCard,
                orderPlacedSuccessfully: true,
              ),
            );

            // Clear cart after successful order (after emit)
            add(ClearCart());
            // also clear local cart storage
            await UserRepository().clearCart();
          } else {
            print('Order posting failed: $data');
            emit(
              state.copyWith(
                status: CartStatus.error,
                errorMessage:
                    'Failed to place order: ${data['message'] ?? 'Unknown error'}',
              ),
            );
          }
        },
      );
    } catch (e) {
      print('Error posting order: $e');
      emit(
        state.copyWith(
          status: CartStatus.error,
          errorMessage: 'Failed to place order: ${e.toString()}',
        ),
      );
    }
  }

  void _onResetCheckout(ResetCheckout event, Emitter<CartState> emit) {
    emit(
      state.copyWith(
        selectedMethod: null,
        selectedAddress: null,
        selectedCard: null,
        paymentResult: null,
        orderPlacedSuccessfully: false,
      ),
    );
  }

  void _onResetCartStatus(ResetCartStatus event, Emitter<CartState> emit) {
    emit(state.copyWith(
      status: CartStatus.initial,
      orderPlacedSuccessfully: false,
    ));
  }

  // Load addresses from UserRepository
  Future<void> loadAddresses() async {
    try {
      final userRepository = UserRepository();
      await userRepository.init();
      final addresses = userRepository.deliveryAddresses ?? [];
      final defaultAddress = userRepository.defaultAddress;

      // Use add() to trigger events instead of emit() directly
      add(SetAddresses(addresses: addresses));
      add(SetSelectedAddress(address: defaultAddress));
    } catch (e) {
      print('Error loading addresses: $e');
    }
  }

  // Prepare order data for API submission
  Map<String, dynamic> _prepareOrderData({
    required String paymentMethod,
    PaymentResult? paymentResult,
    CardDetailsModel? selectedCard,
  }) {
    final isCod =
        paymentMethod.toLowerCase().contains('cash') ||
        paymentMethod.toLowerCase().contains('cod');
    final isPickup = state.selectedMethod == CheckoutMethod.pickup;
    final isDelivery = state.selectedMethod == CheckoutMethod.delivery;
    final paymentType = isCod ? 'cod' : 'online';

    // Dynamic delivery fee (0 for pickup, actual fee for delivery)
    final dynamicDeliveryFee = isPickup ? 0.0 : state.deliveryFee;

    // Dynamic total amount calculation
    final dynamicTotalAmount =
        isPickup
            ? state.subtotal +
                state
                    .taxAmount // No delivery fee for pickup
            : state.totalAmount; // Include delivery fee for delivery

    return {
      'order_type': isPickup ? 'pickup' : 'delivery',
      'is_pickup': isPickup,
      'is_delivery': isDelivery,
      'is_cod': isCod,
      'payment_method': isPickup ? 'store_payment' : paymentType,
      'items':
          state.items
              .map(
                (item) => {
                  'product_id': item.productId,
                  'variation_parent_id': item.variationParentId,
                  'variation_child_id': item.variationChildId,
                  'quantity': item.quantity,
                  'store_id': item.storeId,
                },
              )
              .toList(),
      'delivery_address':
          isDelivery && state.selectedAddress != null
              ? {
                'address_id': state.selectedAddress!.id,
                'title': state.selectedAddress!.title,
                'customer_name': state.selectedAddress!.customerName,
                'primary_phone': state.selectedAddress!.primaryPhoneNumber,
                'secondary_phone': state.selectedAddress!.secondaryPhoneNumber,
                'address': state.selectedAddress!.address,
                'delivery_instructions':
                    state.deliveryInstructions?.isNotEmpty == true
                        ? state.deliveryInstructions
                        : null,
              }
              : null,
      'pickup_location':
          isPickup
              ? {
                'store_id': state.currentStoreId ?? 'unknown',
                'store_name':
                    state.items.isNotEmpty
                        ? state.items.first.shopName
                        : 'Unknown Store',
                'pickup_instructions':
                    'Please collect your order from the store counter',
              }
              : null,
      'order_summary': {
        'total_items': state.totalItems,
        'unique_products': state.items.length,
        'subtotal': state.subtotal,
        'delivery_fee': dynamicDeliveryFee,
        'tax_amount': state.taxAmount,
        'total_amount': dynamicTotalAmount,
      },
      'payment_details':
          isCod
              ? null
              : {
                'reference_id': paymentResult?.transactionReference ?? 'N/A',
                'transaction_response': paymentResult?.metadata ?? {},
                'payment_status':
                    paymentResult?.success == true ? 'success' : 'failed',
                'payment_message':
                    paymentResult?.message ?? 'Payment processing',
                'card_type': selectedCard?.cardType ?? 'Unknown',
                'last_four_digits':
                    selectedCard?.getMaskedCardNumber() ?? '****',
                'expiry_date': selectedCard?.getFormattedExpiry() ?? 'MM/YY',
              },
    };
  }
}
