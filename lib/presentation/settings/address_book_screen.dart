import 'package:flutter/material.dart';
import 'package:speezu/core/assets/font_family.dart';
import 'package:speezu/core/utils/labels.dart';
import 'package:speezu/presentation/settings/add_address_screen.dart';
import 'package:speezu/widgets/custom_app_bar.dart';

class AddressBookScreen extends StatelessWidget {
  const AddressBookScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: Labels.addressBook,

        action: IconButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => AddNewAddressScreen()),
            );
          },
          icon: Icon(Icons.add,color: Theme.of(context).colorScheme.onSecondary,),
        ),
      ),
      body: Column(
        children: [
          AddressBookSelectionContainer(
            onSelectPressed: () {
              AddressBookDialogs.showDefaultSelectionAddressDialog(
                context: context,
                onSelect: () {
                  Navigator.of(context).pop();
                },
              );
            },
            addressTitle: 'Office Address',
            isSelected: true,
            customerName: 'John Doe',
            phoneNumber: '030000020202',
            secondaryPhoneNumber: '03020220022',
            address:
                '1234, Address line 1, Address line 2, City, State, Zip Code',
            onEditPressed: () {},
            onDeletePressed: () {
              AddressBookDialogs.showDeleteSelectionAddressDialog(
                context: context,
                onSelect: () {
                  Navigator.of(context).pop();
                },
              );
            },
          ),
          AddressBookSelectionContainer(
            onSelectPressed: () {
              AddressBookDialogs.showDefaultSelectionAddressDialog(
                context: context,
                onSelect: () {
                  Navigator.of(context).pop();
                },
              );
            },
            addressTitle: 'Office Address',
            isSelected: false,
            customerName: 'John Doe',
            phoneNumber: '030000020202',
            address:
                '1234, Address line 1, Address line 2, City, State, Zip Code',
            onEditPressed: () {},
            onDeletePressed: () {},
          ),
        ],
      ),
    );
  }
}

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
                padding: EdgeInsets.symmetric(horizontal: 10, vertical: 7),
                decoration: BoxDecoration(
                  color: Theme.of(
                    context,
                  ).colorScheme.onSecondary.withValues(alpha: .05),
                  borderRadius: BorderRadius.circular(5),
                  border: Border.all(
                    color: Theme.of(
                      context,
                    ).colorScheme.onSecondary.withValues(alpha: .2),
                  ),
                ),
                child: Text(
                  Labels.defaultShippingAddress,
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.onSecondary,
                    fontFamily: FontFamily.fontsPoppinsSemiBold,
                    fontSize: 13,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class AddressBookDialogs {
  static void showDefaultSelectionAddressDialog({
    required BuildContext context,
    required VoidCallback onSelect,
  }) {
    showDialog(
      context: context,
      barrierDismissible: true, // Allow dismissing by tapping outside
      builder: (BuildContext dialogContext) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          elevation: 2,
          backgroundColor: Theme.of(context).colorScheme.onPrimary,
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Title
                Text(
                  Labels.defaultShippingAddress,
                  style: TextStyle(
                    fontSize: 15,
                    fontFamily: FontFamily.fontsPoppinsSemiBold,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
                SizedBox(height: 10),
                // Message
                Text(
                  Labels
                      .areYouSureYouWantToSelectThisAddressAsYourDefaultShippingAddress,
                  style: TextStyle(
                    fontSize: 12,
                    fontFamily: FontFamily.fontsPoppinsRegular,
                    color: Theme.of(
                      context,
                    ).colorScheme.onSecondary.withValues(alpha: 0.7),
                  ),
                  textAlign: TextAlign.justify,
                ),
                SizedBox(height: 20),
                // Buttons
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    // Cancel Button
                    TextButton(
                      onPressed: () {
                        Navigator.of(dialogContext).pop();
                      },
                      child: Text(
                        Labels.cancel,
                        style: TextStyle(
                          fontSize: 12,
                          fontFamily: FontFamily.fontsPoppinsRegular,
                          color: Theme.of(context).colorScheme.outline,
                        ),
                      ),
                    ),
                    // Delete Button
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Theme.of(context).colorScheme.primary,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        padding: EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 6,
                        ),
                      ),
                      onPressed: () {
                        onSelect();
                      },
                      child: Text(
                        Labels.selectAddress,
                        style: TextStyle(
                          fontSize: 12,
                          fontFamily: FontFamily.fontsPoppinsSemiBold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  static void showDeleteSelectionAddressDialog({
    required BuildContext context,
    required VoidCallback onSelect,
  }) {
    showDialog(
      context: context,
      barrierDismissible: true, // Allow dismissing by tapping outside
      builder: (BuildContext dialogContext) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          elevation: 2,
          backgroundColor: Theme.of(context).colorScheme.onPrimary,
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Title
                Text(
                  Labels.deleteAddress,
                  style: TextStyle(
                    fontSize: 15,
                    fontFamily: FontFamily.fontsPoppinsSemiBold,
                    color: Colors.red,
                  ),
                ),
                SizedBox(height: 10),
                // Message
                Text(
                  Labels.areYouSureYouWantToDeleteThisAddress,
                  style: TextStyle(
                    fontSize: 12,
                    fontFamily: FontFamily.fontsPoppinsRegular,
                    color: Theme.of(
                      context,
                    ).colorScheme.onSecondary.withValues(alpha: 0.7),
                  ),
                  textAlign: TextAlign.justify,
                ),
                SizedBox(height: 20),
                // Buttons
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    // Cancel Button
                    TextButton(
                      onPressed: () {
                        Navigator.of(dialogContext).pop();
                      },
                      child: Text(
                        Labels.cancel,
                        style: TextStyle(
                          fontSize: 12,
                          fontFamily: FontFamily.fontsPoppinsRegular,
                          color: Theme.of(context).colorScheme.outline,
                        ),
                      ),
                    ),
                    // Delete Button
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        padding: EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 6,
                        ),
                      ),
                      onPressed: () {
                        onSelect();
                      },
                      child: Text(
                        Labels.deleteAddress,
                        style: TextStyle(
                          fontSize: 12,
                          fontFamily: FontFamily.fontsPoppinsSemiBold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
