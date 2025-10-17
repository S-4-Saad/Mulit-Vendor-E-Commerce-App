import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
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

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  @override
  @override
  void initState() {
    context.read<CartBloc>().add(ResetCouponStatus());
    super.initState();
  }

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
                              variationParentValue:
                                  cartItem.variationParentValue,
                              variationChildName: cartItem.variationChildName,
                              variationChildValue: cartItem.variationChildValue,
                              price: cartItem.price.toStringAsFixed(2),
                              originalPrice: cartItem.originalPrice
                                  .toStringAsFixed(2),
                              quantity: cartItem.quantity,
                              onAdd: () {
                                context.read<CartBloc>().add(
                                  IncrementCartItemQuantity(
                                    cartItemId: cartItem.id,
                                  ),
                                );
                              },
                              onRemove: () {
                                context.read<CartBloc>().add(
                                  DecrementCartItemQuantity(
                                    cartItemId: cartItem.id,
                                  ),
                                );
                              },
                              onDelete: () {
                                _showDeleteConfirmationDialog(
                                  context,
                                  cartItem,
                                );
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
                      BlocBuilder<CartBloc, CartState>(
                        builder: (context, state) {
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Premium Coupon Input Container
                              Container(
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(16),
                                  border: Border.all(
                                    color:
                                        state.couponStatus ==
                                                CouponStatus.success
                                            ? Colors.green.shade300
                                            : state.couponStatus ==
                                                CouponStatus.wrong
                                            ? Colors.red.shade300
                                            : state.couponStatus ==
                                                CouponStatus.notApplicable
                                            ? Colors.orange.shade300
                                            : Colors.grey.shade300,
                                    width: 2,
                                  ),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.05),
                                      blurRadius: 10,
                                      offset: const Offset(0, 4),
                                    ),
                                  ],
                                ),
                                child: Row(
                                  children: [
                                    // Icon Section
                                    Container(
                                      padding: const EdgeInsets.all(14),
                                      decoration: BoxDecoration(
                                        color:
                                            state.couponStatus ==
                                                    CouponStatus.success
                                                ? Colors.green.shade50
                                                : state.couponStatus ==
                                                    CouponStatus.wrong
                                                ? Colors.red.shade50
                                                : state.couponStatus ==
                                                    CouponStatus.notApplicable
                                                ? Colors.orange.shade50
                                                : Colors.grey.shade50,
                                        borderRadius: const BorderRadius.only(
                                          topLeft: Radius.circular(14),
                                          bottomLeft: Radius.circular(14),
                                        ),
                                      ),
                                      child: Icon(
                                        Icons.local_offer_rounded,
                                        size: 24,
                                        color:
                                            state.couponStatus ==
                                                    CouponStatus.success
                                                ? Colors.green.shade600
                                                : state.couponStatus ==
                                                    CouponStatus.wrong
                                                ? Colors.red.shade600
                                                : state.couponStatus ==
                                                    CouponStatus.notApplicable
                                                ? Colors.orange.shade600
                                                : Colors.grey.shade600,
                                      ),
                                    ),

                                    // Text Field
                                    Expanded(
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 12,
                                        ),
                                        child: TextFormField(
                                          onChanged: (value) {
                                            if (value.trim().length >= 5) {
                                              context.read<CartBloc>().add(
                                                CouponCodeChanged(value.trim()),
                                              );
                                            }
                                          },
                                          enabled:
                                              state.couponStatus !=
                                              CouponStatus.success,
                                          style: TextStyle(
                                            fontFamily:
                                                FontFamily.fontsPoppinsRegular,
                                            color:
                                                Theme.of(
                                                  context,
                                                ).colorScheme.onSecondary,
                                            fontSize: 15,
                                            fontWeight: FontWeight.w600,
                                          ),
                                          decoration: InputDecoration(
                                            hintText: Labels.haveCouponCode,
                                            hintStyle: TextStyle(
                                              fontFamily:
                                                  FontFamily
                                                      .fontsPoppinsRegular,
                                              color: Theme.of(context)
                                                  .colorScheme
                                                  .onSecondary
                                                  .withOpacity(0.4),
                                              fontSize: 14,
                                              fontWeight: FontWeight.w400,
                                            ),
                                            border: InputBorder.none,
                                            focusedBorder: InputBorder.none,
                                            enabledBorder: InputBorder.none,
                                            contentPadding:
                                                const EdgeInsets.symmetric(
                                                  vertical: 14,
                                                ),
                                            isDense: true,
                                          ),
                                        ),
                                      ),
                                    ),

                                    // Status Icon/Loading
                                    Padding(
                                      padding: const EdgeInsets.only(right: 14),
                                      child: _buildStatusWidget(context, state),
                                    ),
                                  ],
                                ),
                              ),

                              // Status Message (appears below)
                              if (state.couponStatus == CouponStatus.success ||
                                  state.couponStatus == CouponStatus.wrong ||
                                  state.couponStatus ==
                                      CouponStatus.notApplicable)
                                AnimatedContainer(
                                  duration: const Duration(milliseconds: 300),
                                  margin: const EdgeInsets.only(top: 8),
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 12,
                                    vertical: 10,
                                  ),
                                  decoration: BoxDecoration(
                                    color:
                                        state.couponStatus ==
                                                CouponStatus.success
                                            ? Colors.green.shade50
                                            : state.couponStatus ==
                                                CouponStatus.wrong
                                            ? Colors.red.shade50
                                            : Colors.orange.shade50,
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Row(
                                    children: [
                                      Icon(
                                        state.couponStatus ==
                                                CouponStatus.success
                                            ? Icons.check_circle_rounded
                                            : state.couponStatus ==
                                                CouponStatus.wrong
                                            ? Icons.error_outline_rounded
                                            : Icons.info_outline_rounded,
                                        size: 18,
                                        color:
                                            state.couponStatus ==
                                                    CouponStatus.success
                                                ? Colors.green.shade700
                                                : state.couponStatus ==
                                                    CouponStatus.wrong
                                                ? Colors.red.shade700
                                                : Colors.orange.shade700,
                                      ),
                                      const SizedBox(width: 8),
                                      Expanded(
                                        child: Text(
                                          state.couponStatus ==
                                                  CouponStatus.success
                                              ? Labels.couponAppliedSuccessfully
                                              : state.couponStatus ==
                                                  CouponStatus.wrong
                                              ? Labels.invalidCouponCodeTryAgain
                                              : '${Labels.minimumOrderAmount}: ${state.couponModel?.data?.minOrderAmount ?? ''} ${CurrencyIcon.currencyIcon}',
                                          style: TextStyle(
                                            fontFamily:
                                                FontFamily.fontsPoppinsRegular,
                                            fontSize: 12,
                                            color:
                                                state.couponStatus ==
                                                        CouponStatus.success
                                                    ? Colors.green.shade800
                                                    : state.couponStatus ==
                                                        CouponStatus.wrong
                                                    ? Colors.red.shade800
                                                    : Colors.orange.shade800,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                            ],
                          );
                        },
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
                                color:
                                    Theme.of(context).colorScheme.onSecondary,
                                fontSize: 16,
                              ),
                            ),
                            if (state.items.isNotEmpty) ...[
                              SizedBox(height: 5),
                              Text(
                                '${Labels.from}: ${state.items.first.shopName}',
                                style: TextStyle(
                                  fontFamily: FontFamily.fontsPoppinsRegular,
                                  color: Theme.of(context)
                                      .colorScheme
                                      .onSecondary
                                      .withValues(alpha: 0.7),
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
                                        Theme.of(
                                          context,
                                        ).colorScheme.onSecondary,
                                    fontSize: 14,
                                  ),
                                ),
                                Text(
                                  '${CurrencyIcon.currencyIcon}${state.subtotal.toStringAsFixed(2)}',
                                  style: TextStyle(
                                    fontFamily: FontFamily.fontsPoppinsRegular,
                                    color:
                                        Theme.of(
                                          context,
                                        ).colorScheme.onSecondary,
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
                                        Theme.of(
                                          context,
                                        ).colorScheme.onSecondary,
                                    fontSize: 14,
                                  ),
                                ),
                                Text(
                                  '${CurrencyIcon.currencyIcon}${state.deliveryFee.toStringAsFixed(2)}',
                                  style: TextStyle(
                                    fontFamily: FontFamily.fontsPoppinsRegular,
                                    color:
                                        Theme.of(
                                          context,
                                        ).colorScheme.onSecondary,
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
                                        Theme.of(
                                          context,
                                        ).colorScheme.onSecondary,
                                    fontSize: 14,
                                  ),
                                ),
                                Text(
                                  '${CurrencyIcon.currencyIcon}${state.taxAmount.toStringAsFixed(2)}',
                                  style: TextStyle(
                                    fontFamily: FontFamily.fontsPoppinsRegular,
                                    color:
                                        Theme.of(
                                          context,
                                        ).colorScheme.onSecondary,
                                    fontSize: 14,
                                  ),
                                ),
                              ],
                            ),
                            if (state.couponStatus == CouponStatus.success)
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    Labels.couponDiscount,
                                    style: TextStyle(
                                      fontFamily:
                                          FontFamily.fontsPoppinsRegular,
                                      color:
                                          Theme.of(
                                            context,
                                          ).colorScheme.onSecondary,
                                      fontSize: 14,
                                    ),
                                  ),
                                  Text(
                                    '-${CurrencyIcon.currencyIcon}${state.couponModel?.data?.maxDiscount?.toStringAsFixed(2)}',
                                    style: TextStyle(
                                      fontFamily:
                                          FontFamily.fontsPoppinsRegular,
                                      color: Colors.blue,
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
                                        Theme.of(
                                          context,
                                        ).colorScheme.onSecondary,
                                    fontSize: 16,
                                  ),
                                ),
                                Text(
                                  '${CurrencyIcon.currencyIcon}${state.totalAmount.toStringAsFixed(2)}',
                                  style: TextStyle(
                                    fontFamily: FontFamily.fontsPoppinsSemiBold,
                                    color:
                                        Theme.of(
                                          context,
                                        ).colorScheme.onSecondary,
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
          backgroundColor: Theme.of(context).colorScheme.onPrimary,
          title: Text(
            Labels.removeItem,
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
                Labels.areYouSureYouWantToRemoveThisItemFromTheCart,
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
                Labels.cancel,
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
                Labels.remove,
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
      child: Padding(
        padding: const EdgeInsets.all(40.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Animated cart icon with premium gradient container
            TweenAnimationBuilder<double>(
              duration: const Duration(milliseconds: 1500),
              tween: Tween(begin: 0.0, end: 1.0),
              curve: Curves.elasticOut,
              builder: (context, value, child) {
                return Transform.scale(
                  scale: 0.5 + (value * 0.5),
                  child: Opacity(
                    opacity: value.clamp(0.0, 1.0), // ✅ FIX HERE
                    child: child,
                  ),
                );
              },
              child: Container(
                padding: const EdgeInsets.all(30),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: LinearGradient(
                    colors: [
                      Theme.of(context).colorScheme.primary.withOpacity(0.2),
                      Theme.of(context).colorScheme.primary.withOpacity(0.1),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Theme.of(
                        context,
                      ).colorScheme.primary.withOpacity(0.2),
                      blurRadius: 30,
                      spreadRadius: 5,
                    ),
                  ],
                ),
                child: Icon(
                  Icons.shopping_cart_outlined,
                  size: 90,
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
            ),

            const SizedBox(height: 32),

            // Main title with fade animation
            TweenAnimationBuilder<double>(
              duration: const Duration(milliseconds: 800),
              tween: Tween(begin: 0.0, end: 1.0),
              curve: Curves.easeOut,
              builder: (context, value, child) {
                return Opacity(
                  opacity: value,
                  child: Transform.translate(
                    offset: Offset(0, 20 * (1 - value)),
                    child: child,
                  ),
                );
              },
              child: Text(
                Labels.yourCartIsEmpty,
                style: TextStyle(
                  fontFamily: FontFamily.fontsPoppinsSemiBold,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).colorScheme.onSecondary,
                  letterSpacing: 0.5,
                ),
              ),
            ),
            const SizedBox(height: 12),

            // Description
            TweenAnimationBuilder<double>(
              duration: const Duration(milliseconds: 1000),
              tween: Tween(begin: 0.0, end: 1.0),
              curve: Curves.easeOut,
              builder: (context, value, child) {
                return Opacity(opacity: value, child: child);
              },
              child: Text(
                Labels.addSomeProductsInCart,
                style: TextStyle(
                  fontFamily: FontFamily.fontsPoppinsRegular,
                  fontSize: 15,
                  height: 1.6,
                  color: Theme.of(
                    context,
                  ).colorScheme.onSecondary.withOpacity(0.6),
                ),
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: 40),

            // Premium button with gradient and shadow
            TweenAnimationBuilder<double>(
              duration: const Duration(milliseconds: 1200),
              tween: Tween(begin: 0.0, end: 1.0),
              curve: Curves.easeOut,
              builder: (context, value, child) {
                return Opacity(
                  opacity: value,
                  child: Transform.translate(
                    offset: Offset(0, 20 * (1 - value)),
                    child: child,
                  ),
                );
              },
              child: ElevatedButton.icon(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: const Icon(
                  Icons.shopping_bag_outlined,
                  color: Colors.white,
                  size: 22,
                ),
                label: Text(
                  Labels.continueShopping,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 0.5,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 40,
                    vertical: 18,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  elevation: 8,
                  backgroundColor: Theme.of(context).colorScheme.primary,
                  shadowColor: Theme.of(
                    context,
                  ).colorScheme.primary.withOpacity(0.4),
                ).copyWith(
                  backgroundColor: WidgetStateProperty.resolveWith<Color>((
                    states,
                  ) {
                    if (states.contains(WidgetState.pressed)) {
                      return Theme.of(
                        context,
                      ).colorScheme.primary.withOpacity(0.9);
                    }
                    return Theme.of(context).colorScheme.primary;
                  }),
                ),
              ),
            ),
            const SizedBox(height: 30),

            // Decorative animated dots
            TweenAnimationBuilder<double>(
              duration: const Duration(milliseconds: 1400),
              tween: Tween(begin: 0.0, end: 1.0),
              curve: Curves.easeOut,
              builder: (context, value, child) {
                return Opacity(opacity: value, child: child);
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(3, (index) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4),
                    child: Container(
                      width: 8,
                      height: 8,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Theme.of(
                          context,
                        ).colorScheme.primary.withOpacity(0.3),
                      ),
                    ),
                  );
                }),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusWidget(BuildContext context, CartState state) {
    if (state.couponLoading == CouponLoading.loading) {
      return SizedBox(
        width: 22,
        height: 22,
        child: CircularProgressIndicator(
          strokeWidth: 2.5,
          valueColor: AlwaysStoppedAnimation<Color>(
            Theme.of(context).colorScheme.primary,
          ),
        ),
      );
    }

    if (state.couponLoading == CouponLoading.success) {
      return Icon(
        state.couponStatus == CouponStatus.success
            ? Icons.check_circle
            : state.couponStatus == CouponStatus.wrong
            ? Icons.cancel
            : Icons.info,
        size: 24,
        color:
            state.couponStatus == CouponStatus.success
                ? Colors.green.shade600
                : state.couponStatus == CouponStatus.wrong
                ? Colors.red.shade600
                : Colors.orange.shade600,
      );
    }

    return const SizedBox.shrink();
  }
}
