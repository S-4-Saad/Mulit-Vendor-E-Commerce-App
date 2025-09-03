import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:speezu/core/utils/media_querry_extention.dart';

class AuthLoader extends StatelessWidget {
  const AuthLoader({super.key});

  @override
  Widget build(BuildContext context) {
    return SpinKitWave(
      color: Theme.of(context).colorScheme.primary,
      size: context.scaledFont(28),
    );
  }
}
