import 'package:flutter/material.dart';
import 'package:speezu/core/assets/font_family.dart';
import 'package:speezu/core/services/api_services.dart';
import 'package:speezu/core/services/urls.dart';
import 'package:speezu/core/utils/app_validators.dart';
import 'package:speezu/core/utils/labels.dart';
import 'package:speezu/core/utils/snackbar_helper.dart';
import 'package:speezu/widgets/auth_loader.dart';
import 'package:speezu/widgets/custom_app_bar.dart';
import 'package:speezu/widgets/custom_text_form_field.dart';
import 'package:speezu/widgets/login_custom_elevated_button.dart';

class ChangePasswordScreen extends StatefulWidget {
  const ChangePasswordScreen({super.key});

  @override
  State<ChangePasswordScreen> createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
  final TextEditingController currentPasswordController =
      TextEditingController();
  final TextEditingController newPasswordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();
  final FocusNode currentPasswordFocusNode = FocusNode();
  final FocusNode newPasswordFocusNode = FocusNode();
  final FocusNode confirmPasswordFocusNode = FocusNode();
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;

  @override
  void dispose() {
    currentPasswordController.dispose();
    newPasswordController.dispose();
    confirmPasswordController.dispose();
    currentPasswordFocusNode.dispose();
    newPasswordFocusNode.dispose();
    confirmPasswordFocusNode.dispose();
    super.dispose();
  }

  Future<void> _changePassword() async {
    // Dismiss keyboard
    FocusScope.of(context).unfocus();

    if (!_formKey.currentState!.validate()) {
      return;
    }

    if (newPasswordController.text != confirmPasswordController.text) {
      SnackBarHelper.showError(context, Labels.passwordsDoNotMatch);
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      await ApiService.postMethod(
        apiUrl: changePasswordUrl,
        authHeader: true,
        postData: {
          "current_password": currentPasswordController.text,
          "new_password": newPasswordController.text,
          "new_password_confirmation": confirmPasswordController.text,
        },
        executionMethod: (bool success, dynamic responseData) async {
          if (mounted) {
            setState(() {
              _isLoading = false;
            });

            if (success) {
              SnackBarHelper.showSuccess(
                context,
                responseData['message'] ?? 'Password changed successfully!',
              );
              // Clear the form fields after success
              currentPasswordController.clear();
              newPasswordController.clear();
              confirmPasswordController.clear();
            } else {
              SnackBarHelper.showError(
                context,
                _extractErrorMessage(responseData),
              );
            }
          }
        },
      );
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
        SnackBarHelper.showError(context, 'Failed to change password: $e');
      }
    }
  }

  String _extractErrorMessage(dynamic responseData) {
    // Check for direct message (handles format: {"success":false,"message":"..."})
    if (responseData is Map && responseData.containsKey('message')) {
      final message = responseData['message'];
      // Handle both String and other types that can be converted to String
      if (message != null) {
        final messageStr = message.toString();
        if (messageStr.isNotEmpty && messageStr != 'null') {
          return messageStr;
        }
      }
    }

    // Check for errors object (validation errors)
    if (responseData is Map && responseData.containsKey('errors')) {
      final errors = responseData['errors'];

      // If errors is a Map, extract first error message
      if (errors is Map) {
        for (var errorList in errors.values) {
          if (errorList is List && errorList.isNotEmpty) {
            return errorList.first.toString();
          }
        }
        // If Map but not in list format, convert to string
        final errorMsg = errors.toString();
        if (errorMsg.isNotEmpty) {
          return errorMsg;
        }
      }

      // If errors is a string or list
      if (errors is String && errors.isNotEmpty) {
        return errors;
      }
      if (errors is List && errors.isNotEmpty) {
        return errors.first.toString();
      }
    }

    // Check for error key
    if (responseData is Map && responseData.containsKey('error')) {
      final error = responseData['error'];
      if (error != null) {
        final errorStr = error.toString();
        if (errorStr.isNotEmpty && errorStr != 'null') {
          return errorStr;
        }
      }
    }

    // Default error message
    return 'Failed to change password';
  }

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
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Form(
            key: _formKey,
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
                _isLoading
                    ? AuthLoader()
                    : LoginCustomElevatedButton(
                      title: Labels.changePassword,
                      onPressed: _changePassword,
                    ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
