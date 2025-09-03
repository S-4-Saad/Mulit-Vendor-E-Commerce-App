import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:speezu/core/utils/media_querry_extention.dart';
import 'package:speezu/core/utils/snackbar_helper.dart';
import '../../core/assets/app_images.dart';
import '../../core/assets/font_family.dart';
import '../../core/utils/app_validators.dart';
import '../../core/utils/labels.dart';
import '../../routes/route_names.dart';
import '../../widgets/auth_loader.dart';
import '../../widgets/custom_text_form_field.dart';
import '../../widgets/login_custom_elevated_button.dart';
import 'bloc/auth_bloc.dart';
import 'bloc/auth_event.dart';
import 'bloc/auth_state.dart';

class SignUpScreen extends StatefulWidget {
  SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  TextEditingController fullNameController = TextEditingController();
  TextEditingController phoneNumberController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  final GlobalKey<FormState> _signUpFormKey = GlobalKey<FormState>();
  FocusNode fullNameFocusNode = FocusNode();
  FocusNode phoneNumberFocusNode = FocusNode();
  FocusNode emailFocusNode = FocusNode();
  FocusNode passwordFocusNode = FocusNode();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // resizeToAvoidBottomInset: true,
      // extendBody: true,
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      bottomNavigationBar: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          TextButton(
            onPressed: () {
              // Navigate to Login Screen
              Navigator.pushReplacementNamed(context, RouteNames.login);
            },
            child: Text(
              Labels.alreadyHaveAnAccount,
              style: TextStyle(
                color: Theme.of(context).colorScheme.secondary,
                fontSize: context.scaledFont(13),
                fontFamily: FontFamily.fontsPoppinsRegular,
              ),
            ),
          ),
          SizedBox(height: context.heightPct(.02)),
        ],
      ),
      body: Stack(
        // alignment: Alignment.topCenter,
        children: [
          Column(
            children: [
              Container(
                width: double.infinity,
                height: context.heightPct(.35),
                color: Theme.of(context).colorScheme.primary,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(height: context.heightPct(.1)),
                    Image.asset(
                      AppImages.speezuLogo,
                      height: context.widthPct(.2),
                    ),
                    SizedBox(height: context.heightPct(.015)),
                    Text(
                      Labels.letsStartWithRegister,
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.onPrimary,
                        fontSize: context.scaledFont(18),
                        fontFamily: FontFamily.fontsPoppinsExtraBold,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          SingleChildScrollView(
            padding: EdgeInsets.only(
              top: context.heightPct(.27),
              // bottom: MediaQuery.of(context).viewInsets.bottom,
            ),
            child: Center(
              child: Container(
                width: context.widthPct(.8),
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.onPrimary,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Theme.of(
                        context,
                      ).colorScheme.outline.withValues(alpha: 0.5),
                      blurRadius: 10,
                      offset: const Offset(0, 5),
                    ),
                  ],
                ),
                child: Form(
                  key: _signUpFormKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: context.heightPct(.009)),
                      Text(
                        '${Labels.fullName}:',
                        style: TextStyle(
                          fontSize: context.scaledFont(13),
                          fontFamily: FontFamily.fontsPoppinsRegular,
                          color: Theme.of(context).colorScheme.onSurface,
                        ),
                      ),
                      SizedBox(height: context.heightPct(.005)),
                      CustomTextFormField(
                        validator: AppValidators.validateRequired,
                        textEditingController: fullNameController,
                        hint: Labels.fullName,
                        focusNode: fullNameFocusNode,
                        nextFocusNode: emailFocusNode,
                      ),
                      SizedBox(height: context.heightPct(.01)),

                      Text(
                        '${Labels.email}:',
                        style: TextStyle(
                          fontSize: context.scaledFont(13),
                          fontFamily: FontFamily.fontsPoppinsRegular,
                          color: Theme.of(context).colorScheme.onSurface,
                        ),
                      ),
                      SizedBox(height: context.heightPct(.005)),
                      CustomTextFormField(
                        validator: AppValidators.validateEmail,
                        textEditingController: emailController,
                        hint: 'example@gmail.com',
                        focusNode: emailFocusNode,
                        nextFocusNode: phoneNumberFocusNode,
                        textInputType: TextInputType.emailAddress,
                      ),
                      SizedBox(height: context.heightPct(.01)),

                      Text(
                        '${Labels.phoneNumber}:',
                        style: TextStyle(
                          fontSize: context.scaledFont(13),
                          fontFamily: FontFamily.fontsPoppinsRegular,
                          color: Theme.of(context).colorScheme.onSurface,
                        ),
                      ),
                      SizedBox(height: context.heightPct(.005)),
                      CustomTextFormField(
                        validator: AppValidators.validateNumber,
                        textEditingController: phoneNumberController,
                        textInputType: TextInputType.phone,
                        hint: '+123 456 7890',
                        focusNode: phoneNumberFocusNode,
                        nextFocusNode: passwordFocusNode,
                      ),
                      SizedBox(height: context.heightPct(.01)),
                      Text(
                        '${Labels.password}:',
                        style: TextStyle(
                          fontSize: context.scaledFont(13),
                          fontFamily: FontFamily.fontsPoppinsRegular,
                          color: Theme.of(context).colorScheme.onSurface,
                        ),
                      ),
                      SizedBox(height: context.heightPct(.005)),
                      CustomTextFormField(
                        validator: AppValidators.validatePassword,
                        textEditingController: passwordController,
                        obscureText: true,
                        hint: '********',
                        focusNode: passwordFocusNode,
                      ),
                      SizedBox(height: context.heightPct(.04)),
                      BlocConsumer<AuthBloc, AuthState>(
                        builder: (context, state) {
                          return state.signUpStatus == SignUpStatus.loading
                              ? const Center(child: AuthLoader())
                              : LoginCustomElevatedButton(
                                title: Labels.register,
                                onPressed: () {
                                  if (_signUpFormKey.currentState!.validate()) {
                                    context.read<AuthBloc>().add(
                                      RegisterUserEvent(
                                        email: emailController.text,
                                        password: passwordController.text,
                                        username: fullNameController.text,
                                        phone: phoneNumberController.text,
                                      ),
                                    );
                                    // Perform login action
                                  }
                                },
                              );
                        },
                        listener: (context, state) {
                          if (state.signUpStatus == SignUpStatus.success) {
                            Navigator.pushReplacementNamed(
                              context,
                              RouteNames.login,
                            );
                            SnackBarHelper.showSuccess(context, state.message);
                          } else if (state.signUpStatus == SignUpStatus.error) {
                            SnackBarHelper.showError(context, state.message);
                          }
                        },
                      ),
                      SizedBox(height: context.heightPct(.02)),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
