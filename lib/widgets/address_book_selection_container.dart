import 'package:flutter/material.dart';

import '../core/assets/font_family.dart';
import '../core/utils/labels.dart';

class AddressBookSelectionContainer extends StatelessWidget {
  const AddressBookSelectionContainer({
    super.key,
    this.isSelected = false,
    required this.customerName,
    required this.phoneNumber,
    this.secondaryPhoneNumber = '',
    required this.address,
    required this.addressTitle,
    required this.onEditPressed,
    required this.onDeletePressed,
    required this.onSelectPressed,
  });
  final bool isSelected;
  final String customerName;
  final String phoneNumber;
  final String addressTitle;
  final String secondaryPhoneNumber;
  final String address;
  final VoidCallback onEditPressed;
  final VoidCallback onDeletePressed;
  final VoidCallback onSelectPressed;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onSelectPressed,
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 15, vertical: 5),
        padding: EdgeInsets.all(10),
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
            Row(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
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
                          fontSize: 14,
                          color: Theme.of(context).colorScheme.primary,
                          fontFamily: FontFamily.fontsPoppinsRegular,
                        ),
                      ),
                    ),
                    SizedBox(height: 5),
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
                  ],
                ),
                Spacer(),
                IconButton(
                  onPressed: onEditPressed,
                  icon: Icon(Icons.edit, color: Colors.blue),
                ),
                IconButton(
                  onPressed: onDeletePressed,
                  icon: Icon(Icons.delete, color: Colors.red),
                ),
              ],
            ),
            Text(
              phoneNumber + ', ' + secondaryPhoneNumber,
              style: TextStyle(
                fontSize: 14,
                color: Theme.of(
                  context,
                ).colorScheme.onSecondary.withValues(alpha: .7),
                fontFamily: FontFamily.fontsPoppinsRegular,
              ),
            ),
            SizedBox(height: 5),
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
            if (isSelected)
              Container(
                margin: EdgeInsets.only(top: 10, bottom: 5),
                padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.3),
                    width: 1.5,
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.star,
                      color: Theme.of(context).colorScheme.primary,
                      size: 16,
                    ),
                    SizedBox(width: 6),
                    Text(
                      Labels.defaultShippingAddress,
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.primary,
                        fontFamily: FontFamily.fontsPoppinsSemiBold,
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }
}