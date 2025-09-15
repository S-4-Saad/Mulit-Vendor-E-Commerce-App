import 'package:flutter/material.dart';
import 'package:speezu/core/utils/media_querry_extention.dart';

import '../core/assets/font_family.dart';
import '../core/utils/labels.dart';

class OpenStatusContainer extends StatelessWidget {
  final bool isOpened;

  const OpenStatusContainer({super.key, required this.isOpened});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: context.widthPct(.13),
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: isOpened ? Colors.blue : Colors.red,
        borderRadius: BorderRadius.circular(50),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.2),
            blurRadius: 6,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Center(
        child: Text(
          isOpened ? Labels.open : Labels.close,
          style: TextStyle(
            color: Theme.of(context).colorScheme.onPrimary,
            fontFamily: FontFamily.fontsPoppinsSemiBold,
            fontSize: context.scaledFont(10),
          ),
        ),
      ),
    );
  }
}
class IsAvailableContainer extends StatelessWidget {
  final bool isAvailable;
  final bool isDelivering;

  const IsAvailableContainer({super.key, required this.isAvailable,  this.isDelivering=false});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(

          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          decoration: BoxDecoration(
            color: isAvailable ? Colors.blue : Colors.red,
            borderRadius: BorderRadius.circular(50),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.2),
                blurRadius: 6,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: Center(
            child: Text(
              isAvailable ? Labels.available : Labels.unavailable,
              style: TextStyle(
                color: Theme.of(context).colorScheme.onPrimary,
                fontFamily: FontFamily.fontsPoppinsSemiBold,
                fontSize: context.scaledFont(10),
              ),
            ),
          ),
        ),
        isAvailable? Container(

          margin: const EdgeInsets.only(left: 5),
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          decoration: BoxDecoration(
            color: isDelivering ? Colors.green : Colors.orange,
            borderRadius: BorderRadius.circular(50),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.2),
                blurRadius: 6,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: Center(
            child: Text(
              isAvailable ? Labels.delivery : Labels.pickUp,
              style: TextStyle(
                color: Theme.of(context).colorScheme.onPrimary,
                fontFamily: FontFamily.fontsPoppinsSemiBold,
                fontSize: context.scaledFont(10),
              ),
            ),
          ),
        ):SizedBox.shrink(),
      ],
    );
  }
}