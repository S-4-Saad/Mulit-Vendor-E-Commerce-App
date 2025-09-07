import 'package:flutter/material.dart';
import 'package:speezu/routes/route_names.dart';
import '../presentation/auth/forgot_password_screen.dart';
import '../presentation/auth/login_screen.dart';
import '../presentation/auth/sign_up_screen.dart';
import '../presentation/faqs/faqs_screen.dart';
import '../presentation/home/home_screen.dart';
import '../presentation/languages/languages_screen.dart';
import '../presentation/nav_bar_screen/nav_bar_screen.dart';
import '../presentation/settings/payment/card_info_add_screen.dart';
import '../presentation/settings/profile_info_screen.dart';
import '../presentation/settings/settings_screen.dart';
import '../presentation/spalsh/splash_screen.dart';

class AppRoutes {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case RouteNames.splash:
        return MaterialPageRoute(builder: (_) => const SplashScreen());
      case RouteNames.login:
        return MaterialPageRoute(builder: (_) => LoginScreen());
      case RouteNames.signUp:
        return MaterialPageRoute(builder: (_) => SignUpScreen());
      case RouteNames.forgotPassword:
        return MaterialPageRoute(builder: (_) => ForgotPasswordScreen());
      case RouteNames.home:
        return MaterialPageRoute(builder: (_) => HomeScreen());
      case RouteNames.navBarScreen:
        return MaterialPageRoute(builder: (_) => NavBarScreen());
      case RouteNames.languagesScreen:
        return MaterialPageRoute(builder: (_) => LanguageScreen());
      case RouteNames.settingsScreen:
        return MaterialPageRoute(builder: (_) => SettingsScreen());
      case RouteNames.cardInfoAddScreen:
        return MaterialPageRoute(builder: (_) => CardInfoAddScreen());

      case RouteNames.faqsScreen:
        return MaterialPageRoute(builder: (_) => FaqsScreen());
      case RouteNames.profileInfoScreen:
        return MaterialPageRoute(builder: (_) => ProfileInfoScreen());
      default:
        return MaterialPageRoute(
          builder:
              (_) =>
                  const Scaffold(body: Center(child: Text('No route found'))),
        );
    }
  }
}
