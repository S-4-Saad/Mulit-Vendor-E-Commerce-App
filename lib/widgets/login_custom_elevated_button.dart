import 'package:flutter/material.dart';
import 'package:speezu/core/utils/media_querry_extention.dart';

import '../core/assets/font_family.dart';

class LoginCustomElevatedButton extends StatelessWidget {
  const LoginCustomElevatedButton({super.key, required this.title, required this.onPressed});
  final String title;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        shadowColor: Theme.of(context).colorScheme.outline.withValues(alpha: .5),

        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Theme.of(context).colorScheme.onPrimary,
        minimumSize: Size(double.infinity, 50),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),

      onPressed: onPressed,
      child: Text(title,style: TextStyle(
        fontSize: context.scaledFont(15),
        color: Theme.of(context).colorScheme.onPrimary,
        fontFamily: FontFamily.fontsPoppinsSemiBold,
      ),),
    );
  }
}
