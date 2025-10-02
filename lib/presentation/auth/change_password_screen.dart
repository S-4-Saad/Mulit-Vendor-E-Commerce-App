import 'package:flutter/material.dart';
import 'package:speezu/core/assets/font_family.dart';
import 'package:speezu/core/utils/app_validators.dart';
import 'package:speezu/core/utils/labels.dart';
import 'package:speezu/core/utils/snackbar_helper.dart';
import 'package:speezu/widgets/custom_app_bar.dart';
import 'package:speezu/widgets/custom_text_form_field.dart';
import 'package:speezu/widgets/login_custom_elevated_button.dart';

class ChangePasswordScreen extends StatelessWidget {
  ChangePasswordScreen({super.key});
  final TextEditingController currentPasswordController =
      TextEditingController();
  final TextEditingController newPasswordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();
  final FocusNode currentPasswordFocusNode = FocusNode();
  final FocusNode newPasswordFocusNode = FocusNode();
  final FocusNode confirmPasswordFocusNode = FocusNode();
  final _forgotPasswordFromKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    TextStyle textStyle = TextStyle(
      fontSize: 16,
      color: Theme.of(context).colorScheme.onSecondary,
      fontFamily: FontFamily.fontsPoppinsSemiBold,
    );
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: CustomAppBar(title: Labels.changePassword),
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Form(
          key: _forgotPasswordFromKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(Labels.currentPassword, style: textStyle),
              SizedBox(height: 5),
              CustomTextFormField(
                validator: AppValidators.validateRequired,
                textEditingController: currentPasswordController,
                focusNode: currentPasswordFocusNode,
                hint: Labels.enterCurrentPassword,
                nextFocusNode: newPasswordFocusNode,
                obscureText: true,
              ),
              SizedBox(height: 10),
              Text(Labels.newPassword, style: textStyle),
              SizedBox(height: 5),
              CustomTextFormField(
                validator: AppValidators.validateRequired,
                textEditingController: newPasswordController,
                focusNode: newPasswordFocusNode,
                nextFocusNode: confirmPasswordFocusNode,
                hint: Labels.enterNewPassword,
                obscureText: true,
              ),
              SizedBox(height: 10),
              Text(Labels.confirmNewPassword, style: textStyle),
              SizedBox(height: 5),
              CustomTextFormField(
                validator: AppValidators.validateRequired,
                textEditingController: confirmPasswordController,
                focusNode: confirmPasswordFocusNode,
                hint: Labels.enterConfirmPassword,
                obscureText: true,
              ),
              SizedBox(height: 40),
              LoginCustomElevatedButton(
                title: Labels.changePassword,
                onPressed: () {
                  if (_forgotPasswordFromKey.currentState!.validate()) {
                    if (newPasswordController.text !=
                        confirmPasswordController.text) {
                      SnackBarHelper.showError(
                        context,
                        Labels.passwordsDoNotMatch,
                      );
                      return;
                    }
                    print("Change Password");
                    print(currentPasswordController);
                    print(newPasswordController);
                    print(confirmPasswordController);
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
