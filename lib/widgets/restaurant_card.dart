import 'package:flutter/material.dart';
import '../models/restaurant_model.dart';
import 'custom_button.dart';

class RestaurantCard extends StatelessWidget {
  final RestaurantModel restaurant;
  final VoidCallback? onTap;
  final VoidCallback? onOpenTap;
  final VoidCallback? onPickupTap;
  final VoidCallback? onFavoriteTap;
  final double? width;
  final double? height;

  const RestaurantCard({
    super.key,
    required this.restaurant,
    this.onTap,
    this.onOpenTap,
    this.onPickupTap,
    this.onFavoriteTap,
    this.width,
    this.height,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: width ?? 280,
        height: height ?? 320,
        margin: const EdgeInsets.only(right: 16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image section with overlay buttons
            SizedBox(
              height: 150, // Fixed height for image section
              child: Stack(
                children: [
                  // Restaurant image
                  Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      borderRadius: const BorderRadius.vertical(
                        top: Radius.circular(12),
                      ),
                      image: DecorationImage(
                        image: _getImageProvider(),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  
                  // Overlay buttons
                  Positioned(
                    bottom: 12,
                    left: 12,
                    child: Row(
                      children: [
                        if (restaurant.status == "Open" && onOpenTap != null)
                          CustomButton(
                            text: "Open",
                            onPressed: onOpenTap,
                            backgroundColor: const Color(0xFF27AE60),
                            textColor: Colors.white,
                            padding: const EdgeInsets.symmetric(
                              vertical: 6,
                              horizontal: 12,
                            ),
                            borderRadius: 6,
                          ),
                        if (restaurant.isPickupAvailable == true && onPickupTap != null) ...[
                          const SizedBox(width: 8),
                          CustomButton(
                            text: "Pickup",
                            onPressed: onPickupTap,
                            backgroundColor: const Color(0xFFE74C3C),
                            textColor: Colors.white,
                            padding: const EdgeInsets.symmetric(
                              vertical: 6,
                              horizontal: 12,
                            ),
                            borderRadius: 6,
                          ),
                        ],
                      ],
                    ),
                  ),
                  
                  // Favorite button
                  if (onFavoriteTap != null)
                    Positioned(
                      top: 12,
                      right: 12,
                      child: GestureDetector(
                        onTap: onFavoriteTap,
                        child: Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.9),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            restaurant.isFavorite == true
                                ? Icons.favorite
                                : Icons.favorite_border,
                            color: restaurant.isFavorite == true
                                ? Colors.red
                                : Colors.grey[600],
                            size: 20,
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),
            
            // Content section
            Container(
              height: 120, // Fixed height instead of Expanded
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Top content
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Restaurant name
                      Text(
                        restaurant.name ?? "Restaurant Name",
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF2C3E50),
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      
                      const SizedBox(height: 4),
                      
                      // Description
                      Text(
                        restaurant.description ?? "Letraset sheets containing Lorem Ipsum passages",
                        style: const TextStyle(
                          fontSize: 12,
                          color: Color(0xFF7F8C8D),
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                  
                  // Bottom content - Rating and action button row
                  Row(
                    children: [
                      // Rating stars
                      Row(
                        children: List.generate(5, (index) {
                          return Icon(
                            index < (restaurant.rating ?? 0).floor()
                                ? Icons.star
                                : Icons.star_border,
                            color: Colors.amber,
                            size: 16,
                          );
                        }),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  ImageProvider _getImageProvider() {
    if (restaurant.images != null && restaurant.images!.isNotEmpty) {
      return NetworkImage(restaurant.images!.first.url);
    }
    return const AssetImage('assets/images/logo.png');
  }
}
