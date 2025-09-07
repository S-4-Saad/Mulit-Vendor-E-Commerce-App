import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final Color backgroundColor;
  final Color textColor;
  final double borderRadius;
  final EdgeInsets padding;
  final bool isSelected;

  const CustomButton({
    Key? key,
    this.text = 'Delivery',
    this.onPressed,
    this.backgroundColor = const Color(0xFFF4F4F9),
    this.textColor = const Color(0xFF2C3E50),
    this.borderRadius = 8.0,
    this.padding = const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
    this.isSelected = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(left: 8.0),
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: isSelected ? const Color(0xFFE74C3C) : backgroundColor,
          foregroundColor: isSelected ? Colors.white : textColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(borderRadius),
          ),
          padding: padding,
          elevation: 0,
          minimumSize: Size.zero,
          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
        ),
        child: Text(
          text,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }
}