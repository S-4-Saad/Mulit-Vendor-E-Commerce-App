import 'package:flutter/material.dart';

import '../../core/assets/font_family.dart';
import '../../core/utils/app_validators.dart';
import '../../core/utils/labels.dart';
import '../../widgets/custom_app_bar.dart';
import '../../widgets/custom_text_form_field.dart';

class AddNewAddressScreen extends StatelessWidget {
  AddNewAddressScreen({super.key});
  final _addAddressKey = GlobalKey<FormState>();
  final TextEditingController addressController = TextEditingController();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController addressTitleController = TextEditingController();
  final TextEditingController primaryPhoneNumber = TextEditingController();
  final TextEditingController secondaryPhoneNumber = TextEditingController();
  final FocusNode nameFocusNode = FocusNode();
  final FocusNode addressTitleFocusNode = FocusNode();
  final FocusNode primaryPhoneFocusNode = FocusNode();
  final FocusNode secondaryPhoneFocusNode = FocusNode();
  final FocusNode addressFocusNode = FocusNode();

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
                  validator: AppValidators.validateRequired,
                  textEditingController: addressTitleController,
                  hint: Labels.addressTitle,
                  focusNode: addressTitleFocusNode,
                  nextFocusNode: nameFocusNode,
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
                  onPressed: () {
                    if (_addAddressKey.currentState!.validate()) {
                      print(addressTitleController.text);
                      print(nameController.text);
                      print(primaryPhoneNumber.text);
                      print(secondaryPhoneNumber.text);
                      print(addressController.text);

                      // Process data.
                      Navigator.pop(context);
                    }
                  },
                  child:  Text(Labels.saveAddress,style: TextStyle(
                    fontFamily: FontFamily.fontsPoppinsSemiBold,
                    fontSize: 16,
                    color: Colors.white,

                  ),),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
