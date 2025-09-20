import 'package:flutter/material.dart';
import 'package:speezu/core/assets/font_family.dart';
import 'package:speezu/core/utils/labels.dart';
import 'package:speezu/presentation/settings/add_address_screen.dart';
import 'package:speezu/presentation/settings/edit_address_screen.dart';
import 'package:speezu/widgets/custom_app_bar.dart';
import 'package:speezu/models/address_model.dart';
import 'package:speezu/repositories/user_repository.dart';

class AddressBookScreen extends StatefulWidget {
  const AddressBookScreen({super.key});

  @override
  State<AddressBookScreen> createState() => _AddressBookScreenState();
}

class _AddressBookScreenState extends State<AddressBookScreen> {
  final UserRepository _userRepository = UserRepository();
  List<AddressModel> _addresses = [];

  @override
  void initState() {
    super.initState();
    _loadAddresses();
  }

  void _loadAddresses() {
    final addresses = _userRepository.deliveryAddresses;
    setState(() {
      // Sort addresses to show default address first, then others
      _addresses = addresses ?? [];
      _addresses.sort((a, b) {
        // Default addresses come first
        if (a.isDefault == true && b.isDefault != true) return -1;
        if (a.isDefault != true && b.isDefault == true) return 1;
        // If both have same default status, maintain original order by ID (creation order)
        return (a.id ?? '').compareTo(b.id ?? '');
      });
    });
  }

  Future<void> _setDefaultAddress(String addressId) async {
    final success = await _userRepository.setDefaultAddress(addressId);
    if (success) {
      // Reload addresses to get updated order with new default at top
      _loadAddresses();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Default address updated successfully!'),
          backgroundColor: Colors.green,
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to update default address. Please try again.'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Future<void> _deleteAddress(String addressId) async {
    final success = await _userRepository.removeAddress(addressId);
    if (success) {
      _loadAddresses();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Address deleted successfully!'),
          backgroundColor: Colors.green,
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to delete address. Please try again.'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: Labels.addressBook,
        action: IconButton(
          onPressed: () async {
            await Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => AddNewAddressScreen()),
            );
            // Reload addresses when returning from add address screen
            _loadAddresses();
          },
          icon: Icon(Icons.add,color: Theme.of(context).colorScheme.onSecondary,),
        ),
      ),
      body: _addresses.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.location_off,
                    size: 64,
                    color: Theme.of(context).colorScheme.onSecondary.withValues(alpha: 0.3),
                  ),
                  SizedBox(height: 16),
                  Text(
                    'No addresses saved',
                    style: TextStyle(
                      fontSize: 18,
                      fontFamily: FontFamily.fontsPoppinsSemiBold,
                      color: Theme.of(context).colorScheme.onSecondary.withValues(alpha: 0.7),
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Add your first address to get started',
                    style: TextStyle(
                      fontSize: 14,
                      fontFamily: FontFamily.fontsPoppinsRegular,
                      color: Theme.of(context).colorScheme.onSecondary.withValues(alpha: 0.5),
                    ),
                  ),
                ],
              ),
            )
          : ListView.builder(
              itemCount: _addresses.length,
              itemBuilder: (context, index) {
                final address = _addresses[index];
                return AddressBookSelectionContainer(
                  onSelectPressed: () {
                    // Don't show dialog if address is already default
                    if (address.isDefault == true) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('This address is already set as default'),
                          backgroundColor: Colors.blue,
                        ),
                      );
                      return;
                    }
                    
                    AddressBookDialogs.showDefaultSelectionAddressDialog(
                      context: context,
                      onSelect: () async {
                        // Close dialog first
                        Navigator.of(context).pop();
                        // Then set default address
                        await _setDefaultAddress(address.id!);
                      },
                    );
                  },
                  addressTitle: address.title ?? 'Address',
                  isSelected: address.isDefault ?? false,
                  customerName: address.customerName ?? '',
                  phoneNumber: address.primaryPhoneNumber ?? '',
                  secondaryPhoneNumber: address.secondaryPhoneNumber ?? '',
                  address: address.address ?? '',
                  onEditPressed: () async {
                    await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => EditAddressScreen(address: address),
                      ),
                    );
                    // Reload addresses when returning from edit screen
                    _loadAddresses();
                  },
                  onDeletePressed: () {
                    AddressBookDialogs.showDeleteSelectionAddressDialog(
                      context: context,
                      onSelect: () async {
                        // Close dialog first
                        Navigator.of(context).pop();
                        // Then delete the address
                        await _deleteAddress(address.id!);
                      },
                    );
                  },
                );
              },
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

