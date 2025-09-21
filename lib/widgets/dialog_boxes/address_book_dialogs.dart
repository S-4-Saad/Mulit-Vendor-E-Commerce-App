import 'package:flutter/material.dart';

import '../../core/assets/font_family.dart';
import '../../core/utils/labels.dart';

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
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () => Navigator.pop(dialogContext),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.grey.shade300,
                          foregroundColor: Colors.black87,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child:  Text(
                          Labels.close,
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.black87,
                            fontFamily: FontFamily.fontsPoppinsRegular,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: onSelect,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child:  Text(
                          Labels.deleteAddress,
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.white,
                            fontFamily: FontFamily.fontsPoppinsRegular,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                // Buttons

              ],
            ),
          ),
        );
      },
    );
  }
}