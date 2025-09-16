import 'package:flutter/material.dart';
import 'package:speezu/core/assets/font_family.dart';
import 'package:speezu/core/utils/currency_icon.dart';
import 'package:speezu/widgets/app_cache_image.dart';
import 'package:speezu/widgets/custom_app_bar.dart';

import '../../core/utils/labels.dart';
import '../../widgets/cart_list_tile.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: Labels.yourCart),
      bottomNavigationBar: SafeArea(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 8.0),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.onPrimary,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(30),
              topRight: Radius.circular(30),
            ),
            border: Border.all(
              color: Theme.of(context).colorScheme.primary.withValues(alpha: .3),
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
              SizedBox(
                height: 10,
              ),
              Text(
                Labels.summary,
                style: TextStyle(
                  fontFamily: FontFamily.fontsPoppinsSemiBold,
                  color: Theme.of(context).colorScheme.onSecondary,
                  fontSize: 16,
                ),
              ),
              SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '${Labels.itemsTotal} ( 1 ${Labels.item} )',
                    style: TextStyle(
                      fontFamily: FontFamily.fontsPoppinsRegular,
                      color: Theme.of(context).colorScheme.onSecondary,
                      fontSize: 14,
                    ),
                  ),
                  Text(
                    '${CurrencyIcon.currencyIcon} 2222',
                    style: TextStyle(
                      fontFamily: FontFamily.fontsPoppinsRegular,
                      color: Theme.of(context).colorScheme.onSecondary,
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
                      color: Theme.of(context).colorScheme.onSecondary,
                      fontSize: 14,
                    ),
                  ),
                  Text(
                    '${CurrencyIcon.currencyIcon} 2222',
                    style: TextStyle(
                      fontFamily: FontFamily.fontsPoppinsRegular,
                      color: Theme.of(context).colorScheme.onSecondary,
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
                      color: Theme.of(context).colorScheme.onSecondary,
                      fontSize: 14,
                    ),
                  ),
                  Text(
                    '${CurrencyIcon.currencyIcon} 2222',
                    style: TextStyle(
                      fontFamily: FontFamily.fontsPoppinsRegular,
                      color: Theme.of(context).colorScheme.onSecondary,
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
                      color: Theme.of(context).colorScheme.onSecondary,
                      fontSize: 16,
                    ),
                  ),
                  Text(
                    '${CurrencyIcon.currencyIcon} 2222',
                    style: TextStyle(
                      fontFamily: FontFamily.fontsPoppinsSemiBold,
                      color: Theme.of(context).colorScheme.onSecondary,
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
                  onPressed: () {},
                  child: Text(
                    Labels.checkout,
                    style: TextStyle(
                      fontFamily:
                      FontFamily.fontsPoppinsSemiBold,
                      color: Colors.white,
                      fontSize: 15,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            SizedBox(height: 10),
            CartListTile(
              imageUrl:
                  "https://images.unsplash.com/photo-1504674900247-0877df9cc836?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxzZWFyY2h8Mnx8Y2FydHxlbnwwfHwwfHx8MA%3D%3D&auto=format&fit=crop&w=800&q=60",
              productName:
                  'Lenovo 300e Intel Chip Loren chip loren iposum loren ipssum ',
              variationParentName: 'Processor',
              variationParentValue: "8th Gen",
              variationChildName: 'RAM',
              variationChildValue: 'DDR4 4 Gb',
              price: '20000',
              originalPrice: '22222',
              quantity: 1,
              onAdd: () {},
              onRemove: () {},
              onDelete: () {},
            ),
          ],
        ),
      ),
    );
  }
}
