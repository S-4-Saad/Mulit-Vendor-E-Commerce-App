import 'package:flutter/material.dart';
import 'package:speezu/core/assets/font_family.dart';
import 'package:speezu/core/utils/labels.dart';
import 'package:speezu/core/utils/snackbar_helper.dart';
import 'package:speezu/presentation/settings/add_address_screen.dart';
import 'package:speezu/presentation/settings/edit_address_screen.dart';
import 'package:speezu/widgets/custom_app_bar.dart';
import 'package:speezu/models/address_model.dart';
import 'package:speezu/repositories/user_repository.dart';

import '../../widgets/address_book_selection_container.dart';
import '../../widgets/dialog_boxes/address_book_dialogs.dart';

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
      SnackBarHelper.showSuccess(context, Labels.defaultAddressUpdatedSuccessfully);

    } else {
      SnackBarHelper.showError(context, Labels.failedToUpdateDefaultAddress);

    }
  }

  Future<void> _deleteAddress(String addressId) async {
    final success = await _userRepository.removeAddress(addressId);
    if (success) {
      _loadAddresses();
      SnackBarHelper.showSuccess(context, Labels.addressDeletedSuccessfully);

    } else {
      SnackBarHelper.showError(context, Labels.failedToDeleteAddress);

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
                    Labels.noAddressesSaved,
                    style: TextStyle(
                      fontSize: 18,
                      fontFamily: FontFamily.fontsPoppinsSemiBold,
                      color: Theme.of(context).colorScheme.onSecondary.withValues(alpha: 0.7),
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    Labels.addYourFirstAddress,
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
                      SnackBarHelper.showSuccess(context, Labels.alreadyDefault);

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





