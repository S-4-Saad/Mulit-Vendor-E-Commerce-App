import 'package:flutter/material.dart';
import 'package:speezu/presentation/cart/cart_screen.dart';
import 'package:speezu/presentation/category/category_screen.dart';
import 'package:speezu/presentation/cart/check_out_screen.dart';
import 'package:speezu/presentation/product_detail/product_detail_screen.dart';
import 'package:speezu/presentation/settings/add_address_screen.dart';
import 'package:speezu/presentation/settings/address_book_screen.dart';
import 'package:speezu/presentation/settings/edit_profile_screen.dart';
import 'package:speezu/presentation/shop_screen/shop_navbar_screen.dart';
import 'package:speezu/routes/route_names.dart';
import '../presentation/auth/forgot_password_screen.dart';
import '../presentation/auth/login_screen.dart';
import '../presentation/auth/sign_up_screen.dart';
import '../presentation/faqs/faqs_screen.dart';
import '../presentation/home/home_screen.dart';
import '../presentation/languages/languages_screen.dart';
import '../presentation/nav_bar_screen/nav_bar_screen.dart';
import '../presentation/settings/payment/card_info_add_screen.dart';
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

      case RouteNames.categoryScreen:
        final args = settings.arguments as Map<String, dynamic>? ?? {};
        final String categoryName = args['categoryName'] ?? 'Categories';
        final int categoryId = args['categoryId'] ?? 1;

        return MaterialPageRoute(
          builder: (_) => CategoryScreen(
            categoryName: categoryName,
            categoryId: categoryId,
          ),
        );

      case RouteNames.shopNavBarScreen:
        final int? storeId = settings.arguments as int?;
        return MaterialPageRoute(builder: (_) => ShopNavbarScreen(storeId: storeId));
      case RouteNames.productScreen:
        final String? productId = settings.arguments as String?;
        return MaterialPageRoute(builder: (_) => ProductDetailScreen(productId: productId ?? '1'));
      case RouteNames.cartScreen:
        return MaterialPageRoute(builder: (_) => CartScreen());
      case RouteNames.checkOutScreen:
        return MaterialPageRoute(builder: (_) => CheckOutScreen());
      case RouteNames.addAddressScreen:
        return MaterialPageRoute(builder: (_) => AddNewAddressScreen());
      case RouteNames.editProfileScreen:
        return MaterialPageRoute(builder: (_) => EditProfileScreen());
        case RouteNames.addressBookScreen:
        return MaterialPageRoute(builder: (_) => AddressBookScreen());
      default:
        return MaterialPageRoute(
          builder:
              (_) =>
                  const Scaffold(body: Center(child: Text('No route found'))),
        );
    }
  }
}
