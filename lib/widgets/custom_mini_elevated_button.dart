import 'package:flutter/material.dart';

import '../core/assets/font_family.dart';

class CustomMiniElevatedButton extends StatelessWidget {
  const CustomMiniElevatedButton({
    super.key,
    required this.title,
    required this.onPressed,
    required this.backgroundColor,
    required this.textColor,
  });
  final String title;
  final VoidCallback onPressed;
  final Color backgroundColor;

  final Color textColor;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 8.0),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          minimumSize: Size(0, 30),
          backgroundColor: backgroundColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(50),
          ),

          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 0),
        ),

        onPressed: onPressed,
        child: Text(
          title,
          style: TextStyle(
            color: textColor,
            fontFamily: FontFamily.fontsPoppinsRegular,
          ),
        ),
      ),
    );
  }
}
