import 'package:flutter/material.dart';
import '../models/restaurant_model.dart';
import 'restaurant_card.dart';

class RestaurantList extends StatelessWidget {
  final List<RestaurantModel> restaurants;
  final VoidCallback? onRestaurantTap;
  final VoidCallback? onOpenTap;
  final VoidCallback? onPickupTap;
  final Function(RestaurantModel)? onLocationTap;
  final double? height;
  final EdgeInsetsGeometry? padding;

  const RestaurantList({
    super.key,
    required this.restaurants,
    this.onRestaurantTap,
    this.onOpenTap,
    this.onPickupTap,
    this.onLocationTap,
    this.height,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    if (restaurants.isEmpty) {
      return const SizedBox.shrink();
    }

    return Container(
      height: height ?? 300,
      padding: padding ?? const EdgeInsets.symmetric(vertical: 8),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: restaurants.length,
        itemBuilder: (context, index) {
          final restaurant = restaurants[index];
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: RestaurantCard(
              restaurant: restaurant,
              onTap: onRestaurantTap,
              onOpenTap: onOpenTap,
              onPickupTap: onPickupTap,
              onLocationTap: onLocationTap,
            ),
          );
        },
      ),
    );
  }
}
