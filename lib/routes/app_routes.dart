import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:speezu/routes/route_names.dart';
import '../presentation/auth/forgot_password_screen.dart';
import '../presentation/auth/login_screen.dart';
import '../presentation/auth/sign_up_screen.dart';
import '../presentation/home/home_screen.dart';
import '../presentation/spalsh/splash_screen.dart';

class AppRoutes {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case RouteNames.splash:
        return MaterialPageRoute(builder: (_) => const SplashScreen());
      case RouteNames.login:
        return MaterialPageRoute(builder: (_) =>  LoginScreen());
      case RouteNames.signUp:
        return MaterialPageRoute(builder: (_) =>  SignUpScreen(),);
      case RouteNames.forgotPassword:
        return MaterialPageRoute(builder: (_) =>  ForgotPasswordScreen());
      case RouteNames.home:
        return MaterialPageRoute(builder: (_) =>  HomeScreen());

      default:
        return MaterialPageRoute(
          builder: (_) => const Scaffold(
            body: Center(child: Text('No route found')),
          ),
        );
    }
  }

}
