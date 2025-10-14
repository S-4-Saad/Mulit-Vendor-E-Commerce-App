// import 'package:flutter/material.dart';
// import '../models/restaurant_model.dart';
// import 'custom_button.dart';
//
// class RestaurantCard extends StatelessWidget {
//   final RestaurantModel restaurant;
//   final VoidCallback? onTap;
//   final VoidCallback? onOpenTap;
//   final VoidCallback? onPickupTap;
//   final Function(RestaurantModel)? onLocationTap;
//   final double? width;
//   final double? height;
//
//   const RestaurantCard({
//     super.key,
//     required this.restaurant,
//     this.onTap,
//     this.onOpenTap,
//     this.onPickupTap,
//     this.onLocationTap,
//     this.width,
//     this.height,
//   });
//
//   @override
//   Widget build(BuildContext context) {
//     return GestureDetector(
//       onTap: onTap,
//       child: Container(
//         width: width ?? 280,
//         height: height ?? 260,
//         margin: const EdgeInsets.only(right: 16),
//         decoration: BoxDecoration(
//           color: Colors.white,
//           borderRadius: BorderRadius.circular(12),
//           boxShadow: [
//             BoxShadow(
//               color: Colors.black.withOpacity(0.1),
//               blurRadius: 8,
//               offset: const Offset(0, 2),
//             ),
//           ],
//         ),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             // Image section with overlay buttons
//             SizedBox(
//               height: 120, // Reduced height for image section
//               child: Stack(
//                 children: [
//                   // Restaurant image
//                   Container(
//                     width: double.infinity,
//                     decoration: BoxDecoration(
//                       borderRadius: const BorderRadius.vertical(
//                         top: Radius.circular(12),
//                       ),
//                       image: DecorationImage(
//                         image: _getImageProvider(),
//                         fit: BoxFit.cover,
//                       ),
//                     ),
//                   ),
//
//                   // Overlay buttons
//                   Positioned(
//                     bottom: 12,
//                     left: 12,
//                     child: Row(
//                       children: [
//                         if (restaurant.status == "Open" && onOpenTap != null)
//                           CustomButton(
//                             text: "Open",
//                             onPressed: onOpenTap,
//                             backgroundColor: const Color(0xFF27AE60),
//                             textColor: Colors.white,
//                             padding: const EdgeInsets.symmetric(
//                               vertical: 6,
//                               horizontal: 12,
//                             ),
//                             borderRadius: 6,
//                           ),
//                         if (restaurant.isPickupAvailable == true && onPickupTap != null) ...[
//                           const SizedBox(width: 8),
//                           CustomButton(
//                             text: "Pickup",
//                             onPressed: onPickupTap,
//                             backgroundColor: const Color(0xFFE74C3C),
//                             textColor: Colors.white,
//                             padding: const EdgeInsets.symmetric(
//                               vertical: 6,
//                               horizontal: 12,
//                             ),
//                             borderRadius: 6,
//                           ),
//                         ],
//                       ],
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//
//             // Content section
//             Expanded(
//               child: Padding(
//                 padding: const EdgeInsets.all(12),
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   children: [
//                     // Top content
//                     Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         // Restaurant name
//                         Text(
//                           restaurant.name ?? "Restaurant Name",
//                           style: const TextStyle(
//                             fontSize: 14,
//                             fontWeight: FontWeight.bold,
//                             color: Color(0xFF2C3E50),
//                           ),
//                           maxLines: 1,
//                           overflow: TextOverflow.ellipsis,
//                         ),
//
//                         const SizedBox(height: 2),
//
//                         // Description
//                         Text(
//                           restaurant.description ?? "Letraset sheets containing Lorem Ipsum passages",
//                           style: const TextStyle(
//                             fontSize: 11,
//                             color: Color(0xFF7F8C8D),
//                           ),
//                           maxLines: 1,
//                           overflow: TextOverflow.ellipsis,
//                         ),
//
//                         const SizedBox(height: 2),
//
//                         // Distance
//                         if (restaurant.distance != null)
//                           Row(
//                             children: [
//                               Icon(
//                                 Icons.location_on,
//                                 size: 12,
//                                 color: Colors.grey[600],
//                               ),
//                               const SizedBox(width: 4),
//                               Text(
//                                 _formatDistance(restaurant.distance!),
//                                 style: TextStyle(
//                                   fontSize: 11,
//                                   color: Colors.grey[600],
//                                   fontWeight: FontWeight.w500,
//                                 ),
//                               ),
//                             ],
//                           ),
//                     ],
//                   ),
//
//                     // Bottom content - Rating and action button row
//                     Row(
//                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                       children: [
//                         // Rating stars
//                         Row(
//                           children: List.generate(5, (index) {
//                             return Icon(
//                               index < (restaurant.rating ?? 0).floor()
//                                   ? Icons.star
//                                   : Icons.star_border,
//                               color: Colors.amber,
//                               size: 16,
//                             );
//                           }),
//                         ),
//
//                         // Location button
//                         GestureDetector(
//                           onTap: () => onLocationTap?.call(restaurant),
//                           child: Container(
//                             width: 40,
//                             height: 40,
//                             decoration: BoxDecoration(
//                               color: const Color(0xFF1ABC9C), // Teal color
//                               borderRadius: BorderRadius.circular(8),
//                             ),
//                             child: const Icon(
//                               Icons.roundabout_left_sharp,
//                               color: Colors.white,
//                               size: 20,
//                             ),
//                           ),
//                         ),
//                       ],
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
//
//   ImageProvider _getImageProvider() {
//     if (restaurant.images != null && restaurant.images!.isNotEmpty) {
//       return NetworkImage(restaurant.images!.first.url);
//     }
//     return const AssetImage('assets/images/logo.png');
//   }
//
//   String _formatDistance(double distanceInKm) {
//     if (distanceInKm < 1) {
//       return '${(distanceInKm * 1000).round()}m';
//     } else {
//       return '${distanceInKm.toStringAsFixed(1)}km';
//     }
//   }
// }
