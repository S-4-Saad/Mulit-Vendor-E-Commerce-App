import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:speezu/core/utils/media_querry_extention.dart';
import 'package:speezu/widgets/auth_loader.dart';
import '../../core/assets/app_images.dart';
import '../../core/assets/font_family.dart';
import '../../core/utils/app_validators.dart';
import '../../core/utils/labels.dart';
import '../../core/utils/snackbar_helper.dart';
import '../../routes/route_names.dart';
import '../../widgets/custom_text_form_field.dart';
import '../../widgets/login_custom_elevated_button.dart';
import 'bloc/auth_bloc.dart';
import 'bloc/auth_event.dart';
import 'bloc/auth_state.dart';

class ForgotPasswordScreen extends StatefulWidget {
  ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  TextEditingController emailController = TextEditingController();

  final GlobalKey<FormState> _forgotPasswordFormKey = GlobalKey<FormState>();
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
              Navigator.pop(context);
            },
            child: Text(
              Labels.iRememberMyPasswordReturnToLogin,
              style: TextStyle(
                color: Theme.of(context).colorScheme.secondary,
                fontSize: context.scaledFont(13),
                fontFamily: FontFamily.fontsPoppinsRegular,
              ),
            ),
          ),
          TextButton(
            onPressed: () {
              Navigator.pushReplacementNamed(context, RouteNames.signUp);
            },
            child: Text(
              Labels.doNotHaveAnAccount,
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
                  key: _forgotPasswordFormKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: context.heightPct(.009)),

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
                        textInputType: TextInputType.emailAddress,
                      ),
                      SizedBox(height: context.heightPct(.02)),

                      BlocConsumer<AuthBloc, AuthState>(
                        builder:
                            (context, state) =>
                                state.forgotPasswordStatus ==
                                        ForgotPasswordStatus.loading
                                    ? AuthLoader()
                                    : LoginCustomElevatedButton(
                                      title: Labels.sendLink,
                                      onPressed: () {
                                        if (_forgotPasswordFormKey.currentState!
                                            .validate()) {
                                          // Perform login action
                                          context.read<AuthBloc>().add(
                                            ResetPasswordEvent(
                                              email:
                                                  emailController.text.trim(),
                                            ),
                                          );
                                        }
                                      },
                                    ),
                        listener: (context, state) {
                          if (state.forgotPasswordStatus ==
                              ForgotPasswordStatus.success) {
                            // Navigate to the next screen or show success message
                            Navigator.pushReplacementNamed(
                              context,
                              RouteNames.login,
                            );
                            SnackBarHelper.showSuccess(context, state.message);
                          } else if (state.forgotPasswordStatus ==
                              ForgotPasswordStatus.error) {
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
