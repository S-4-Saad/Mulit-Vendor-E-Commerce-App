
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:speezu/core/theme/theme_bloc/theme_state.dart';
import 'package:speezu/core/utils/app_validators.dart';
import 'package:speezu/presentation/auth/bloc/auth_bloc.dart';
import 'package:speezu/presentation/auth/login_screen.dart';
import 'package:speezu/routes/app_routes.dart';
import 'package:speezu/routes/route_names.dart';
import 'package:speezu/widgets/custom_text_form_field.dart';

import 'core/theme/app_theme.dart';
import 'core/theme/theme_bloc/theme_bloc.dart';
import 'core/theme/theme_bloc/theme_event.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();
  // If you want immersive UI without hiding bars completely:
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
  runApp(
    EasyLocalization(
      supportedLocales: const [Locale('en'), Locale('ar')],
      path: 'assets/translations',
      fallbackLocale: const Locale('en'),
      child: MultiBlocProvider(
        providers: [
          BlocProvider<ThemeBloc>(create: (_) => ThemeBloc()),
          BlocProvider<AuthBloc>(create: (_) => AuthBloc()),
          // BlocProvider<AuthBloc>(create: (_) => AuthBloc()),
          // BlocProvider<CustomersBloc>(create: (_) => CustomersBloc()),
          // BlocProvider<EstimateBloc>(create: (_) => EstimateBloc()),
          // BlocProvider<EstimateDetailBloc>(create: (_) => EstimateDetailBloc()),
          // BlocProvider<EstimateItemsBloc>(create: (_) => EstimateItemsBloc()),
          // BlocProvider<DropdownCubit<String>>(create: (_) => DropdownCubit<String>()),
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
        return MaterialApp(
          title: 'RiverCity',
          debugShowCheckedModeBanner: true,
          theme: AppTheme.lightTheme,
          darkTheme: AppTheme.darkTheme,
          themeMode: theme.themeMode == AppThemeMode.light
              ? ThemeMode.light
              : ThemeMode.dark,

          localizationsDelegates: context.localizationDelegates,
          supportedLocales: context.supportedLocales,
          locale: context.locale,
          // home: LoginScreen(),
          initialRoute: RouteNames.splash,
          onGenerateRoute: AppRoutes.generateRoute,
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


