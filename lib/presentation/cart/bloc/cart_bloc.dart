import 'package:flutter_bloc/flutter_bloc.dart';
import 'cart_event.dart';
import 'cart_state.dart';
import '../../../models/cart_model.dart';

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
        storeId: event.product.shop.id.toString(), // Real server store ID
      );

      // Check if cart has items from a different store
      if (state.cart.isNotEmpty && 
          state.cart.currentStoreId != newCartItem.storeId) {
        emit(state.copyWith(
          status: CartStatus.error,
          errorMessage: 'STORE_CONFLICT:${newCartItem.storeId}:${state.cart.currentStoreId}',
        ));
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

      emit(state.copyWith(
        status: CartStatus.success,
        cart: updatedCart,
        errorMessage: null,
      ));
    } catch (e) {
      emit(state.copyWith(
        status: CartStatus.error,
        errorMessage: 'Failed to add item to cart: ${e.toString()}',
      ));
    }
  }

  void _onRemoveFromCart(RemoveFromCart event, Emitter<CartState> emit) {
    try {
      final updatedItems = state.cart.items
          .where((item) => item.id != event.cartItemId)
          .toList();

      final updatedCart = state.cart.copyWith(items: updatedItems);

      emit(state.copyWith(
        status: CartStatus.success,
        cart: updatedCart,
        errorMessage: null,
      ));
    } catch (e) {
      emit(state.copyWith(
        status: CartStatus.error,
        errorMessage: 'Failed to remove item from cart: ${e.toString()}',
      ));
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

      final updatedItems = state.cart.items.map((item) {
        if (item.id == event.cartItemId) {
          return item.copyWith(quantity: event.newQuantity);
        }
        return item;
      }).toList();

      final updatedCart = state.cart.copyWith(items: updatedItems);

      emit(state.copyWith(
        status: CartStatus.success,
        cart: updatedCart,
        errorMessage: null,
      ));
    } catch (e) {
      emit(state.copyWith(
        status: CartStatus.error,
        errorMessage: 'Failed to update item quantity: ${e.toString()}',
      ));
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

    add(UpdateCartItemQuantity(
      cartItemId: event.cartItemId,
      newQuantity: item.quantity + 1,
    ));
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
      add(UpdateCartItemQuantity(
        cartItemId: event.cartItemId,
        newQuantity: item.quantity - 1,
      ));
    } else {
      // Remove item if quantity becomes 0
      add(RemoveFromCart(cartItemId: event.cartItemId));
    }
  }

  void _onClearCart(ClearCart event, Emitter<CartState> emit) {
    try {
      final updatedCart = state.cart.copyWith(items: []);

      emit(state.copyWith(
        status: CartStatus.success,
        cart: updatedCart,
        errorMessage: null,
      ));
    } catch (e) {
      emit(state.copyWith(
        status: CartStatus.error,
        errorMessage: 'Failed to clear cart: ${e.toString()}',
      ));
    }
  }

  void _onClearCartForNewStore(ClearCartForNewStore event, Emitter<CartState> emit) {
    try {
      final updatedCart = state.cart.copyWith(items: []);

      emit(state.copyWith(
        status: CartStatus.success,
        cart: updatedCart,
        errorMessage: null,
      ));
    } catch (e) {
      emit(state.copyWith(
        status: CartStatus.error,
        errorMessage: 'Failed to clear cart for new store: ${e.toString()}',
      ));
    }
  }

  void _onUpdateDeliveryFee(UpdateDeliveryFee event, Emitter<CartState> emit) {
    try {
      final updatedCart = state.cart.copyWith(deliveryFee: event.deliveryFee);

      emit(state.copyWith(
        status: CartStatus.success,
        cart: updatedCart,
        errorMessage: null,
      ));
    } catch (e) {
      emit(state.copyWith(
        status: CartStatus.error,
        errorMessage: 'Failed to update delivery fee: ${e.toString()}',
      ));
    }
  }

  void _onUpdateTaxRate(UpdateTaxRate event, Emitter<CartState> emit) {
    try {
      final updatedCart = state.cart.copyWith(taxRate: event.taxRate);

      emit(state.copyWith(
        status: CartStatus.success,
        cart: updatedCart,
        errorMessage: null,
      ));
    } catch (e) {
      emit(state.copyWith(
        status: CartStatus.error,
        errorMessage: 'Failed to update tax rate: ${e.toString()}',
      ));
    }
  }
}
