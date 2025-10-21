import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:speezu/core/utils/snackbar_helper.dart';

import '../../core/assets/font_family.dart';
import '../../core/utils/app_validators.dart';
import '../../core/utils/labels.dart';
import '../../widgets/custom_app_bar.dart';
import '../../widgets/custom_text_form_field.dart';
import '../../models/address_model.dart';
import '../../repositories/user_repository.dart';
import '../cart/bloc/cart_bloc.dart';
import 'map_picker_screen.dart';

class AddNewAddressScreen extends StatefulWidget {
  const AddNewAddressScreen({super.key});

  @override
  State<AddNewAddressScreen> createState() => _AddNewAddressScreenState();
}

class _AddNewAddressScreenState extends State<AddNewAddressScreen> {
  final _addAddressKey = GlobalKey<FormState>();
  final TextEditingController addressController = TextEditingController();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController primaryPhoneNumber = TextEditingController();
  final TextEditingController selectedAddressType = TextEditingController();
  final TextEditingController secondaryPhoneNumber = TextEditingController();
  final FocusNode nameFocusNode = FocusNode();
  final FocusNode primaryPhoneFocusNode = FocusNode();
  final FocusNode secondaryPhoneFocusNode = FocusNode();
  final FocusNode addressFocusNode = FocusNode();
  final FocusNode selectedAddressTypeFocusNode = FocusNode();

  // Address type dropdown
  // String? selectedAddressType;
  final List<String> addressTypes = [
    'Home Address',
    'Office Address',
    'Temporary Address',
    'Current Address',
    'Other',
  ];


  @override
  void dispose() {
    addressController.dispose();
    nameController.dispose();
    primaryPhoneNumber.dispose();
    secondaryPhoneNumber.dispose();
    nameFocusNode.dispose();
    primaryPhoneFocusNode.dispose();
    secondaryPhoneFocusNode.dispose();
    addressFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    TextStyle textStyle = TextStyle(
      fontFamily: FontFamily.fontsPoppinsMedium,
      color: Theme.of(context).colorScheme.onSecondary,
      fontSize: 14,
    );
    return Scaffold(
      appBar: CustomAppBar(title: Labels.addNewAddress),
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: Form(
        key: _addAddressKey,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(Labels.addressTitle, style: textStyle),
                const SizedBox(height: 5),
                CustomTextFormField(
                  focusNode: selectedAddressTypeFocusNode,
                  nextFocusNode: nameFocusNode,

                  validator: AppValidators.validateRequired,
                  textEditingController: selectedAddressType,
                  hint: Labels.addressTitle,
                  haveDropdownMenu: true,
                  dropdownMenuItems: addressTypes,
                ),
                const SizedBox(height: 10),
                Text(Labels.customerName, style: textStyle),
                const SizedBox(height: 5),
                CustomTextFormField(
                  validator: AppValidators.validateRequired,
                  textEditingController: nameController,
                  hint: Labels.customerName,
                  focusNode: nameFocusNode,
                  nextFocusNode: primaryPhoneFocusNode,
                ),
                const SizedBox(height: 10),
                Text(Labels.primaryPhoneNumber, style: textStyle),
                const SizedBox(height: 5),
                CustomTextFormField(
                  validator: AppValidators.validatePhone,
                  textEditingController: primaryPhoneNumber,
                  hint: Labels.primaryPhoneNumber,
                  focusNode: primaryPhoneFocusNode,
                  nextFocusNode: secondaryPhoneFocusNode,
                  textInputType: TextInputType.phone,
                ),
                const SizedBox(height: 10),
                Text(Labels.secondaryPhoneNumber, style: textStyle),
                const SizedBox(height: 5),
                CustomTextFormField(
                  validator: AppValidators.validatePhone,
                  textEditingController: secondaryPhoneNumber,
                  hint: Labels.secondaryPhoneNumber,
                  focusNode: secondaryPhoneFocusNode,
                  nextFocusNode: addressFocusNode,
                  textInputType: TextInputType.phone,
                ),
                const SizedBox(height: 10),
                Text(Labels.address, style: textStyle),
                const SizedBox(height: 5),
                CustomTextFormField(
                  validator: AppValidators.validateRequired,
                  textEditingController: addressController,
                  hint: Labels.address,
                  focusNode: addressFocusNode,
                  maxLineLength: 2,
                ),
                const SizedBox(height: 15),
                // Map picker button
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton.icon(
                    onPressed: () async {
                      // Navigate to map picker screen
                      final selectedLocation = await Navigator.push<Map<String, dynamic>>(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const MapPickerScreen(),
                        ),
                      );
                      
                      if (selectedLocation != null) {
                        // Update address field with selected location
                        addressController.text = selectedLocation['address'] ?? '';
                        setState(() {
                          // Update any location-related state if needed
                        });
                      }
                    },
                    icon: const Icon(Icons.location_on),
                    label: const Text('Pick Location from Map'),
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 30),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    minimumSize: Size(double.infinity, 50),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    backgroundColor: Theme.of(context).colorScheme.primary,
                  ),
                  onPressed: () async {
                    if (_addAddressKey.currentState!.validate()) {
                      // Create address model
                      final address = AddressModel(
                        title: selectedAddressType.text.trim(),
                        customerName: nameController.text.trim(),
                        primaryPhoneNumber: primaryPhoneNumber.text.trim(),
                        secondaryPhoneNumber: secondaryPhoneNumber.text.trim(),
                        address: addressController.text.trim(),
                        isDefault:
                            false, // Will be set to true if it's the first address
                      );

                      // Show loading dialog
                      showDialog(
                        context: context,
                        barrierDismissible: false,
                        builder:
                            (context) =>
                                Center(child: CircularProgressIndicator()),
                      );

                      try {
                        // Add address to user details and sync with server
                        final userRepo = UserRepository();
                        final success = await userRepo.addAddressAndSync(
                          address,
                        );

                        // Close loading dialog
                        Navigator.pop(context);

                        if (success) {
                          SnackBarHelper.showSuccess(context, Labels.addressSavedSuccessfully);
                          Navigator.pop(context);
                          context.read<CartBloc>().loadAddresses();
                        } else {
                          SnackBarHelper.showError(context, Labels.failedToSaveAddress);
                          // Show error message
                          // ScaffoldMessenger.of(context).showSnackBar(
                          //   SnackBar(
                          //     content: Text(
                          //       'Failed to save address. Please try again.',
                          //     ),
                          //     backgroundColor: Colors.red,
                          //   ),
                          // );
                        }
                      } catch (e) {
                        // Close loading dialog
                        Navigator.pop(context);
                        SnackBarHelper.showError(context, '${Labels.error}: ${e.toString()}');

                        // Show error message
                        // ScaffoldMessenger.of(context).showSnackBar(
                        //   SnackBar(
                        //     content: Text('Error: ${e.toString()}'),
                        //     backgroundColor: Colors.red,
                        //   ),
                        // );
                      }
                    }
                  },
                  child: Text(
                    Labels.saveAddress,
                    style: TextStyle(
                      fontFamily: FontFamily.fontsPoppinsSemiBold,
                      fontSize: 16,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
