
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:speezu/core/theme/theme_bloc/theme_state.dart';
import 'package:speezu/core/utils/app_validators.dart';
import 'package:speezu/paractise.dart';
import 'package:speezu/presentation/auth/bloc/auth_bloc.dart';
import 'package:speezu/presentation/category/bloc/category_bloc.dart';
import 'package:speezu/presentation/home/bloc/home_bloc.dart';
import 'package:speezu/presentation/languages/bloc/languages_bloc.dart';
import 'package:speezu/presentation/shop_screen/bloc/shop_bloc.dart';
import 'package:speezu/presentation/shop_screen/shop_navbar_screen.dart';
import 'package:speezu/repositories/user_repository.dart';
import 'package:speezu/routes/app_routes.dart';
import 'package:speezu/routes/route_names.dart';
import 'package:speezu/widgets/custom_text_form_field.dart';
import 'package:speezu/widgets/search_animated_container.dart';
import 'package:speezu/widgets/widget_bloc/banner_slider_bloc/banner_slider_bloc.dart';

import 'core/services/notification_service.dart';
import 'core/theme/app_theme.dart';
import 'core/theme/theme_bloc/theme_bloc.dart';
import 'core/theme/theme_bloc/theme_event.dart';
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
  await EasyLocalization.ensureInitialized();
  // If you want immersive UI without hiding bars completely:
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
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
  notificationService.getDeviceToken();

  // GetServerKey getServerKey = GetServerKey();
  // String serverKey = await getServerKey.getServerKeyToken();
  // printWrapped("Server Key: $serverKey");
  runApp(
    EasyLocalization(
      supportedLocales: const [Locale('en'), Locale('ar')],
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
            title: 'RiverCity',
            debugShowCheckedModeBanner: false,
            theme: AppTheme.lightTheme,
            darkTheme: AppTheme.darkTheme,
            themeMode: theme.themeMode == AppThemeMode.light
                ? ThemeMode.light
                : ThemeMode.dark,
            localizationsDelegates: context.localizationDelegates,
            supportedLocales: context.supportedLocales,
            locale: context.locale,
            // home: PractiseScreen(),
            initialRoute: RouteNames.splash,
            onGenerateRoute: AppRoutes.generateRoute,
          ),
        );
      },
    );
  }
}
// class SplashScreen extends StatelessWidget {
//   const SplashScreen({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Column(mainAxisAlignment: MainAxisAlignment.center,
//         children: [
//           Center(child: Text('Splash Screen', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),)),
//           ListTile(
//             title: Text('Toggle Dark Mode'),
//             trailing: Switch(
//               value: context.watch<ThemeBloc>().state.themeMode == AppThemeMode.dark,
//               onChanged: (value) {
//                 context.read<ThemeBloc>().add(SwitchThemeEvent(
//                   value ? AppThemeMode.dark : AppThemeMode.light,
//                 ));
//               },
//               activeColor: Theme.of(context).colorScheme.secondary, // Uses second_color or second_dark_color
//             ),
//           ),
//           Wrap(
//             children: [
//               Container(height: 100, width: 100, color: Theme.of(context).scaffoldBackgroundColor,),
//               Container(height: 100, width: 100, color: Theme.of(context).colorScheme.primary,),
//               Container(height: 100, width: 100, color: Theme.of(context).colorScheme.secondary,),
//               Container(height: 100, width: 100, color: Theme.of(context).colorScheme.onSecondary,),
//               Container(height: 100, width: 100, color: Theme.of(context).colorScheme.onPrimary,),
//               Text(Labels.hello, style:TextStyle(
//                 color: Theme.of(context).colorScheme.onSurface,
//
//               ) ),
//               Text('Sample Text', ),
//               Text('Sample Text', ),
//               Text('Sample Text',),
//               Text(Labels.welcome, style: Theme.of(context).textTheme.titleMedium,),
//               Text('Sample Text', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold,),),
//               ElevatedButton(
//                 onPressed: () {
//                   if (context.locale.languageCode == 'en') {
//                     context.setLocale(const Locale('ar'));
//                   } else {
//                     context.setLocale(const Locale('en'));
//                   }
//                 },
//                 child: Text('Change Language'),
//               ),
//
//
//               CustomTextFormField(validator: AppValidators.validateNumber, textEditingController: TextEditingController(), hint: 'Hello')
//             ],
//           ),
//         ],
//       ),
//     );
//   }
// }


