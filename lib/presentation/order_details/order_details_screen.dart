import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:speezu/widgets/custom_app_bar.dart';

import '../../core/assets/font_family.dart';
import '../../core/utils/currency_icon.dart';
import '../../core/utils/labels.dart';
import '../../widgets/app_cache_image.dart';
import '../../widgets/custom_text_form_field.dart';
import '../../widgets/dialog_boxes/order_detail_dialogs.dart';
import '../../widgets/order_detail_product_tile.dart';
import '../../widgets/order_progress_tracker.dart';
import '../../widgets/order_summary_order_screen_container.dart';
import '../../widgets/shipping_address_order_screen_container.dart';
import '../settings/product_give_rating.dart';

class OrderDetailsScreen extends StatelessWidget {
  const OrderDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: CustomAppBar(title: Labels.orderDetails),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height: 10),
            OrderDetailsProductTile(
              onTrackTap: () {},
              shopName: "Shop Name",
              onReviewTap: () {
                OrderDetailDialogBoxes.showReviewDialog(23, context);
              },
              imageUrl:
                  'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTW1yhlTpkCnujnhzP-xioiy9RdDQkKLMnMSg&s',
              productName: 'Sample Product',
              variationParentName: 'Size',
              variationParentValue: 'M',
              variationChildName: 'Color',
              variationChildValue: 'Red',
              price: '20.00',
              originalPrice: '25.00',
            ),
            SizedBox(height: 10),
            OrderDetailsProductTile(
              onTrackTap: () {},
              shopName: "Shop Name",
              onReviewTap: () {},
              imageUrl:
                  'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRDe9L5mHiM3JzRMekXhP4IpWD5ZTdNmBn_cg&s',
              productName: 'Another Product',
              variationParentName: 'Size',
              variationParentValue: 'L',
              variationChildName: 'Color',
              variationChildValue: 'Blue',
              price: '15.00',
              originalPrice: '15.00',
            ),
            SizedBox(height: 10),
            Container(
              padding: EdgeInsets.symmetric(vertical: 5),
              margin: EdgeInsets.symmetric(horizontal: 15.0),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.onPrimary,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: Theme.of(
                    context,
                  ).colorScheme.outline.withValues(alpha: .3),
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
                  SizedBox(height: 10),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.primary,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '# 2322',
                              style: TextStyle(
                                fontFamily: FontFamily.fontsPoppinsMedium,
                                color: Theme.of(context).colorScheme.onPrimary,
                                fontSize: 13,
                              ),
                            ),
                            Text(
                              // '1 ${label.product} | ' +
                              '${Labels.orderPlacedOn} 12 Aug, 2023',
                              style: TextStyle(
                                fontFamily: FontFamily.fontsPoppinsRegular,
                                color: Theme.of(context).colorScheme.onPrimary,
                                fontSize: 10,
                              ),
                            ),
                          ],
                        ),
                        Text(
                          "${CurrencyIcon.currencyIcon} 2122.00",
                          style: TextStyle(
                            fontFamily: FontFamily.fontsPoppinsBold,
                            color: Theme.of(context).colorScheme.onPrimary,
                            fontSize: 17,
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 5),
                  OrderProgressTracker(isFoodOrder: true, currentStep: 1),
                ],
              ),
            ),
            SizedBox(height: 10),
            ShippingAddressOrderScreenContainer(
              addressTitle: 'Office Address',
              customerName: 'John Doe',
              primaryPhoneNumber: '+1234567890',
              secondaryPhoneNumber: '+0987654321',
              address: '123 Main St, City, Country',

            ),
            SizedBox(height: 10),
            OrderSummaryOrderScreenContainer(
              itemTotal: '200.00',
              deliveryFee: '20.00',
              tax: '5.00',
              total: '225.00',
              itemQty: '2',
            ),
            SizedBox(height: 30,)
          ],
        ),
      ),
    );
  }
}

