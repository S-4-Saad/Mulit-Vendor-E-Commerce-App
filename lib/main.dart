import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:speezu/core/theme/theme_bloc/theme_state.dart';
import 'package:speezu/presentation/auth/bloc/auth_bloc.dart';
import 'package:speezu/presentation/category/bloc/category_bloc.dart';
import 'package:speezu/presentation/favourites/bloc/favourite_bloc.dart';
import 'package:speezu/presentation/home/bloc/home_bloc.dart';
import 'package:speezu/presentation/languages/bloc/languages_bloc.dart';
import 'package:speezu/presentation/order_details/bloc/order_details_bloc.dart';
import 'package:speezu/presentation/orders/bloc/orders_bloc.dart';
import 'package:speezu/presentation/product_detail/bloc/product_detail_bloc.dart';
import 'package:speezu/presentation/products/bloc/products_bloc.dart';
import 'package:speezu/presentation/search_products/bloc/search_products_bloc.dart';
import 'package:speezu/presentation/shop_screen/bloc/shop_bloc.dart';
import 'package:speezu/presentation/cart/bloc/cart_bloc.dart';
import 'package:speezu/repositories/user_repository.dart';
import 'package:speezu/routes/app_routes.dart';
import 'package:speezu/routes/route_names.dart';
import 'package:speezu/widgets/search_animated_container.dart';
import 'package:speezu/widgets/widget_bloc/banner_slider_bloc/banner_slider_bloc.dart';
import 'core/services/notification_service.dart';
import 'core/theme/app_theme.dart';
import 'core/theme/theme_bloc/theme_bloc.dart';
import 'firebase_options.dart';

// This needs to be outside of any class
@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  final notificationService = NotificationService();
  await notificationService.initializeLocalNotifications();
  await notificationService.showNotification(message);
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Load environment variables
  try {
    await dotenv.load(fileName: ".env");
  } catch (e) {
    print('Warning: .env file not found. Using default values.');
  }
  await EasyLocalization.ensureInitialized();
  // If you want immersive UI without hiding bars completely:
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  // Set the background message handler
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  final UserRepository userRepository = UserRepository();
  userRepository.init();


  // Initialize notification service
  final notificationService = NotificationService();
  await notificationService.initializeLocalNotifications();
  notificationService.requestNotificationPermission();
  notificationService.firebaseInit();
  notificationService.setupInteractMessage();
  
  // Get FCM token and save to server if user is logged in
  final fcmToken = await notificationService.getDeviceToken();
  
  // Check if user is logged in and save FCM token to server
  final isAuthenticated = await userRepository.isUserAuthenticated();
  if (isAuthenticated && fcmToken.isNotEmpty) {
    // Check if token has changed by comparing with stored token
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final storedToken = prefs.getString("fcm");
    
    // Save token if it's different from stored token or if no token is stored
    if (storedToken != fcmToken) {
      try {
        await userRepository.saveFcmTokenToServer(fcmToken);
      } catch (e) {
        debugPrint("Error saving FCM token on app restart: $e");
      }
    }
  }

  // Set up token refresh listener to handle token updates automatically
  notificationService.setupTokenRefreshListener();

  // GetServerKey getServerKey = GetServerKey();
  // String serverKey = await getServerKey.getServerKeyToken();
  // debugPrint("Server Key: $serverKey");

  runApp(
    EasyLocalization(
      supportedLocales: const [
        Locale('en'),
      Locale('ar'),
      Locale('es'),
      Locale('fr'),
      Locale('fr', 'CA'), // French (Canada)
      Locale('ko'),
      Locale('pt', 'BR'), // Portuguese (Brazil)
       ],
      path: 'assets/translations',
      fallbackLocale: const Locale('en'),
      child: MultiBlocProvider(
        providers: [
          BlocProvider<ThemeBloc>(create: (_) => ThemeBloc()),
          BlocProvider<AuthBloc>(create: (_) => AuthBloc()),
          BlocProvider<LanguageBloc>(create: (_) => LanguageBloc()),
          BlocProvider<HomeBloc>(create: (_) => HomeBloc()),
          BlocProvider<BannerSliderBloc>(create: (_) => BannerSliderBloc()),
          BlocProvider<SearchCubit>(create: (_) => SearchCubit()),
          BlocProvider<ShopBloc>(create: (_) => ShopBloc()),
          BlocProvider<CategoryBloc>(create: (_) => CategoryBloc()),
          BlocProvider<ProductsBloc>(create: (_) => ProductsBloc()),
          BlocProvider<ProductDetailBloc>(create: (_) => ProductDetailBloc()),
          BlocProvider<CartBloc>(create: (_) => CartBloc()),
          BlocProvider<OrdersBloc>(create: (_) => OrdersBloc()),
          BlocProvider<OrderDetailsBloc>(create: (_) => OrderDetailsBloc()),
          BlocProvider<FavouriteBloc>(create: (_) => FavouriteBloc()),
          BlocProvider<SearchProductsBloc>(create: (_) => SearchProductsBloc()),
        ],
        child: MyApp(),
      ),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ThemeBloc, ThemeState>(
      builder: (context, theme) {
        return GestureDetector(
          onTap: () {
            FocusScopeNode currentFocus = FocusScope.of(context);
            if (!currentFocus.hasPrimaryFocus &&
                currentFocus.focusedChild != null) {
              FocusManager.instance.primaryFocus?.unfocus();
            }
          },
          child: MaterialApp(
            title: 'Speezu',
            debugShowCheckedModeBanner: false,
            theme: AppTheme.lightTheme,
            darkTheme: AppTheme.darkTheme,
            themeMode:
                theme.themeMode == AppThemeMode.light
                    ? ThemeMode.light
                    : ThemeMode.dark,
            localizationsDelegates: context.localizationDelegates,
            supportedLocales: context.supportedLocales,
            locale: context.locale,
            // home: OrderDetailsScreen(),
            initialRoute: RouteNames.splash,
            onGenerateRoute: AppRoutes.generateRoute,
          ),
        );
      },
    );
  }
}
