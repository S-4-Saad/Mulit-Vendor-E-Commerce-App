import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:speezu/core/services/urls.dart';
import 'package:speezu/presentation/order_details/bloc/order_details_state.dart';
import 'package:speezu/routes/route_names.dart';
import 'package:speezu/widgets/custom_app_bar.dart';
import '../../core/assets/font_family.dart';
import '../../core/utils/currency_icon.dart';
import '../../core/utils/labels.dart';
import '../../models/order_detail_model.dart';
import '../../widgets/app_cache_image.dart';
import '../../widgets/dialog_boxes/order_detail_dialogs.dart';
import '../../widgets/order_progress_tracker.dart';
import 'bloc/order_details_bloc.dart';
import 'bloc/order_details_event.dart';
import '../../widgets/order_details_shimmer.dart';

class OrderDetailsScreen extends StatefulWidget {
  OrderDetailsScreen({
    super.key,
    required this.orderId,
    required this.orderStatus,
  });
  final String orderId;
  final String orderStatus;

  @override
  State<OrderDetailsScreen> createState() => _OrderDetailsScreenState();
}

class _OrderDetailsScreenState extends State<OrderDetailsScreen> {
  String _getOrderStatusText(
    int step, {
    bool isPickupOrder = false,
    bool isCancelled = false,
  }) {
    // Handle cancelled orders first
    if (isCancelled) {
      return 'Cancelled';
    }

    if (isPickupOrder) {
      // Simplified flow for pickup orders: Placed → Accepted → Delivered
      switch (step) {
        case 0:
          return 'Order Placed';
        case 1:
          return 'Accepted';
        case 2:
        case 3:
          return 'Ready for Pickup';
        case 4:
          return 'Successfully Picked Up';
        default:
          return 'Order Placed';
      }
    } else {
      // Full delivery flow
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
  }

  Color _getStatusColor(
    BuildContext context,
    int step, {
    bool isCancelled = false,
  }) {
    // Handle cancelled orders first
    if (isCancelled) {
      return Colors.red.shade700;
    }

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
      listenWhen:
          (previous, current) =>
              previous.addReviewStatus != current.addReviewStatus,
      listener: (context, state) {
        if (state.addReviewStatus == AddReviewStatus.success) {
          Navigator.pop(context);
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

            return LayoutBuilder(
              builder: (context, constraints) {
                // Define breakpoints
                final screenWidth = MediaQuery.of(context).size.width;
                final bool isMobile = screenWidth < 600;
                final bool isTablet = screenWidth >= 600 && screenWidth < 1024;
                final bool isLargeTablet = screenWidth >= 1024;

                // Responsive values
                final double horizontalPadding =
                    isMobile ? 16 : (isTablet ? 24 : 32);
                final double verticalPadding =
                    isMobile ? 12 : (isTablet ? 16 : 20);
                final double cardSpacing = isMobile ? 16 : (isTablet ? 20 : 24);
                final double maxWidth = isLargeTablet ? 1400 : double.infinity;
                final double borderRadius =
                    isMobile ? 16 : (isTablet ? 18 : 20);

                final orderDetail = state.orderDetailModel?.order;

                // Check if order is cancelled
                final bool isCancelled =
                    widget.orderStatus.toLowerCase() == 'cancelled' ||
                    widget.orderStatus.toLowerCase() == 'rejected';

                final statusColor = _getStatusColor(
                  context,
                  state.orderDetailModel?.order?.currentStep ?? 0,
                  isCancelled: isCancelled,
                );

                return Center(
                  child: Container(
                    constraints: BoxConstraints(maxWidth: maxWidth),
                    child: ListView(
                      padding: EdgeInsets.symmetric(
                        horizontal: horizontalPadding,
                        vertical: verticalPadding,
                      ),
                      children: [
                        // Order Status Card - Enhanced
                        _buildOrderStatusCard(
                          context,
                          state,
                          orderDetail,
                          statusColor,
                          borderRadius,
                          isMobile,
                          isTablet,
                          isLargeTablet,
                          isCancelled,
                        ),

                        SizedBox(height: cardSpacing),

                        // Cancelled Banner - Show for cancelled orders
                        if (isCancelled) ...[
                          _buildCancelledBanner(
                            context,
                            borderRadius,
                            isMobile,
                            isTablet,
                            isLargeTablet,
                          ),
                          SizedBox(height: cardSpacing),
                        ],

                        // Review Section - Show if order is delivered, not cancelled, and not reviewed
                        if (widget.orderStatus.toLowerCase() == 'delivered' &&
                            !(state.orderDetailModel?.order?.isReviewTaken ??
                                true)) ...[
                          _buildReviewSection(
                            context,
                            state,
                            borderRadius,
                            isMobile,
                            isTablet,
                            isLargeTablet,
                          ),
                          SizedBox(height: cardSpacing),
                        ],

                        // Two-column layout for large tablets
                        if (isLargeTablet) ...[
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Left Column - Products and Summary
                              Expanded(
                                flex: 3,
                                child: Column(
                                  children: [
                                    _buildProductsSection(
                                      context,
                                      orderDetail,
                                      state,
                                      borderRadius,
                                      isMobile,
                                      isTablet,
                                      isLargeTablet,
                                    ),
                                    SizedBox(height: cardSpacing),
                                    _buildOrderSummarySection(
                                      context,
                                      orderDetail,
                                      borderRadius,
                                      isMobile,
                                      isTablet,
                                      isLargeTablet,
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(width: cardSpacing),
                              // Right Column - Shipping Address or Pickup Location
                              Expanded(
                                flex: 2,
                                child:
                                    (orderDetail?.shippingAddress?.title !=
                                                null &&
                                            orderDetail
                                                    ?.shippingAddress
                                                    ?.customerName !=
                                                null &&
                                            orderDetail
                                                    ?.shippingAddress
                                                    ?.fullAddress !=
                                                null)
                                        ? _buildShippingSection(
                                          context,
                                          orderDetail,
                                          borderRadius,
                                          isMobile,
                                          isTablet,
                                          isLargeTablet,
                                        )
                                        : _buildPickupSection(
                                          context,
                                          orderDetail,
                                          borderRadius,
                                          isMobile,
                                          isTablet,
                                          isLargeTablet,
                                        ),
                              ),
                            ],
                          ),
                        ] else ...[
                          // Stacked layout for mobile and tablet
                          _buildProductsSection(
                            context,
                            orderDetail,
                            state,
                            borderRadius,
                            isMobile,
                            isTablet,
                            isLargeTablet,
                          ),
                          SizedBox(height: cardSpacing),
                          // Show shipping or pickup section based on order type
                          (orderDetail?.shippingAddress?.title != null &&
                                  orderDetail?.shippingAddress?.customerName !=
                                      null &&
                                  orderDetail?.shippingAddress?.fullAddress !=
                                      null)
                              ? _buildShippingSection(
                                context,
                                orderDetail,
                                borderRadius,
                                isMobile,
                                isTablet,
                                isLargeTablet,
                              )
                              : _buildPickupSection(
                                context,
                                orderDetail,
                                borderRadius,
                                isMobile,
                                isTablet,
                                isLargeTablet,
                              ),
                          SizedBox(height: cardSpacing),
                          _buildOrderSummarySection(
                            context,
                            orderDetail,
                            borderRadius,
                            isMobile,
                            isTablet,
                            isLargeTablet,
                          ),
                        ],

                        SizedBox(height: cardSpacing * 1.5),
                      ],
                    ),
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }

  Widget _buildOrderStatusCard(
    BuildContext context,
    OrderDetailsState state,
    dynamic orderDetail,
    Color statusColor,
    double borderRadius,
    bool isMobile,
    bool isTablet,
    bool isLargeTablet,
    bool isCancelled,
  ) {
    final double padding = isMobile ? 20 : (isTablet ? 24 : 28);
    final double statusFontSize = isMobile ? 12 : (isTablet ? 13 : 14);
    final double orderIdFontSize = isMobile ? 18 : (isTablet ? 22 : 24);
    final double amountFontSize = isMobile ? 22 : (isTablet ? 26 : 28);

    return Container(
      padding: EdgeInsets.all(padding),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            statusColor.withValues(alpha: 0.15),
            statusColor.withValues(alpha: 0.05),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(borderRadius),
        border: Border.all(
          color: statusColor.withValues(alpha: 0.3),
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: statusColor.withValues(alpha: 0.15),
            blurRadius: 20,
            offset: const Offset(0, 8),
            spreadRadius: 0,
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: isMobile ? 10 : 12,
                        vertical: isMobile ? 5 : 6,
                      ),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            statusColor.withValues(alpha: 0.1),
                            statusColor.withValues(alpha: 0.05),
                          ],
                        ),
                        borderRadius: BorderRadius.circular(10),
                        boxShadow: [
                          BoxShadow(
                            color: statusColor.withValues(alpha: 0.2),
                            blurRadius: 8,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.circle, size: 8, color: statusColor),
                          const SizedBox(width: 6),
                          Text(
                            _getOrderStatusText(
                              state.orderDetailModel?.order?.currentStep ?? 0,
                              isPickupOrder:
                                  (orderDetail?.shippingAddress?.title ==
                                          null &&
                                      orderDetail
                                              ?.shippingAddress
                                              ?.customerName ==
                                          null &&
                                      orderDetail
                                              ?.shippingAddress
                                              ?.fullAddress ==
                                          null),
                              isCancelled: isCancelled,
                            ),
                            style: TextStyle(
                              fontFamily: FontFamily.fontsPoppinsSemiBold,
                              color: statusColor,
                              fontSize: statusFontSize,
                              letterSpacing: 0.3,
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: isMobile ? 12 : 14),
                    Row(
                      children: [
                        Icon(
                          Icons.receipt_long_rounded,
                          size: isMobile ? 20 : 22,
                          color: Theme.of(
                            context,
                          ).colorScheme.onSecondary.withValues(alpha: 0.7),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            '${Labels.orderNumber} ${orderDetail?.id}',
                            style: TextStyle(
                              fontFamily: FontFamily.fontsPoppinsBold,
                              color: Theme.of(context).colorScheme.onSecondary,
                              fontSize: orderIdFontSize,
                              letterSpacing: 0.3,
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: isMobile ? 6 : 8),
                    Row(
                      children: [
                        Icon(
                          Icons.access_time_rounded,
                          size: isMobile ? 14 : 16,
                          color: Theme.of(
                            context,
                          ).colorScheme.onSecondary.withValues(alpha: 0.6),
                        ),
                        const SizedBox(width: 6),
                        Text(
                          '${Labels.placedOn} ${orderDetail?.placedOn}',
                          style: TextStyle(
                            fontFamily: FontFamily.fontsPoppinsRegular,
                            color: Theme.of(
                              context,
                            ).colorScheme.onSecondary.withValues(alpha: 0.6),
                            fontSize: isMobile ? 12 : 13,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 16),
              Container(
                padding: EdgeInsets.all(isMobile ? 12 : 16),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Theme.of(
                        context,
                      ).colorScheme.primary.withValues(alpha: 0.1),
                      Theme.of(
                        context,
                      ).colorScheme.primary.withValues(alpha: 0.05),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(
                    color: Theme.of(
                      context,
                    ).colorScheme.primary.withValues(alpha: 0.2),
                    width: 1,
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      Labels.totalAmount,
                      style: TextStyle(
                        fontFamily: FontFamily.fontsPoppinsRegular,
                        color: Theme.of(
                          context,
                        ).colorScheme.onSecondary.withValues(alpha: 0.6),
                        fontSize: isMobile ? 11 : 12,
                        letterSpacing: 0.5,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      "${CurrencyIcon.currencyIcon} ${orderDetail?.totalAmount}",
                      style: TextStyle(
                        fontFamily: FontFamily.fontsPoppinsBold,
                        color: Theme.of(context).colorScheme.primary,
                        fontSize: amountFontSize,
                        letterSpacing: 0.3,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: isMobile ? 20 : 24),
          OrderProgressTracker(
            currentStep: orderDetail?.currentStep ?? 0,
            isPickupOrder:
                (orderDetail?.shippingAddress?.title == null &&
                    orderDetail?.shippingAddress?.customerName == null &&
                    orderDetail?.shippingAddress?.fullAddress == null),
          ),
        ],
      ),
    );
  }

  Widget _buildReviewSection(
    BuildContext context,
    OrderDetailsState state,
    double borderRadius,
    bool isMobile,
    bool isTablet,
    bool isLargeTablet,
  ) {
    return Container(
      padding: EdgeInsets.all(isMobile ? 16 : (isTablet ? 20 : 24)),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.onPrimary,
        borderRadius: BorderRadius.circular(borderRadius),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
        border: Border.all(color: Colors.grey.withOpacity(0.1), width: 1),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // ⭐️ Icon container
          Container(
            height: isMobile ? 48 : 56,
            width: isMobile ? 48 : 56,
            decoration: BoxDecoration(
              color: const Color(0xFFFFC107).withOpacity(0.15),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Icon(
              Icons.star_rounded,
              color: const Color(0xFFFFC107),
              size: isMobile ? 26 : (isTablet ? 30 : 34),
            ),
          ),

          SizedBox(width: isMobile ? 14 : 18),

          // 📝 Text section
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Rate Your Order',
                  style: TextStyle(
                    fontFamily: FontFamily.fontsPoppinsSemiBold,
                    fontSize: isMobile ? 16 : (isTablet ? 18 : 20),
                    color: Theme.of(context).colorScheme.onSecondary,
                    height: 1.3,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Your feedback helps us improve your experience.',
                  style: TextStyle(
                    fontFamily: FontFamily.fontsPoppinsRegular,
                    fontSize: isMobile ? 13 : (isTablet ? 14 : 15),
                    color: Theme.of(
                      context,
                    ).colorScheme.onSecondary.withOpacity(0.65),
                  ),
                ),
              ],
            ),
          ),

          SizedBox(width: isMobile ? 12 : 16),

          // 💬 Review button
          IconButton(
            icon: const Icon(Icons.rate_review_rounded, color: Colors.white),

            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFFFC107),
              elevation: 0,
              padding: EdgeInsets.symmetric(
                horizontal: isMobile ? 18 : 22,
                vertical: isMobile ? 12 : (isTablet ? 14 : 16),
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            onPressed: () {
              OrderDetailDialogBoxes.showReviewDialog(
                state.orderDetailModel?.order?.id ?? 0,
                context,
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildCancelledBanner(
    BuildContext context,
    double borderRadius,
    bool isMobile,
    bool isTablet,
    bool isLargeTablet,
  ) {
    return Container(
      padding: EdgeInsets.all(isMobile ? 18 : (isTablet ? 22 : 26)),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Colors.red.shade700.withValues(alpha: 0.15),
            Colors.red.shade700.withValues(alpha: 0.08),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(borderRadius),
        border: Border.all(
          color: Colors.red.shade700.withValues(alpha: 0.4),
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.red.shade700.withValues(alpha: 0.15),
            blurRadius: 15,
            offset: const Offset(0, 6),
            spreadRadius: 0,
          ),
        ],
      ),
      child: Row(
        children: [
          // Warning Icon
          Container(
            height: isMobile ? 48 : (isTablet ? 54 : 60),
            width: isMobile ? 48 : (isTablet ? 54 : 60),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Colors.red.shade700.withValues(alpha: 0.2),
                  Colors.red.shade700.withValues(alpha: 0.1),
                ],
              ),
              borderRadius: BorderRadius.circular(14),
              border: Border.all(
                color: Colors.red.shade700.withValues(alpha: 0.3),
                width: 1,
              ),
            ),
            child: Icon(
              Icons.cancel_outlined,
              color: Colors.red.shade700,
              size: isMobile ? 28 : (isTablet ? 32 : 36),
            ),
          ),

          SizedBox(width: isMobile ? 14 : 18),

          // Text section
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Order Cancelled',
                  style: TextStyle(
                    fontFamily: FontFamily.fontsPoppinsBold,
                    fontSize: isMobile ? 17 : (isTablet ? 19 : 21),
                    color: Colors.red.shade700,
                    height: 1.3,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'This order has been cancelled and cannot be reviewed.',
                  style: TextStyle(
                    fontFamily: FontFamily.fontsPoppinsRegular,
                    fontSize: isMobile ? 13 : (isTablet ? 14 : 15),
                    color: Theme.of(
                      context,
                    ).colorScheme.onSecondary.withOpacity(0.7),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProductsSection(
    BuildContext context,
    dynamic orderDetail,
    OrderDetailsState state,
    double borderRadius,
    bool isMobile,
    bool isTablet,
    bool isLargeTablet,
  ) {
    return Column(
      children: [
        _buildSectionHeader(
          context,
          Labels.orderItems,
          Icons.shopping_bag_rounded,
          '${orderDetail?.summary?.itemQty} ${Labels.item}',
          borderRadius,
          isMobile,
        ),
        const SizedBox(height: 12),
        if (orderDetail?.products != null && orderDetail!.products!.isNotEmpty)
          ListView.builder(
            itemCount: orderDetail.products!.length,
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemBuilder: (context, index) {
              final product = orderDetail.products![index];
              return Padding(
                padding: EdgeInsets.only(bottom: isMobile ? 12 : 14),
                child: _buildEnhancedProductTile(
                  context,
                  product,
                  state,
                  borderRadius,
                  isMobile,
                  isTablet,
                ),
              );
            },
          )
        else
          const SizedBox.shrink(),
      ],
    );
  }

  Widget _buildEnhancedProductTile(
    BuildContext context,
    Products product,
    OrderDetailsState state,
    double borderRadius,
    bool isMobile,
    bool isTablet,
  ) {
    bool isDiscounted = product.price != product.originalPrice;
    final double imageSize = isMobile ? 80 : (isTablet ? 90 : 100);

    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(
          context,
          RouteNames.productScreen,
          arguments: product.productId.toString(),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.onPrimary,
          borderRadius: BorderRadius.circular(borderRadius),
          border: Border.all(
            color: Theme.of(
              context,
            ).colorScheme.outline.withValues(alpha: 0.15),
            width: 1,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.04),
              blurRadius: 15,
              offset: const Offset(0, 4),
              spreadRadius: 0,
            ),
          ],
        ),
        child: Column(
          children: [
            // Shop Header
            Container(
              padding: EdgeInsets.symmetric(
                horizontal: isMobile ? 12 : 16,
                vertical: isMobile ? 10 : 12,
              ),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Theme.of(
                      context,
                    ).colorScheme.primary.withValues(alpha: 0.05),
                    Theme.of(
                      context,
                    ).colorScheme.primary.withValues(alpha: 0.02),
                  ],
                ),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(borderRadius),
                  topRight: Radius.circular(borderRadius),
                ),
              ),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Theme.of(
                        context,
                      ).colorScheme.primary.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(
                      Icons.store_mall_directory_outlined,
                      color: Theme.of(context).colorScheme.primary,
                      size: isMobile ? 18 : 20,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      product.shopName ?? '',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontFamily: FontFamily.fontsPoppinsSemiBold,
                        fontSize: isMobile ? 14 : 15,
                        color: Theme.of(context).colorScheme.onSecondary,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Product Details
            Padding(
              padding: EdgeInsets.all(isMobile ? 12 : 16),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Product Image with overlay
                  Stack(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: Theme.of(
                              context,
                            ).colorScheme.primary.withValues(alpha: 0.1),
                            width: 1,
                          ),
                        ),
                        child: AppCacheImage(
                          imageUrl: '$imageBaseUrl${product.imageUrl}',
                          height: imageSize,
                          width: imageSize,
                          round: 12,
                        ),
                      ),
                      if (isDiscounted)
                        Positioned(
                          top: 0,
                          left: 0,
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              gradient: const LinearGradient(
                                colors: [Colors.red, Colors.redAccent],
                              ),
                              borderRadius: const BorderRadius.only(
                                topLeft: Radius.circular(12),
                                bottomRight: Radius.circular(12),
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.red.withValues(alpha: 0.4),
                                  blurRadius: 8,
                                  offset: const Offset(0, 2),
                                ),
                              ],
                            ),
                            child: Text(
                              '-${_calculatePercentage(product.originalPrice, product.price)}%',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: isMobile ? 11 : 12,
                                fontFamily: FontFamily.fontsPoppinsBold,
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),

                  SizedBox(width: isMobile ? 12 : 16),

                  // Product Info
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          product.productName ?? '',
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontFamily: FontFamily.fontsPoppinsSemiBold,
                            fontSize: isMobile ? 14 : 15,
                            color: Theme.of(context).colorScheme.onSecondary,
                            height: 1.3,
                          ),
                        ),
                        if (product.primaryVariationGroup != null)
                          Padding(
                            padding: const EdgeInsets.only(top: 6),
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                color: Theme.of(
                                  context,
                                ).colorScheme.primary.withValues(alpha: 0.08),
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: Text(
                                "${product.primaryVariationGroup}: ${product.primaryVariationOption}",
                                style: TextStyle(
                                  fontFamily: FontFamily.fontsPoppinsRegular,
                                  fontSize: isMobile ? 11 : 12,
                                  color: Theme.of(context).colorScheme.primary,
                                ),
                              ),
                            ),
                          ),
                        if (product.secondaryVariationGroup != null)
                          Padding(
                            padding: const EdgeInsets.only(top: 6),
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                color: Theme.of(
                                  context,
                                ).colorScheme.primary.withValues(alpha: 0.08),
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: Text(
                                "${product.secondaryVariationGroup}: ${product.secondaryVariationOption}",
                                style: TextStyle(
                                  fontFamily: FontFamily.fontsPoppinsRegular,
                                  fontSize: isMobile ? 11 : 12,
                                  color: Theme.of(context).colorScheme.primary,
                                ),
                              ),
                            ),
                          ),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            Text(
                              "${CurrencyIcon.currencyIcon}${product.price}",
                              style: TextStyle(
                                fontFamily: FontFamily.fontsPoppinsBold,
                                fontSize: isMobile ? 16 : 18,
                                color: Theme.of(context).colorScheme.primary,
                              ),
                            ),
                            if (isDiscounted) ...[
                              const SizedBox(width: 8),
                              Text(
                                "${CurrencyIcon.currencyIcon}${product.originalPrice}",
                                style: TextStyle(
                                  fontFamily: FontFamily.fontsPoppinsRegular,
                                  fontSize: isMobile ? 12 : 13,
                                  color: Theme.of(context)
                                      .colorScheme
                                      .onSecondary
                                      .withValues(alpha: 0.5),
                                  decoration: TextDecoration.lineThrough,
                                ),
                              ),
                            ],
                          ],
                        ),
                      ],
                    ),
                  ),

                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          color: Theme.of(
                            context,
                          ).colorScheme.onSecondary.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(6),
                          border: Border.all(
                            color: Theme.of(
                              context,
                            ).colorScheme.onSecondary.withValues(alpha: .2),
                            width: 1,
                          ),
                        ),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(
                              product.quantity.toString(),
                              style: TextStyle(
                                fontFamily: FontFamily.fontsPoppinsBold,
                                fontSize: isMobile ? 16 : 18,
                                color: Theme.of(context).colorScheme.primary,
                              ),
                            ),
                            Text(
                              "x",
                              style: TextStyle(
                                fontFamily: FontFamily.fontsPoppinsBold,
                                fontSize: isMobile ? 12 : 14,
                                color: Theme.of(context).colorScheme.primary,
                                height: 1.7,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 10),
                      Icon(
                        Icons.arrow_forward_ios_rounded,
                        size: isMobile ? 18 : 20,
                        color: Theme.of(
                          context,
                        ).colorScheme.primary.withValues(alpha: 0.5),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildShippingSection(
    BuildContext context,
    dynamic orderDetail,
    double borderRadius,
    bool isMobile,
    bool isTablet,
    bool isLargeTablet,
  ) {
    return Column(
      children: [
        _buildSectionHeader(
          context,
          Labels.deliveryAddress,
          Icons.location_on_rounded,
          null,
          borderRadius,
          isMobile,
        ),
        const SizedBox(height: 12),
        Container(
          padding: EdgeInsets.all(isMobile ? 16 : 20),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.onPrimary,
            borderRadius: BorderRadius.circular(borderRadius),
            border: Border.all(
              color: Theme.of(
                context,
              ).colorScheme.outline.withValues(alpha: 0.15),
              width: 1,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.04),
                blurRadius: 15,
                offset: const Offset(0, 4),
                spreadRadius: 0,
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: EdgeInsets.all(isMobile ? 10 : 12),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          Theme.of(
                            context,
                          ).colorScheme.primary.withValues(alpha: 0.15),
                          Theme.of(
                            context,
                          ).colorScheme.primary.withValues(alpha: 0.08),
                        ],
                      ),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(
                      Icons.location_on,
                      color: Theme.of(context).colorScheme.primary,
                      size: isMobile ? 20 : 22,
                    ),
                  ),
                  SizedBox(width: isMobile ? 12 : 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          orderDetail?.shippingAddress?.title ?? '',
                          style: TextStyle(
                            fontFamily: FontFamily.fontsPoppinsSemiBold,
                            fontSize: isMobile ? 14 : 15,
                            color: Theme.of(context).colorScheme.onSecondary,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          orderDetail?.shippingAddress?.customerName ?? '',
                          style: TextStyle(
                            fontFamily: FontFamily.fontsPoppinsRegular,
                            fontSize: isMobile ? 13 : 14,
                            color: Theme.of(
                              context,
                            ).colorScheme.onSecondary.withValues(alpha: 0.7),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(height: isMobile ? 14 : 16),
              Container(
                padding: EdgeInsets.all(isMobile ? 12 : 14),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Theme.of(
                        context,
                      ).colorScheme.primary.withValues(alpha: 0.03),
                      Theme.of(
                        context,
                      ).colorScheme.primary.withValues(alpha: 0.01),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                    color: Theme.of(
                      context,
                    ).colorScheme.primary.withValues(alpha: 0.1),
                    width: 1,
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildAddressRow(
                      context,
                      Icons.phone_rounded,
                      orderDetail?.shippingAddress?.primaryPhone ?? '',
                      isMobile,
                    ),
                    if (orderDetail
                            ?.shippingAddress
                            ?.secondaryPhone
                            ?.isNotEmpty ??
                        false) ...[
                      SizedBox(height: isMobile ? 8 : 10),
                      _buildAddressRow(
                        context,
                        Icons.phone_rounded,
                        orderDetail?.shippingAddress?.secondaryPhone ?? '',
                        isMobile,
                      ),
                    ],
                    SizedBox(height: isMobile ? 8 : 10),
                    _buildAddressRow(
                      context,
                      Icons.home_rounded,
                      orderDetail?.shippingAddress?.fullAddress ?? '',
                      isMobile,
                      isAddress: true,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildAddressRow(
    BuildContext context,
    IconData icon,
    String text,
    bool isMobile, {
    bool isAddress = false,
  }) {
    return Row(
      crossAxisAlignment:
          isAddress ? CrossAxisAlignment.start : CrossAxisAlignment.center,
      children: [
        Icon(
          icon,
          size: isMobile ? 14 : 16,
          color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.7),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            text,
            style: TextStyle(
              fontFamily: FontFamily.fontsPoppinsRegular,
              fontSize: isMobile ? 12 : 13,
              color: Theme.of(
                context,
              ).colorScheme.onSecondary.withValues(alpha: 0.8),
              height: isAddress ? 1.4 : 1.2,
            ),
          ),
        ),
      ],
    );
  }

  // Premium Pickup Section for Pickup Orders
  Widget _buildPickupSection(
    BuildContext context,
    dynamic orderDetail,
    double borderRadius,
    bool isMobile,
    bool isTablet,
    bool isLargeTablet,
  ) {
    return Column(
      children: [
        _buildSectionHeader(
          context,
          Labels.pickupLocation,
          Icons.store_mall_directory_rounded,
          null,
          borderRadius,
          isMobile,
        ),
        const SizedBox(height: 12),
        Container(
          padding: EdgeInsets.all(isMobile ? 20 : 24),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.onPrimary,
            borderRadius: BorderRadius.circular(borderRadius),
            border: Border.all(
              color: Theme.of(context).colorScheme.primary,
              width: 1.5,
            ),
            boxShadow: [
              BoxShadow(
                color: Theme.of(
                  context,
                ).colorScheme.onSecondary.withValues(alpha: 0.1),
                blurRadius: 20,
                offset: const Offset(0, 8),
                spreadRadius: 0,
              ),
            ],
          ),
          child: Column(
            children: [
              Row(
                children: [
                  Container(
                    padding: EdgeInsets.all(isMobile ? 14 : 16),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          Theme.of(
                            context,
                          ).colorScheme.primary.withValues(alpha: 0.9),
                          Theme.of(
                            context,
                          ).colorScheme.primary.withValues(alpha: 0.7),
                        ],
                      ),
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: Theme.of(
                            context,
                          ).colorScheme.primary.withValues(alpha: 0.3),
                          blurRadius: 12,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Icon(
                      Icons.store_mall_directory_rounded,
                      color: Colors.white,
                      size: isMobile ? 28 : 32,
                    ),
                  ),
                  SizedBox(width: isMobile ? 16 : 20),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          Labels.pickUpFromStore,
                          style: TextStyle(
                            fontFamily: FontFamily.fontsPoppinsBold,
                            fontSize: isMobile ? 16 : 18,
                            color: Theme.of(context).colorScheme.primary,
                            letterSpacing: 0.3,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          Labels.thsiOrderArepickedUpFromStore,
                          style: TextStyle(
                            fontFamily: FontFamily.fontsPoppinsRegular,
                            fontSize: isMobile ? 13 : 14,
                            color: Theme.of(context).colorScheme.primary,
                            height: 1.4,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildOrderSummarySection(
    BuildContext context,
    dynamic orderDetail,
    double borderRadius,
    bool isMobile,
    bool isTablet,
    bool isLargeTablet,
  ) {
    return Column(
      children: [
        _buildSectionHeader(
          context,
          Labels.orderSummary,
          Icons.receipt_long_rounded,
          null,
          borderRadius,
          isMobile,
        ),
        const SizedBox(height: 12),
        Container(
          padding: EdgeInsets.all(isMobile ? 16 : 20),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.onPrimary,
            borderRadius: BorderRadius.circular(borderRadius),
            border: Border.all(
              color: Theme.of(
                context,
              ).colorScheme.outline.withValues(alpha: 0.15),
              width: 1,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.04),
                blurRadius: 15,
                offset: const Offset(0, 4),
                spreadRadius: 0,
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
                isMobile,
              ),
              SizedBox(height: isMobile ? 12 : 14),
              _buildSummaryRow(
                context,
                Labels.deliveryFee,
                '${CurrencyIcon.currencyIcon} ${orderDetail?.summary?.deliveryFee}',
                false,
                isMobile,
              ),
              SizedBox(height: isMobile ? 12 : 14),
              _buildSummaryRow(
                context,
                Labels.tax,
                '${CurrencyIcon.currencyIcon} ${orderDetail?.summary?.tax}',
                false,
                isMobile,
              ),
              SizedBox(height: isMobile ? 16 : 18),
              Container(
                height: 1,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Colors.transparent,
                      Theme.of(
                        context,
                      ).colorScheme.outline.withValues(alpha: 0.2),
                      Colors.transparent,
                    ],
                  ),
                ),
              ),
              SizedBox(height: isMobile ? 16 : 18),
              Container(
                padding: EdgeInsets.all(isMobile ? 12 : 14),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Theme.of(
                        context,
                      ).colorScheme.primary.withValues(alpha: 0.1),
                      Theme.of(
                        context,
                      ).colorScheme.primary.withValues(alpha: 0.05),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: Theme.of(
                      context,
                    ).colorScheme.primary.withValues(alpha: 0.2),
                    width: 1,
                  ),
                ),
                child: _buildSummaryRow(
                  context,
                  Labels.totalAmount,
                  '${CurrencyIcon.currencyIcon} ${orderDetail?.summary?.total}',
                  true,
                  isMobile,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildSectionHeader(
    BuildContext context,
    String title,
    IconData icon,
    String? badge,
    double borderRadius,
    bool isMobile,
  ) {
    return Row(
      children: [
        Container(
          padding: EdgeInsets.all(isMobile ? 8 : 10),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Theme.of(context).colorScheme.primary.withValues(alpha: 0.15),
                Theme.of(context).colorScheme.primary.withValues(alpha: 0.08),
              ],
            ),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(
            icon,
            color: Theme.of(context).colorScheme.primary,
            size: isMobile ? 18 : 20,
          ),
        ),
        const SizedBox(width: 12),
        Text(
          title,
          style: TextStyle(
            fontFamily: FontFamily.fontsPoppinsSemiBold,
            fontSize: isMobile ? 16 : 18,
            color: Theme.of(context).colorScheme.onSecondary,
            letterSpacing: 0.2,
          ),
        ),
        const Spacer(),
        if (badge != null)
          Container(
            padding: EdgeInsets.symmetric(
              horizontal: isMobile ? 10 : 12,
              vertical: isMobile ? 5 : 6,
            ),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Theme.of(context).colorScheme.primary.withValues(alpha: 0.15),
                  Theme.of(context).colorScheme.primary.withValues(alpha: 0.08),
                ],
              ),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: Theme.of(
                  context,
                ).colorScheme.primary.withValues(alpha: 0.2),
                width: 1,
              ),
            ),
            child: Text(
              badge,
              style: TextStyle(
                fontFamily: FontFamily.fontsPoppinsSemiBold,
                fontSize: isMobile ? 11 : 12,
                color: Theme.of(context).colorScheme.primary,
                letterSpacing: 0.3,
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildSummaryRow(
    BuildContext context,
    String label,
    String value,
    bool isBold,
    bool isMobile,
  ) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Text(
            label,
            style: TextStyle(
              fontFamily:
                  isBold
                      ? FontFamily.fontsPoppinsSemiBold
                      : FontFamily.fontsPoppinsRegular,
              fontSize: isBold ? (isMobile ? 15 : 16) : (isMobile ? 13 : 14),
              color: Theme.of(
                context,
              ).colorScheme.onSecondary.withValues(alpha: isBold ? 1.0 : 0.7),
              letterSpacing: 0.2,
            ),
          ),
        ),
        const SizedBox(width: 12),
        Text(
          value,
          style: TextStyle(
            fontFamily:
                isBold
                    ? FontFamily.fontsPoppinsBold
                    : FontFamily.fontsPoppinsMedium,
            fontSize: isBold ? (isMobile ? 18 : 20) : (isMobile ? 14 : 15),
            color:
                isBold
                    ? Theme.of(context).colorScheme.primary
                    : Theme.of(context).colorScheme.onSecondary,
            letterSpacing: 0.3,
          ),
        ),
      ],
    );
  }

  int _calculatePercentage(String? originalPrice, String? discountedPrice) {
    final original = double.tryParse(originalPrice ?? '0') ?? 0;
    final discounted = double.tryParse(discountedPrice ?? '0') ?? 0;
    if (original == 0) return 0;
    return ((original - discounted) / original * 100).round();
  }
}
