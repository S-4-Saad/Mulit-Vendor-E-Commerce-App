import 'package:flutter/material.dart';

import '../core/assets/font_family.dart';
import '../core/utils/labels.dart';

class ShippingAddressOrderScreenContainer extends StatelessWidget {
  const ShippingAddressOrderScreenContainer({
    super.key,
    required this.addressTitle,
    required this.customerName,
    required this.primaryPhoneNumber,
    required this.secondaryPhoneNumber,
    required this.address,

  });
  final String addressTitle;
  final String customerName;
  final String primaryPhoneNumber;
  final String secondaryPhoneNumber;
  final String address;


  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 15.0),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.onPrimary,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Theme.of(context).colorScheme.outline.withValues(alpha: .3),
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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  Labels.shippingAddress,
                  style: TextStyle(
                    fontFamily: FontFamily.fontsPoppinsRegular,
                    color: Theme.of(context).colorScheme.onSecondary,
                  ),
                ),
                Container(
                  decoration: BoxDecoration(
                    color: Theme.of(
                      context,
                    ).colorScheme.primary.withValues(alpha: .1),
                    borderRadius: BorderRadius.circular(5),
                  ),
                  padding: EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                  child: Text(
                    addressTitle,
                    style: TextStyle(
                      fontSize: 13,
                      color: Theme.of(context).colorScheme.primary,
                      fontFamily: FontFamily.fontsPoppinsRegular,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Divider(
            color: Theme.of(context).colorScheme.outline.withValues(alpha: .3),
            height: 1,
            thickness: 1,
          ),
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          customerName,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 16,
                            color: Theme.of(context).colorScheme.onSecondary,
                            fontFamily: FontFamily.fontsPoppinsSemiBold,
                          ),
                        ),
                        Text(
                          primaryPhoneNumber + ', ' + secondaryPhoneNumber,
                          style: TextStyle(
                            fontSize: 14,
                            color: Theme.of(
                              context,
                            ).colorScheme.onSecondary.withValues(alpha: .7),
                            fontFamily: FontFamily.fontsPoppinsRegular,
                          ),
                        ),
                      ],
                    ),

                  ],
                ),


                Text(
                  address,
                  style: TextStyle(
                    fontSize: 14,
                    color: Theme.of(
                      context,
                    ).colorScheme.onSecondary.withValues(alpha: .7),
                    fontFamily: FontFamily.fontsPoppinsRegular,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
