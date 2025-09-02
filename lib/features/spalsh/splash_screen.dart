import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:speezu/core/assets/app_images.dart';
import 'package:speezu/core/utils/media_querry_extention.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
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
