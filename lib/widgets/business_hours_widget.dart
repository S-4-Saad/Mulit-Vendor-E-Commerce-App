import 'package:flutter/material.dart';
import 'package:speezu/core/utils/media_querry_extention.dart';

import '../core/assets/font_family.dart';
import '../core/utils/labels.dart';

class BusinessHoursWidget extends StatelessWidget {
  final String openingTime;
  final String closingTime;

  const BusinessHoursWidget({
    super.key,
    required this.openingTime,
    required this.closingTime,
  });

  @override
  Widget build(BuildContext context) {
    return Container(

      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.onPrimary,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: Theme.of(context).colorScheme.onSecondary.withOpacity(0.2),
          width: 1,
        ),

        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 15,
            spreadRadius: 2,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        children: [
          // Header with Icon + Title
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: LinearGradient(
                    colors: [
                      Theme.of(context).colorScheme.primary,
                      Theme.of(context).colorScheme.secondary,
                    ],
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Theme.of(context).colorScheme.primary.withOpacity(0.4),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child:  Icon(
                  Icons.access_time_filled_rounded,
                  color: Colors.white,
                  size: context.scaledFont(20),
                ),
              ),
              const SizedBox(width: 14),
              Text(
                Labels.businessHours,
                style: TextStyle(
                  fontSize: context.scaledFont(15),
                  fontFamily:FontFamily.fontsPoppinsSemiBold,
                  color: Theme.of(context).colorScheme.onSecondary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 18),

          // Opening & Closing Rows
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildTimeCard(
                context,
                icon: Icons.login_rounded,
                label: Labels.opensAt,
                time: openingTime,
                color: Colors.green,
              ),
              _buildTimeCard(
                context,
                icon: Icons.logout_rounded,
                label: Labels.closesAt,
                time: closingTime,
                color: Colors.red,
              ),
            ],
          ),
        ],
      ),
    );
  }

  // Small reusable card for open/close
  Widget _buildTimeCard(BuildContext context,
      {required IconData icon,
        required String label,
        required String time,
        required Color color}) {
    return Expanded(
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 6),
        padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 12),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.onPrimary,
          borderRadius: BorderRadius.circular(14),
          boxShadow: [
            BoxShadow(
              color: color.withOpacity(0.15),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
          border: Border.all(color: color.withOpacity(0.4), width: 1),
        ),
        child: Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Icon(icon, color: color, size: 26),
            Column(
              children: [

                const SizedBox(height: 6),
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Theme.of(context).colorScheme.onSecondary,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  time,
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: color,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}