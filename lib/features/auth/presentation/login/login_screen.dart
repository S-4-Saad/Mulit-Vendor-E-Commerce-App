import 'package:flutter/material.dart';
import 'package:speezu/core/assets/app_images.dart';
import 'package:speezu/core/assets/font_family.dart';
import 'package:speezu/core/utils/app_validators.dart';
import 'package:speezu/core/utils/labels.dart';
import 'package:speezu/core/utils/media_querry_extention.dart';
import 'package:speezu/widgets/custom_text_form_field.dart';

import '../../../../widgets/login_custom_elevated_button.dart';

class LoginScreen extends StatelessWidget {
  LoginScreen({super.key});
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  final GlobalKey<FormState> _loginFormKey = GlobalKey<FormState>();
  FocusNode emailFocusNode = FocusNode();
  FocusNode passwordFocusNode = FocusNode();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: Stack(
        alignment: Alignment.center,
        children: [
          SizedBox(
            height: double.infinity,
            width: double.infinity,
            child: Column(
              children: [
                Expanded(
                  flex: 1,
                  child: Container(
                    color: Theme.of(context).colorScheme.primary,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      // crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            SizedBox(height: context.heightPct(.1)),
                            Image.asset(
                              AppImages.speezuLogo,
                              height: context.widthPct(.2),
                            ),
                            SizedBox(height: context.heightPct(.015)),
                            Text(
                              Labels.letsStartWithLogin,
                              style: TextStyle(
                                color: Theme.of(context).colorScheme.onPrimary,
                                fontSize: context.scaledFont(20),
                                fontFamily: FontFamily.fontsPoppinsExtraBold,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: Container(
                    color: Theme.of(context).scaffoldBackgroundColor,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        TextButton(
                          onPressed: () {},
                          child: Text(
                            Labels.iForgotPassword,
                            style: TextStyle(
                              color: Theme.of(context).colorScheme.secondary,
                              fontSize: context.scaledFont(13),
                              fontFamily: FontFamily.fontsPoppinsRegular,
                            ),
                          ),
                        ),
                        TextButton(
                          onPressed: () {},
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
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            top: context.heightPct(.26),
            child: Container(
              padding: EdgeInsets.all(20),

              width: context.widthPct(.8),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.onPrimary,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Theme.of(
                      context,
                    ).colorScheme.outline.withValues(alpha: 0.5),
                    blurRadius: 10,
                    offset: Offset(0, 5),
                  ),
                ],
              ),
              child: Form(
                key: _loginFormKey,
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
                      focusNode: emailFocusNode,
                      nextFocusNode: passwordFocusNode,
                      textInputType: TextInputType.emailAddress,
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
                    LoginCustomElevatedButton(
                      title: Labels.login,
                      onPressed: () {
                        if (_loginFormKey.currentState!.validate()) {
                          // Perform login action
                        }
                      },
                    ),
                    SizedBox(height: context.heightPct(.02)),
                    Center(
                      child: TextButton(
                        onPressed: () {},
                        child: Text(
                          Labels.skip,
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.secondary,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
