import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:speezu/core/services/urls.dart';
import 'package:speezu/presentation/order_details/bloc/order_details_state.dart';
import 'package:speezu/routes/route_names.dart';
import 'package:speezu/widgets/custom_app_bar.dart';

import '../../core/assets/font_family.dart';
import '../../core/utils/currency_icon.dart';
import '../../core/utils/labels.dart';
import '../../models/order_detail_model.dart';
import '../../widgets/app_cache_image.dart';
import '../../widgets/custom_text_form_field.dart';
import '../../widgets/dialog_boxes/order_detail_dialogs.dart';
import '../../widgets/order_detail_product_tile.dart';
import '../../widgets/order_progress_tracker.dart';
import '../../widgets/order_summary_order_screen_container.dart';
import '../../widgets/shipping_address_order_screen_container.dart';
import '../settings/product_give_rating.dart';
import 'bloc/order_details_bloc.dart';
import 'bloc/order_details_event.dart';
import '../../widgets/order_details_shimmer.dart';

class OrderDetailsScreen extends StatefulWidget {
  OrderDetailsScreen({super.key, required this.orderId});
  final String orderId;

  @override
  State<OrderDetailsScreen> createState() => _OrderDetailsScreenState();
}

class _OrderDetailsScreenState extends State<OrderDetailsScreen> {
  String _getOrderStatusText(int step) {
    switch (step) {
      case 0:
        return 'Order Placed';
      case 1:
        return 'Processing';
      case 2:
        return 'Picked by Rider';
      case 3:
        return 'Out for Delivery';
      case 4:
        return 'Delivered';
      default:
        return 'Order Placed';
    }
  }

  Color _getStatusColor(BuildContext context, int step) {
    switch (step) {
      case 0:
        return Colors.blue;
      case 1:
        return Colors.orange;
      case 2:
        return Colors.cyan;
      case 3:
        return Colors.purple;
      case 4:
        return Colors.green;
      default:
        return Theme.of(context).colorScheme.primary;
    }
  }

  @override
  void initState() {
    context.read<OrderDetailsBloc>().add(FetchOrderDetails(widget.orderId));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<OrderDetailsBloc, OrderDetailsState>(
      listenWhen: (previous, current) =>
          previous.addReviewStatus != current.addReviewStatus,
      listener: (context, state) {
        if (state.addReviewStatus == AddReviewStatus.success) {
          Navigator.pop(context); // Close the review dialog
          // Refresh order details after review submission
          // context.read<OrderDetailsBloc>().add(FetchOrderDetails(widget.orderId));
        }
      },
      child: Scaffold(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        appBar: CustomAppBar(title: Labels.orderDetails),
        body: BlocBuilder<OrderDetailsBloc, OrderDetailsState>(
          builder: (context, state) {
            if (state.status == OrderDetailStatus.loading) {
              return const OrderDetailsShimmer();
            }
            final statusColor = _getStatusColor(
              context,
              state.orderDetailModel?.order?.currentStep ?? 0,
            );
            final orderDetail = state.orderDetailModel?.order;

            return ListView(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              children: [
                // Order Status Card
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        statusColor.withValues(alpha: 0.15),
                        statusColor.withValues(alpha: 0.05),
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: statusColor.withValues(alpha: 0.3),
                      width: 1.5,
                    ),
                  ),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 10,
                                      vertical: 5,
                                    ),
                                    decoration: BoxDecoration(
                                      color: statusColor.withValues(alpha: 0.2),
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: Text(
                                      _getOrderStatusText(
                                        state
                                                .orderDetailModel
                                                ?.order
                                                ?.currentStep ??
                                            0,
                                      ),
                                      style: TextStyle(
                                        fontFamily:
                                            FontFamily.fontsPoppinsSemiBold,
                                        color: statusColor,
                                        fontSize: 12,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 8),
                              Text(
                                '${Labels.orderNumber} ${orderDetail?.id}',
                                style: TextStyle(
                                  fontFamily: FontFamily.fontsPoppinsBold,
                                  color:
                                      Theme.of(context).colorScheme.onSecondary,
                                  fontSize: 20,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Row(
                                children: [
                                  Icon(
                                    Icons.access_time,
                                    size: 14,
                                    color: Theme.of(context)
                                        .colorScheme
                                        .onSecondary
                                        .withValues(alpha: 0.6),
                                  ),
                                  const SizedBox(width: 4),
                                  Text(
                                    '${Labels.placedOn} ${orderDetail?.placedOn}',
                                    style: TextStyle(
                                      fontFamily: FontFamily.fontsPoppinsRegular,
                                      color: Theme.of(context)
                                          .colorScheme
                                          .onSecondary
                                          .withValues(alpha: 0.6),
                                      fontSize: 12,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text(
                                Labels.totalAmount,
                                style: TextStyle(
                                  fontFamily: FontFamily.fontsPoppinsRegular,
                                  color: Theme.of(context).colorScheme.onSecondary
                                      .withValues(alpha: 0.6),
                                  fontSize: 12,
                                ),
                              ),
                              Text(
                                "${CurrencyIcon.currencyIcon} ${orderDetail?.totalAmount}",
                                style: TextStyle(
                                  fontFamily: FontFamily.fontsPoppinsBold,
                                  color: Theme.of(context).colorScheme.primary,
                                  fontSize: 24,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      OrderProgressTracker(
                        isFoodOrder: true,
                        currentStep: orderDetail?.currentStep ?? 0,
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 20),

                // Section Header - Products
                Row(
                  children: [
                    Container(
                      width: 4,
                      height: 20,
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.primary,
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Text(
                      Labels.orderItems,
                      style: TextStyle(
                        fontFamily: FontFamily.fontsPoppinsSemiBold,
                        fontSize: 18,
                        color: Theme.of(context).colorScheme.onSecondary,
                      ),
                    ),
                    const Spacer(),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 5,
                      ),
                      decoration: BoxDecoration(
                        color: Theme.of(
                          context,
                        ).colorScheme.primary.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        '${orderDetail?.products?.length} ${Labels.item}',
                        style: TextStyle(
                          fontFamily: FontFamily.fontsPoppinsMedium,
                          fontSize: 12,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 12),

                if (orderDetail?.products != null && orderDetail!.products!.isNotEmpty)
                  ListView.builder(
                    itemCount: orderDetail.products!.length,
                    physics: const NeverScrollableScrollPhysics(), // so it won’t conflict with parent scroll
                    shrinkWrap: true, // important for embedding in other scrollables
                    itemBuilder: (context, index) {
                      final product = orderDetail.products![index];
                      return GestureDetector(
                        onTap: (){
                          print('Hello ${product.isReviewTaken }');


                        },
                        child: Padding(
                          padding: const EdgeInsets.only(bottom: 12),
                          child: OrderDetailsProductTile(
                            isReviewed: product.isReviewTaken ?? false,
                            onTrackTap: () {
                              // Navigator.pushNamed(
                              //   context,
                              //   RouteNames.productScreen,
                              //   arguments: product.id,
                              // );
                          },
                            shopName: product.shopName ?? '',
                            onReviewTap: () {
                              OrderDetailDialogBoxes.showReviewDialog(
                                state.orderDetailModel?.order?.id ?? 0,
                                context,
                              );
                            },
                            imageUrl: '$imageBaseUrl${product.imageUrl}' ?? '',
                            productName: product.productName ?? '',
                            variationParentName: product.variationParentName,
                            variationParentValue: product.variationChildName,
                            variationChildName: product.variationParentName,
                            variationChildValue: product.variationChildName,
                            price: product.price ?? '0',
                            originalPrice: product.originalPrice ?? '0',
                          ),
                        ),
                      );
                    },
                  )
                else
                  const SizedBox.shrink(),


                const SizedBox(height: 8),

                // Section Header - Shipping
                Row(
                  children: [
                    Container(
                      width: 4,
                      height: 20,
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.primary,
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Text(
                      Labels.deliveryAddress,
                      style: TextStyle(
                        fontFamily: FontFamily.fontsPoppinsSemiBold,
                        fontSize: 18,
                        color: Theme.of(context).colorScheme.onSecondary,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 12),

                /// Shipping address
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.onPrimary,
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(
                      color: Theme.of(
                        context,
                      ).colorScheme.onSecondary.withValues(alpha: 0.1),
                      width: 1,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Theme.of(
                          context,
                        ).colorScheme.onSecondary.withValues(alpha: 0.03),
                        spreadRadius: 1,
                        blurRadius: 10,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: Theme.of(
                                context,
                              ).colorScheme.primary.withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Icon(
                              Icons.location_on,
                              color: Theme.of(context).colorScheme.primary,
                              size: 20,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  orderDetail?.shippingAddress?.title ?? '',
                                  style: TextStyle(
                                    fontFamily: FontFamily.fontsPoppinsSemiBold,
                                    fontSize: 14,
                                    color:
                                        Theme.of(context).colorScheme.onSecondary,
                                  ),
                                ),
                                Text(
                                  orderDetail?.shippingAddress?.customerName ?? '',
                                  style: TextStyle(
                                    fontFamily: FontFamily.fontsPoppinsRegular,
                                    fontSize: 13,
                                    color: Theme.of(context)
                                        .colorScheme
                                        .onSecondary
                                        .withValues(alpha: 0.7),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Theme.of(
                            context,
                          ).colorScheme.onSecondary.withValues(alpha: 0.03),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Icon(
                                  Icons.phone,
                                  size: 14,
                                  color: Theme.of(context).colorScheme.onSecondary
                                      .withValues(alpha: 0.6),
                                ),
                                const SizedBox(width: 6),
                                Text(
                                  orderDetail?.shippingAddress?.primaryPhone ?? '',
                                  style: TextStyle(
                                    fontFamily: FontFamily.fontsPoppinsRegular,
                                    fontSize: 12,
                                    color: Theme.of(context)
                                        .colorScheme
                                        .onSecondary
                                        .withValues(alpha: 0.8),
                                  ),
                                ),
                              ],
                            ),
                            if (orderDetail
                                    ?.shippingAddress
                                    ?.secondaryPhone
                                    ?.isNotEmpty ??
                                false) ...[
                              const SizedBox(height: 6),
                              Row(
                                children: [
                                  Icon(
                                    Icons.phone,
                                    size: 14,
                                    color: Theme.of(context)
                                        .colorScheme
                                        .onSecondary
                                        .withValues(alpha: 0.6),
                                  ),
                                  const SizedBox(width: 6),
                                  Text(
                                    orderDetail?.shippingAddress?.secondaryPhone ??
                                        '',
                                    style: TextStyle(
                                      fontFamily: FontFamily.fontsPoppinsRegular,
                                      fontSize: 12,
                                      color: Theme.of(context)
                                          .colorScheme
                                          .onSecondary
                                          .withValues(alpha: 0.8),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                            const SizedBox(height: 6),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Icon(
                                  Icons.location_city,
                                  size: 14,
                                  color: Theme.of(context).colorScheme.onSecondary
                                      .withValues(alpha: 0.6),
                                ),
                                const SizedBox(width: 6),
                                Expanded(
                                  child: Text(
                                    orderDetail?.shippingAddress?.fullAddress ??
                                        '',
                                    style: TextStyle(
                                      fontFamily: FontFamily.fontsPoppinsRegular,
                                      fontSize: 12,
                                      color: Theme.of(context)
                                          .colorScheme
                                          .onSecondary
                                          .withValues(alpha: 0.8),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 20),

                // Section Header - Summary
                Row(
                  children: [
                    Container(
                      width: 4,
                      height: 20,
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.primary,
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Text(
                      Labels.orderSummary,
                      style: TextStyle(
                        fontFamily: FontFamily.fontsPoppinsSemiBold,
                        fontSize: 18,
                        color: Theme.of(context).colorScheme.onSecondary,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 12),

                /// Order summary
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.onPrimary,
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(
                      color: Theme.of(
                        context,
                      ).colorScheme.onSecondary.withValues(alpha: 0.1),
                      width: 1,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Theme.of(
                          context,
                        ).colorScheme.onSecondary.withValues(alpha: 0.03),
                        spreadRadius: 1,
                        blurRadius: 10,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      _buildSummaryRow(
                        context,
                        '${Labels.itemsTotal} (${orderDetail?.summary?.itemQty} ${Labels.item})',
                        '${CurrencyIcon.currencyIcon} ${orderDetail?.summary?.itemTotal}',
                        false,
                      ),
                      const SizedBox(height: 12),
                      _buildSummaryRow(
                        context,
                        Labels.deliveryFee,
                        '${CurrencyIcon.currencyIcon} ${orderDetail?.summary?.deliveryFee}',
                        false,
                      ),
                      const SizedBox(height: 12),
                      _buildSummaryRow(
                        context,
                        Labels.tax,
                        '${CurrencyIcon.currencyIcon} ${orderDetail?.summary?.tax}',
                        false,
                      ),
                      const SizedBox(height: 16),
                      Container(
                        height: 1,
                        color: Theme.of(
                          context,
                        ).colorScheme.onSecondary.withValues(alpha: 0.1),
                      ),
                      const SizedBox(height: 16),
                      _buildSummaryRow(
                        context,
                        Labels.totalAmount,
                        '${CurrencyIcon.currencyIcon} ${orderDetail?.summary?.total}',
                        true,
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 30),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildSummaryRow(
    BuildContext context,
    String label,
    String value,
    bool isBold,
  ) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            fontFamily:
                isBold
                    ? FontFamily.fontsPoppinsSemiBold
                    : FontFamily.fontsPoppinsRegular,
            fontSize: isBold ? 15 : 13,
            color: Theme.of(
              context,
            ).colorScheme.onSecondary.withValues(alpha: isBold ? 1.0 : 0.7),
          ),
        ),
        Text(
          value,
          style: TextStyle(
            fontFamily:
                isBold
                    ? FontFamily.fontsPoppinsBold
                    : FontFamily.fontsPoppinsMedium,
            fontSize: isBold ? 18 : 14,
            color:
                isBold
                    ? Theme.of(context).colorScheme.primary
                    : Theme.of(context).colorScheme.onSecondary,
          ),
        ),
      ],
    );
  }
}
