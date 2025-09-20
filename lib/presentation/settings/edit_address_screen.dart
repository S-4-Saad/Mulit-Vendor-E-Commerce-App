import 'package:flutter/material.dart';

import '../../core/assets/font_family.dart';
import '../../core/utils/app_validators.dart';
import '../../core/utils/labels.dart';
import '../../widgets/custom_app_bar.dart';
import '../../widgets/custom_text_form_field.dart';
import '../../models/address_model.dart';
import '../../repositories/user_repository.dart';

class EditAddressScreen extends StatefulWidget {
  final AddressModel address;
  
  const EditAddressScreen({
    super.key,
    required this.address,
  });

  @override
  State<EditAddressScreen> createState() => _EditAddressScreenState();
}

class _EditAddressScreenState extends State<EditAddressScreen> {
  final _editAddressKey = GlobalKey<FormState>();
  final TextEditingController addressController = TextEditingController();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController primaryPhoneNumber = TextEditingController();
  final TextEditingController secondaryPhoneNumber = TextEditingController();
  final FocusNode nameFocusNode = FocusNode();
  final FocusNode primaryPhoneFocusNode = FocusNode();
  final FocusNode secondaryPhoneFocusNode = FocusNode();
  final FocusNode addressFocusNode = FocusNode();
  
  // Address type dropdown
  String? selectedAddressType;
  final List<String> addressTypes = ['Home Address', 'Office Address'];

  @override
  void initState() {
    super.initState();
    // Initialize form fields with existing address data
    selectedAddressType = widget.address.title;
    nameController.text = widget.address.customerName ?? '';
    primaryPhoneNumber.text = widget.address.primaryPhoneNumber ?? '';
    secondaryPhoneNumber.text = widget.address.secondaryPhoneNumber ?? '';
    addressController.text = widget.address.address ?? '';
  }

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
      appBar: CustomAppBar(title: 'Edit Address'),
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: Form(
        key: _editAddressKey,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(Labels.addressTitle, style: textStyle),
                const SizedBox(height: 5),
                DropdownButtonFormField<String>(
                  value: selectedAddressType,
                  decoration: InputDecoration(
                    hintText: 'Select Address Type',
                    hintStyle: TextStyle(
                      fontFamily: FontFamily.fontsPoppinsRegular,
                      color: Theme.of(context).colorScheme.onSecondary.withValues(alpha: 0.6),
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide(
                        color: Theme.of(context).colorScheme.outline.withValues(alpha: 0.3),
                      ),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide(
                        color: Theme.of(context).colorScheme.outline.withValues(alpha: 0.3),
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide(
                        color: Theme.of(context).colorScheme.primary,
                        width: 2,
                      ),
                    ),
                    filled: true,
                    fillColor: Theme.of(context).colorScheme.onPrimary,
                    contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  ),
                  dropdownColor: Theme.of(context).colorScheme.onPrimary,
                  items: addressTypes.map((String type) {
                    return DropdownMenuItem<String>(
                      value: type,
                      child: Text(
                        type,
                        style: TextStyle(
                          fontFamily: FontFamily.fontsPoppinsRegular,
                          color: Theme.of(context).colorScheme.onSecondary,
                        ),
                      ),
                    );
                  }).toList(),
                  onChanged: (String? newValue) {
                    setState(() {
                      selectedAddressType = newValue;
                    });
                  },
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please select address type';
                    }
                    return null;
                  },
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
                    if (_editAddressKey.currentState!.validate()) {
                      // Create updated address model
                      final updatedAddress = AddressModel(
                        id: widget.address.id, // Keep the same ID
                        title: selectedAddressType!,
                        customerName: nameController.text.trim(),
                        primaryPhoneNumber: primaryPhoneNumber.text.trim(),
                        secondaryPhoneNumber: secondaryPhoneNumber.text.trim(),
                        address: addressController.text.trim(),
                        isDefault: widget.address.isDefault, // Keep the same default status
                      );

                      // Show loading dialog
                      showDialog(
                        context: context,
                        barrierDismissible: false,
                        builder: (context) => Center(
                          child: CircularProgressIndicator(),
                        ),
                      );

                      try {
                        // Update address in user details and sync with server
                        final userRepo = UserRepository();
                        final success = await userRepo.updateAddress(updatedAddress);
                        
                        // Close loading dialog
                        Navigator.pop(context);
                        
                        if (success) {
                          // Show success message and go back
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('Address updated successfully!'),
                              backgroundColor: Colors.green,
                            ),
                          );
                          Navigator.pop(context);
                        } else {
                          // Show error message
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('Failed to update address. Please try again.'),
                              backgroundColor: Colors.red,
                            ),
                          );
                        }
                      } catch (e) {
                        // Close loading dialog
                        Navigator.pop(context);
                        
                        // Show error message
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('Error: ${e.toString()}'),
                            backgroundColor: Colors.red,
                          ),
                        );
                      }
                    }
                  },
                  child: Text('Update Address', style: TextStyle(
                    fontFamily: FontFamily.fontsPoppinsSemiBold,
                    fontSize: 16,
                    color: Colors.white,
                  )),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
