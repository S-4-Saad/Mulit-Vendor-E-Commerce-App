import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:speezu/core/assets/app_images.dart';
import 'package:speezu/core/utils/media_querry_extention.dart';
import 'package:speezu/presentation/auth/bloc/auth_bloc.dart';
import 'package:speezu/presentation/auth/bloc/auth_event.dart';
import 'package:speezu/routes/route_names.dart';

import '../../routes/app_routes.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    // context.read<AuthBloc>().add(LoadUserDataEvent());
    Future.delayed(const Duration(seconds: 3), () {

        Navigator.pushReplacementNamed(context, RouteNames.navBarScreen);


    });
  }
  Widget build(BuildContext context) {
    return Scaffold(

      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(AppImages.speezuLogo,height: context.widthPct(.33),),
          SizedBox(
            height: context.heightPct(.1),
          ),
          SpinKitThreeBounce(
            color: Theme.of(context).colorScheme.outline,
            size: context.widthPct(.1),
          ),


        ],
      ),


    );
  }
}
