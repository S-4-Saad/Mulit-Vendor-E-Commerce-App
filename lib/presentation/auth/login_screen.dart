import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:speezu/core/assets/app_images.dart';
import 'package:speezu/core/assets/font_family.dart';
import 'package:speezu/core/utils/app_validators.dart';
import 'package:speezu/core/utils/labels.dart';
import 'package:speezu/core/utils/media_querry_extention.dart';
import 'package:speezu/core/utils/snackbar_helper.dart';
import 'package:speezu/widgets/custom_text_form_field.dart';

import '../../routes/route_names.dart';
import '../../widgets/auth_loader.dart';
import '../../widgets/login_custom_elevated_button.dart';
import 'bloc/auth_bloc.dart';
import 'bloc/auth_event.dart';
import 'bloc/auth_state.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final GlobalKey<FormState> _loginFormKey = GlobalKey<FormState>();
  final FocusNode emailFocusNode = FocusNode();
  final FocusNode passwordFocusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    if (kDebugMode) {
      emailController.text = "customer@gmail.com";
      passwordController.text = "12345678";
    }
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    emailFocusNode.dispose();
    passwordFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: LayoutBuilder(
        builder: (context, constraints) {
          final isTablet = constraints.maxWidth >= 600;
          final isLargeTablet = constraints.maxWidth >= 900;

          return _buildResponsiveLayout(
            context,
            constraints,
            isTablet,
            isLargeTablet,
          );
        },
      ),
    );
  }

  Widget _buildResponsiveLayout(
      BuildContext context,
      BoxConstraints constraints,
      bool isTablet,
      bool isLargeTablet,
      ) {
    if (isLargeTablet) {
      // Large Tablet Layout - Side by side
      return _buildLargeTabletLayout(context);
    } else if (isTablet) {
      // Tablet Layout - Centered with more space
      return _buildTabletLayout(context);
    } else {
      // Mobile Layout - Original design enhanced
      return _buildMobileLayout(context);
    }
  }

  // Mobile Layout (Enhanced)
  Widget _buildMobileLayout(BuildContext context) {
    return SingleChildScrollView(
      child: SizedBox(
        height: MediaQuery.of(context).size.height,
        child: Stack(
          children: [
            // Background Gradient
            Container(
              height: context.heightPct(.40),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Theme.of(context).colorScheme.primary,
                    Theme.of(context).colorScheme.primary.withOpacity(0.8),
                  ],
                ),
              ),
            ),

            // Content
            SafeArea(
              child: Column(
                children: [
                  SizedBox(height: context.heightPct(.06)),
                  // Logo Section
                  _buildLogoSection(context, isMobile: true),
                  SizedBox(height: context.heightPct(.04)),

                  // Login Form Card
                  Expanded(
                    child: Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.onPrimary,
                        borderRadius: const BorderRadius.vertical(
                          top: Radius.circular(32),
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 20,
                            offset: const Offset(0, -5),
                          ),
                        ],
                      ),
                      child: SingleChildScrollView(
                        padding: EdgeInsets.all(context.widthPct(.08)),
                        child: Column(
                          children: [
                            // Drag Handle
                            Container(
                              width: 40,
                              height: 4,
                              decoration: BoxDecoration(
                                color: Colors.grey.shade300,
                                borderRadius: BorderRadius.circular(2),
                              ),
                            ),
                            SizedBox(height: context.heightPct(.03)),

                            _buildLoginForm(context, maxWidth: double.infinity),

                            SizedBox(height: context.heightPct(.02)),
                            _buildBottomLinks(context),
                          ],
                        ),
                      ),
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

  // Tablet Layout
  Widget _buildTabletLayout(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Theme.of(context).colorScheme.primary.withOpacity(0.1),
            Theme.of(context).colorScheme.primary.withOpacity(0.05),
          ],
        ),
      ),
      child: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(32),
            child: Container(
              constraints: const BoxConstraints(maxWidth: 500),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.onPrimary,
                borderRadius: BorderRadius.circular(32),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 30,
                    offset: const Offset(0, 10),
                  ),
                ],
              ),
              child: Padding(
                padding: const EdgeInsets.all(40),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    _buildLogoSection(context, isMobile: false),
                    const SizedBox(height: 40),
                    _buildLoginForm(context, maxWidth: double.infinity),
                    const SizedBox(height: 24),
                    _buildBottomLinks(context),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  // Large Tablet Layout (Side by side)
  Widget _buildLargeTabletLayout(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Theme.of(context).colorScheme.primary.withOpacity(0.05),
            Theme.of(context).colorScheme.primary.withOpacity(0.1),
          ],
        ),
      ),
      child: SafeArea(
        child: Center(
          child: Container(
            constraints: const BoxConstraints(maxWidth: 1200),
            margin: const EdgeInsets.all(32),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.onPrimary,
              borderRadius: BorderRadius.circular(32),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 30,
                  offset: const Offset(0, 10),
                ),
              ],
            ),
            child: Row(
              children: [
                // Left Side - Branding
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.all(60),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          Theme.of(context).colorScheme.primary,
                          Theme.of(context).colorScheme.primary.withOpacity(0.8),
                        ],
                      ),
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(32),
                        bottomLeft: Radius.circular(32),
                      ),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset(
                          AppImages.speezuLogo,
                          height: 120,
                        ),
                        const SizedBox(height: 32),
                        Text(
                          Labels.letsStartWithLogin,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.onPrimary,
                            fontSize: 28,
                            fontFamily: FontFamily.fontsPoppinsExtraBold,
                          ),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          Labels.welcomeBackPleaseLoginToContinue,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.onPrimary.withOpacity(0.9),
                            fontSize: 16,
                            fontFamily: FontFamily.fontsPoppinsRegular,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                // Right Side - Form
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(60),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Text(
                          Labels.signIn,
                          style: TextStyle(
                            fontSize: 32,
                            fontFamily: FontFamily.fontsPoppinsExtraBold,
                            color: Theme.of(context).colorScheme.onSurface,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          Labels.enterYourCredentialsToAccessYourAccount,
                          style: TextStyle(
                            fontSize: 14,
                            fontFamily: FontFamily.fontsPoppinsRegular,
                            color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
                          ),
                        ),
                        const SizedBox(height: 40),
                        _buildLoginForm(context, maxWidth: double.infinity),
                        const SizedBox(height: 24),
                        _buildBottomLinks(context),
                      ],
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

  Widget _buildLogoSection(BuildContext context, {required bool isMobile}) {
    return Column(
      children: [
        Image.asset(
          AppImages.speezuLogo,
          height: isMobile ? 60 : 80,
        ),
        SizedBox(height: isMobile ? 16 : 24),
        Text(
          Labels.letsStartWithLogin,
          textAlign: TextAlign.center,
          style: TextStyle(
            color: isMobile
                ? Theme.of(context).colorScheme.onPrimary
                : Theme.of(context).colorScheme.onSurface,
            fontSize: isMobile ? 24 : 28,
            fontFamily: FontFamily.fontsPoppinsExtraBold,
          ),
        ),
        if (!isMobile) ...[
          const SizedBox(height: 8),
          Text(
            Labels.welcomeBackPleaseLoginToContinue,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
              fontSize: 14,
              fontFamily: FontFamily.fontsPoppinsRegular,
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildLoginForm(BuildContext context, {required double maxWidth}) {
    return Form(
      key: _loginFormKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Email Field
          Text(
            '${Labels.email}',
            style: TextStyle(
              fontSize: 14,
              fontFamily: FontFamily.fontsPoppinsSemiBold,
              color: Theme.of(context).colorScheme.onSurface,
            ),
          ),
          const SizedBox(height: 8),
          CustomTextFormField(
            validator: AppValidators.validateEmail,
            textEditingController: emailController,
            hint: 'example@gmail.com',
            focusNode: emailFocusNode,
            nextFocusNode: passwordFocusNode,
            textInputType: TextInputType.emailAddress,
          ),
          const SizedBox(height: 20),

          // Password Field
          Text(
            '${Labels.password}',
            style: TextStyle(
              fontSize: 14,
              fontFamily: FontFamily.fontsPoppinsSemiBold,
              color: Theme.of(context).colorScheme.onSurface,
            ),
          ),
          const SizedBox(height: 8),
          CustomTextFormField(
            validator: AppValidators.validatePassword,
            textEditingController: passwordController,
            obscureText: true,
            hint: '••••••••',
            focusNode: passwordFocusNode,
          ),

          const SizedBox(height: 12),

          // Forgot Password Link
          Align(
            alignment: Alignment.centerRight,
            child: TextButton(
              onPressed: () {
                Navigator.pushNamed(context, RouteNames.forgotPassword);
              },
              style: TextButton.styleFrom(
                padding: EdgeInsets.zero,
                minimumSize: const Size(0, 0),
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              ),
              child: Text(
                Labels.iForgotPassword,
                style: TextStyle(
                  color: Theme.of(context).colorScheme.primary,
                  fontSize: 13,
                  fontFamily: FontFamily.fontsPoppinsMedium,
                ),
              ),
            ),
          ),

          const SizedBox(height: 24),

          // Login Button
          BlocConsumer<AuthBloc, AuthState>(
            builder: (context, state) => state.loginStatus == LoginStatus.loading
                ? const AuthLoader()
                : LoginCustomElevatedButton(
              title: Labels.login,
              onPressed: () {
                if (_loginFormKey.currentState!.validate()) {
                  context.read<AuthBloc>().add(
                    LoginEvent(
                      email: emailController.text.trim(),
                      password: passwordController.text.trim(),
                    ),
                  );
                }
              },
            ),
            listener: (context, state) {
              if (state.loginStatus == LoginStatus.success) {
                Navigator.pushReplacementNamed(
                  context,
                  RouteNames.navBarScreen,
                );
              } else if (state.loginStatus == LoginStatus.error) {
                SnackBarHelper.showError(context, state.message);
              }
            },
          ),

          if (kDebugMode) ...[
            const SizedBox(height: 12),
            Center(
              child: TextButton(
                onPressed: () => Navigator.pushReplacementNamed(
                  context,
                  RouteNames.navBarScreen,
                ),
                child:  Text(
                Labels.skip,
                  style: TextStyle(
                    color: Colors.red,
                    fontSize: 12,
                  ),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildBottomLinks(BuildContext context) {
    return Column(
      children: [
        const Divider(),
        const SizedBox(height: 16),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "${Labels.donHaveAnAccount} ",
              style: TextStyle(
                color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
                fontSize: 14,
                fontFamily: FontFamily.fontsPoppinsRegular,
              ),
            ),
            TextButton(
              onPressed: () {
                Navigator.pushNamed(context, RouteNames.signUp);
              },
              style: TextButton.styleFrom(
                padding: EdgeInsets.zero,
                minimumSize: const Size(0, 0),
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              ),
              child: Text(
                Labels.signUp,
                style: TextStyle(
                  color: Theme.of(context).colorScheme.primary,
                  fontSize: 14,
                  fontFamily: FontFamily.fontsPoppinsSemiBold,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}