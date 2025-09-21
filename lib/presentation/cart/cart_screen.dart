import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:speezu/core/assets/font_family.dart';
import 'package:speezu/core/utils/currency_icon.dart';
import 'package:speezu/presentation/cart/bloc/cart_bloc.dart';
import 'package:speezu/presentation/cart/bloc/cart_event.dart';
import 'package:speezu/presentation/cart/bloc/cart_state.dart';
import 'package:speezu/models/cart_model.dart';
import 'package:speezu/routes/route_names.dart';
import 'package:speezu/widgets/custom_app_bar.dart';

import '../../core/utils/labels.dart';
import '../../widgets/cart_list_tile.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: Labels.yourCart),
      body: BlocBuilder<CartBloc, CartState>(
        builder: (context, state) {
          if (state.isEmpty) {
            return _buildEmptyCart(context);
          }

          return Stack(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    SizedBox(height: 10),
                    Expanded(
                      child: ListView.builder(
                        itemCount: state.items.length,
                        itemBuilder: (context, index) {
                          final cartItem = state.items[index];
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 10.0),
                            child: CartListTile(
                              imageUrl: cartItem.imageUrl,
                              productName: cartItem.name,
                              variationParentName: cartItem.variationParentName,
                              variationParentValue: cartItem.variationParentValue,
                              variationChildName: cartItem.variationChildName,
                              variationChildValue: cartItem.variationChildValue,
                              price: cartItem.price.toStringAsFixed(2),
                              originalPrice: cartItem.originalPrice.toStringAsFixed(2),
                              quantity: cartItem.quantity,
                              onAdd: () {
                                context.read<CartBloc>().add(
                                  IncrementCartItemQuantity(cartItemId: cartItem.id),
                                );
                              },
                              onRemove: () {
                                context.read<CartBloc>().add(
                                  DecrementCartItemQuantity(cartItemId: cartItem.id),
                                );
                              },
                              onDelete: () {
                                _showDeleteConfirmationDialog(context, cartItem);
                              },
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
          Align(
            alignment: Alignment.bottomCenter,
            child: SafeArea(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 15.0,
                      vertical: 8.0,
                    ),
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.onPrimary,

                      border: Border.all(
                        color: Theme.of(
                          context,
                        ).colorScheme.primary.withValues(alpha: .3),
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.1),
                          spreadRadius: 1,
                          blurRadius: 4,
                          offset: const Offset(2, 0),
                        ),
                      ],
                    ),
                    child: TextFormField(
                      style: TextStyle(
                        fontFamily: FontFamily.fontsPoppinsRegular,
                        color: Theme.of(context).colorScheme.onSecondary,
                        fontSize: 14,
                      ),

                      decoration: InputDecoration(
                        suffixIcon: Icon(
                          Icons.confirmation_num,
                          size: 20,
                          color: Colors.grey,
                        ),

                        hintText: Labels.haveCouponCode,
                        hintStyle: TextStyle(
                          fontFamily: FontFamily.fontsPoppinsRegular,
                          color: Theme.of(
                            context,
                          ).colorScheme.onSecondary.withValues(alpha: 0.5),
                          fontSize: 14,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30),
                          borderSide: BorderSide(
                            color: Theme.of(
                              context,
                            ).colorScheme.primary.withValues(alpha: .3),
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30),
                          borderSide: BorderSide(
                            color: Theme.of(context).colorScheme.primary,
                          ),
                        ),
                        contentPadding: EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 10,
                        ),
                        isDense: true,
                      ),
                    ),
                  ),
                  SizedBox(height: 10),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 15.0,
                      vertical: 8.0,
                    ),
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.onPrimary,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(30),
                        topRight: Radius.circular(30),
                      ),
                      border: Border.all(
                        color: Theme.of(
                          context,
                        ).colorScheme.primary.withValues(alpha: .3),
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.1),
                          spreadRadius: 1,
                          blurRadius: 4,
                          offset: const Offset(2, 0),
                        ),
                      ],
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: 10),
                        Text(
                          Labels.summary,
                          style: TextStyle(
                            fontFamily: FontFamily.fontsPoppinsSemiBold,
                            color: Theme.of(context).colorScheme.onSecondary,
                            fontSize: 16,
                          ),
                        ),
                        if (state.items.isNotEmpty) ...[
                          SizedBox(height: 5),
                          Text(
                            'From: ${state.items.first.shopName}',
                            style: TextStyle(
                              fontFamily: FontFamily.fontsPoppinsRegular,
                              color: Theme.of(context).colorScheme.onSecondary.withValues(alpha: 0.7),
                              fontSize: 12,
                            ),
                          ),
                        ],
                        SizedBox(height: 10),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              '${Labels.itemsTotal} ( ${state.totalItems} ${Labels.item}${state.totalItems > 1 ? 's' : ''} )',
                              style: TextStyle(
                                fontFamily: FontFamily.fontsPoppinsRegular,
                                color:
                                    Theme.of(context).colorScheme.onSecondary,
                                fontSize: 14,
                              ),
                            ),
                            Text(
                              '${CurrencyIcon.currencyIcon}${state.subtotal.toStringAsFixed(2)}',
                              style: TextStyle(
                                fontFamily: FontFamily.fontsPoppinsRegular,
                                color:
                                    Theme.of(context).colorScheme.onSecondary,
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              Labels.deliveryFee,
                              style: TextStyle(
                                fontFamily: FontFamily.fontsPoppinsRegular,
                                color:
                                    Theme.of(context).colorScheme.onSecondary,
                                fontSize: 14,
                              ),
                            ),
                            Text(
                              '${CurrencyIcon.currencyIcon}${state.deliveryFee.toStringAsFixed(2)}',
                              style: TextStyle(
                                fontFamily: FontFamily.fontsPoppinsRegular,
                                color:
                                    Theme.of(context).colorScheme.onSecondary,
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              Labels.tax,
                              style: TextStyle(
                                fontFamily: FontFamily.fontsPoppinsRegular,
                                color:
                                    Theme.of(context).colorScheme.onSecondary,
                                fontSize: 14,
                              ),
                            ),
                            Text(
                              '${CurrencyIcon.currencyIcon}${state.taxAmount.toStringAsFixed(2)}',
                              style: TextStyle(
                                fontFamily: FontFamily.fontsPoppinsRegular,
                                color:
                                    Theme.of(context).colorScheme.onSecondary,
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              Labels.grandTotal,
                              style: TextStyle(
                                fontFamily: FontFamily.fontsPoppinsSemiBold,
                                color:
                                    Theme.of(context).colorScheme.onSecondary,
                                fontSize: 16,
                              ),
                            ),
                            Text(
                              '${CurrencyIcon.currencyIcon}${state.totalAmount.toStringAsFixed(2)}',
                              style: TextStyle(
                                fontFamily: FontFamily.fontsPoppinsSemiBold,
                                color:
                                    Theme.of(context).colorScheme.onSecondary,
                                fontSize: 16,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 10),
                        Center(
                          child: ElevatedButton(
                            style: ButtonStyle(
                              backgroundColor: MaterialStateProperty.all(
                                Theme.of(context).colorScheme.primary,
                              ),
                              minimumSize: MaterialStateProperty.all(
                                Size(300, 50),
                              ),
                              shape: MaterialStateProperty.all(
                                RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(50),
                                ),
                              ),
                            ),
                            onPressed: () {
                              Navigator.pushNamed(
                                context,
                                RouteNames.checkOutScreen,
                              );
                            },
                            child: Text(
                              Labels.checkout,
                              style: TextStyle(
                                fontFamily: FontFamily.fontsPoppinsSemiBold,
                                color: Colors.white,
                                fontSize: 15,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          ],
        );
        },
      ),
    );
  }

  void _showDeleteConfirmationDialog(BuildContext context, CartItem cartItem) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            'Remove Item',
            style: TextStyle(
              fontFamily: FontFamily.fontsPoppinsSemiBold,
              fontSize: 18,
            ),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Are you sure you want to remove this item from your cart?',
                style: TextStyle(
                  fontFamily: FontFamily.fontsPoppinsRegular,
                  fontSize: 14,
                ),
              ),
              SizedBox(height: 12),
              Container(
                padding: EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.grey.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.grey.withValues(alpha: 0.3)),
                ),
                child: Row(
                  children: [
                    // Product image
                    Container(
                      width: 50,
                      height: 50,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(6),
                        image: DecorationImage(
                          image: NetworkImage(cartItem.imageUrl),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    SizedBox(width: 12),
                    // Product details
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            cartItem.name,
                            style: TextStyle(
                              fontFamily: FontFamily.fontsPoppinsSemiBold,
                              fontSize: 12,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          if (cartItem.variationParentValue != null) ...[
                            SizedBox(height: 2),
                            Text(
                              '${cartItem.variationParentName}: ${cartItem.variationParentValue}',
                              style: TextStyle(
                                fontFamily: FontFamily.fontsPoppinsRegular,
                                fontSize: 10,
                                color: Colors.grey[600],
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                          if (cartItem.variationChildValue != null) ...[
                            Text(
                              '${cartItem.variationChildName}: ${cartItem.variationChildValue}',
                              style: TextStyle(
                                fontFamily: FontFamily.fontsPoppinsRegular,
                                fontSize: 10,
                                color: Colors.grey[600],
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                          SizedBox(height: 4),
                          Text(
                            'Qty: ${cartItem.quantity} × ${CurrencyIcon.currencyIcon}${cartItem.price.toStringAsFixed(2)}',
                            style: TextStyle(
                              fontFamily: FontFamily.fontsPoppinsRegular,
                              fontSize: 11,
                              color: Theme.of(context).colorScheme.primary,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text(
                'Cancel',
                style: TextStyle(
                  fontFamily: FontFamily.fontsPoppinsRegular,
                  color: Theme.of(context).colorScheme.onSecondary,
                ),
              ),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                context.read<CartBloc>().add(
                  RemoveFromCart(cartItemId: cartItem.id),
                );
              },
              child: Text(
                'Remove',
                style: TextStyle(
                  fontFamily: FontFamily.fontsPoppinsSemiBold,
                  color: Colors.red,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildEmptyCart(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.shopping_cart_outlined,
            size: 100,
            color: Theme.of(context).colorScheme.onSecondary.withValues(alpha: 0.3),
          ),
          SizedBox(height: 20),
          Text(
            'Your cart is empty',
            style: TextStyle(
              fontFamily: FontFamily.fontsPoppinsSemiBold,
              fontSize: 20,
              color: Theme.of(context).colorScheme.onSecondary,
            ),
          ),
          SizedBox(height: 10),
          Text(
            'Add some products to get started',
            style: TextStyle(
              fontFamily: FontFamily.fontsPoppinsRegular,
              fontSize: 14,
              color: Theme.of(context).colorScheme.onSecondary.withValues(alpha: 0.6),
            ),
          ),
          SizedBox(height: 30),
          ElevatedButton(
            style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all(
                Theme.of(context).colorScheme.primary,
              ),
              padding: MaterialStateProperty.all(
                EdgeInsets.symmetric(horizontal: 30, vertical: 15),
              ),
              shape: MaterialStateProperty.all(
                RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(25),
                ),
              ),
            ),
            onPressed: () {
              Navigator.pop(context);
            },
            child: Text(
              'Continue Shopping',
              style: TextStyle(
                fontFamily: FontFamily.fontsPoppinsSemiBold,
                color: Colors.white,
                fontSize: 16,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
