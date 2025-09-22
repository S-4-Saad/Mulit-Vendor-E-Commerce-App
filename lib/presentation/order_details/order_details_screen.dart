import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
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

class OrderDetailsScreen extends StatelessWidget {
  OrderDetailsScreen({super.key});

  final OrderDetailModel dummyOrder = OrderDetailModel(
    id: 2322,
    placedOn: "12 Aug, 2023",
    totalAmount: 2122.00,
    currentStep: 2,
    products: [
      OrderDetailProduct(
        isReviewTaken: true,
        shopName: "Shop Name",
        imageUrl:
        "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTW1yhlTpkCnujnhzP-xioiy9RdDQkKLMnMSg&s",
        productName: "Sample Product",
        variationParentName: "Size",
        variationParentValue: "M",
        variationChildName: "Color",
        variationChildValue: "Red",
        price: "20.00",
        originalPrice: "25.00",
      ),
      OrderDetailProduct(
        isReviewTaken: false,
        shopName: "Shop Name",
        imageUrl:
        "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRDe9L5mHiM3JzRMekXhP4IpWD5ZTdNmBn_cg&s",
        productName: "Another Product",
        variationParentName: "Size",
        variationParentValue: "L",
        variationChildName: "Color",
        variationChildValue: "Blue",
        price: "15.00",
        originalPrice: "15.00",
      ),
    ],
    shippingAddress: OrderDetailAddress(
      title: "Office Address",
      customerName: "John Doe",
      primaryPhone: "+1234567890",
      secondaryPhone: "+0987654321",
      fullAddress: "123 Main St, City, Country",
    ),
    summary: OrderDetailSummary(
      itemTotal: "200.00",
      deliveryFee: "20.00",
      tax: "5.00",
      total: "225.00",
      itemQty: "2",
    ),
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: CustomAppBar(title: Labels.orderDetails),
      body: ListView(
        padding: const EdgeInsets.only(bottom: 30),
        children: [
          const SizedBox(height: 10),

          /// Product tiles
          ...dummyOrder.products.map(
                (orderDetail) => Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: OrderDetailsProductTile(
                isReviewed: orderDetail.isReviewTaken,
                onTrackTap: () {},
                shopName: orderDetail.shopName,
                onReviewTap: () {
                  OrderDetailDialogBoxes.showReviewDialog(
                      dummyOrder.id, context);
                },
                imageUrl: orderDetail.imageUrl,
                productName: orderDetail.productName,
                variationParentName: orderDetail.variationParentName,
                variationParentValue: orderDetail.variationParentValue,
                variationChildName: orderDetail.variationChildName,
                variationChildValue: orderDetail.variationChildValue,
                price: orderDetail.price,
                originalPrice: orderDetail.originalPrice,
              ),
            ),
          ),

          /// Order info
          Container(
            padding: const EdgeInsets.symmetric(vertical: 5),
            margin: const EdgeInsets.symmetric(horizontal: 15.0),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.onPrimary,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: Theme.of(context)
                    .colorScheme
                    .outline
                    .withValues(alpha: .3),
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withValues(alpha: 0.1),
                  spreadRadius: 1,
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Column(
              children: [
                const SizedBox(height: 10),
                Container(
                  padding:
                  const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.primary,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      /// Order ID + date
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '# ${dummyOrder.id}',
                            style: TextStyle(
                              fontFamily: FontFamily.fontsPoppinsMedium,
                              color: Theme.of(context).colorScheme.onPrimary,
                              fontSize: 13,
                            ),
                          ),
                          Text(
                            '${Labels.orderPlacedOn} ${dummyOrder.placedOn}',
                            style: TextStyle(
                              fontFamily: FontFamily.fontsPoppinsRegular,
                              color: Theme.of(context).colorScheme.onPrimary,
                              fontSize: 10,
                            ),
                          ),
                        ],
                      ),

                      /// Total
                      Text(
                        "${CurrencyIcon.currencyIcon} ${dummyOrder.totalAmount}",
                        style: TextStyle(
                          fontFamily: FontFamily.fontsPoppinsBold,
                          color: Theme.of(context).colorScheme.onPrimary,
                          fontSize: 17,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 5),
                OrderProgressTracker(
                  isFoodOrder: true,
                  currentStep: dummyOrder.currentStep,
                ),
              ],
            ),
          ),

          const SizedBox(height: 10),

          /// Shipping address
          ShippingAddressOrderScreenContainer(
            addressTitle: dummyOrder.shippingAddress.title,
            customerName: dummyOrder.shippingAddress.customerName,
            primaryPhoneNumber: dummyOrder.shippingAddress.primaryPhone,
            secondaryPhoneNumber: dummyOrder.shippingAddress.secondaryPhone,
            address: dummyOrder.shippingAddress.fullAddress,
          ),

          const SizedBox(height: 10),

          /// Order summary
          OrderSummaryOrderScreenContainer(
            itemTotal: dummyOrder.summary.itemTotal,
            deliveryFee: dummyOrder.summary.deliveryFee,
            tax: dummyOrder.summary.tax,
            total: dummyOrder.summary.total,
            itemQty: dummyOrder.summary.itemQty,
          ),
        ],
      ),
    );
  }
}



