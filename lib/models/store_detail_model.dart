// import '../core/services/urls.dart';
// import 'store_model.dart';

// class StoreDetailModel {
//   bool? success;
//   List<StoreDetail>? stores;
//   String? message;

//   StoreDetailModel({this.success, this.stores, this.message});

//   StoreDetailModel.fromJson(Map<String, dynamic> json) {
//     success = json['success'];
//     if (json['stores'] != null) {
//       stores = <StoreDetail>[];
//       json['stores'].forEach((v) {
//         stores!.add(StoreDetail.fromJson(v));
//       });
//     }
//     message = json['message'];
//   }

//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = <String, dynamic>{};
//     data['success'] = success;
//     if (stores != null) {
//       data['stores'] = stores!.map((v) => v.toJson()).toList();
//     }
//     data['message'] = message;
//     return data;
//   }
// }

// class StoreDetail {
//   final int id;
//   final int userId;
//   final int storeCategoryId;
//   final String name;
//   final String image;
//   final List<String> moreImages;
//   final double latitude;
//   final double longitude;
//   final String description;
//   final String information;
//   final String whatsappNumber;
//   final String primaryNumber;
//   final String secondaryNumber;
//   final bool? isDelivery;
//   final bool isOpen;
//   final String address;
//   final String createdAt;
//   final String updatedAt;
  
//   // Additional fields for UI
//   final double rating;
//   final String openingTime;
//   final String closingTime;
//   final List<Review> reviews;

//   StoreDetail({
//     required this.id,
//     required this.userId,
//     required this.storeCategoryId,
//     required this.name,
//     required this.image,
//     required this.moreImages,
//     required this.latitude,
//     required this.longitude,
//     required this.description,
//     required this.information,
//     required this.whatsappNumber,
//     required this.primaryNumber,
//     required this.secondaryNumber,
//     this.isDelivery,
//     required this.isOpen,
//     required this.address,
//     required this.createdAt,
//     required this.updatedAt,
//     required this.rating,
//     required this.openingTime,
//     required this.closingTime,
//     this.reviews = const [], // Dummy value for now
//   });

//   factory StoreDetail.fromJson(Map<String, dynamic> json) {
//     // Process main image
//     final String imagePath = json['image'] ?? '';
//     final String fullImageUrl = imagePath.isNotEmpty
//         ? (imagePath.startsWith('http') ? imagePath : '$imageBaseUrl$imagePath')
//         : '';

//     // Process more images
//     List<String> processedMoreImages = [];
//     if (json['more_images'] != null) {
//       processedMoreImages = (json['more_images'] as List<dynamic>).map((imagePath) {
//         if (imagePath.toString().isNotEmpty) {
//           return imagePath.toString().startsWith('http')
//               ? imagePath.toString()
//               : '$imageBaseUrl$imagePath';
//         }
//         return imagePath.toString();
//       }).toList();
//     }
    
//     return StoreDetail(
//       id: json['id'] ?? 0,
//       userId: json['user_id'] ?? 0,
//       storeCategoryId: json['store_category_id'] ?? 0,
//       name: json['name'] ?? '',
//       image: fullImageUrl,
//       moreImages: processedMoreImages,
//       latitude: double.tryParse(json['latitude']?.toString() ?? '0.0') ?? 0.0,
//       longitude: double.tryParse(json['longitude']?.toString() ?? '0.0') ?? 0.0,
//       description: json['description'] ?? '',
//       information: json['information'] ?? '',
//       whatsappNumber: json['whatsapp_number'] ?? '',
//       primaryNumber: json['primary_number'] ?? '',
//       secondaryNumber: json['secondary_number'] ?? '',
//       isDelivery: json['is_delivery'] != null ? json['is_delivery'] == 1 : null,
//       isOpen: (json['is_open'] ?? 0) == 1,
//       address: json['address'] ?? '',
//       createdAt: json['created_at'] ?? '',
//       updatedAt: json['updated_at'] ?? '',
//       rating: double.tryParse(json['rating']?.toString() ?? '0.0') ?? 0.0,
//       openingTime: json['opening_time'] ?? '09:00 AM',
//       closingTime: json['closing_time'] ?? '11:00 PM',
//     );
//   }

//   Map<String, dynamic> toJson() {
//     return {
//       'id': id,
//       'user_id': userId,
//       'store_category_id': storeCategoryId,
//       'name': name,
//       'image': image,
//       'more_images': moreImages,
//       'latitude': latitude.toString(),
//       'longitude': longitude.toString(),
//       'description': description,
//       'information': information,
//       'whatsapp_number': whatsappNumber,
//       'primary_number': primaryNumber,
//       'secondary_number': secondaryNumber,
//       'is_delivery': isDelivery == true ? 1 : 0,
//       'is_open': isOpen ? 1 : 0,
//       'address': address,
//       'created_at': createdAt,
//       'updated_at': updatedAt,
//       'rating': rating.toString(),
//       'opening_time': openingTime,
//       'closing_time': closingTime,
//     };
//   }

//   // Convert to Store model for compatibility with existing UI
//   Store toStore() {
//     return Store(
//       id: id.toString(),
//       name: name,
//       image: image,
//       moreImages: moreImages,
//       latitude: latitude,
//       longitude: longitude,
//       description: description,
//       information: information,
//       whatsappNumber: whatsappNumber,
//       primaryNumber: primaryNumber,
//       secondaryNumber: secondaryNumber,
//       address: address,
//       openingTime: openingTime,
//       closingTime: closingTime,
//       reviews: reviews,
//       isOpen: isOpen,
//       isDelivering: isDelivery ?? false,
//       ratting: rating,
//       categories: [], // Dummy value
//     );
//   }
// }
import '../core/services/urls.dart';

class StoreDetailModel {
  final bool? success;
  final String? message;
  final StoreDetail? store;

  StoreDetailModel({this.success, this.message, this.store});

  factory StoreDetailModel.fromJson(Map<String, dynamic> json) {
    return StoreDetailModel(
      success: json['success'],
      message: json['message'],
      store: json['store'] != null ? StoreDetail.fromJson(json['store']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'success': success,
      'message': message,
      if (store != null) 'store': store!.toJson(),
    };
  }
}

class StoreDetail {
  final int id;
  final String name;
  final String image;
  final List<String> moreImages;
  final bool isDelivery;
  final bool isOpen;
  final double latitude;
  final double longitude;
  final String description;
  final double rating;
  final String openingTime;
  final String closingTime;
  final List<Review> reviews;

  StoreDetail({
    required this.id,
    required this.name,
    required this.image,
    required this.moreImages,
    required this.isDelivery,
    required this.isOpen,
    required this.latitude,
    required this.longitude,
    required this.description,
    required this.rating,
    required this.openingTime,
    required this.closingTime,
    this.reviews = const [],
  });

  factory StoreDetail.fromJson(Map<String, dynamic> json) {
    // Handle image
    final String imagePath = json['image'] ?? '';
    final String fullImageUrl = imagePath.isNotEmpty
        ? (imagePath.startsWith('http') ? imagePath : '$imageBaseUrl$imagePath')
        : '';

    // Handle more images
    List<String> processedMoreImages = [];
    if (json['more_images'] != null) {
      processedMoreImages = (json['more_images'] as List<dynamic>)
          .map((img) {
            if (img.toString().isNotEmpty) {
              return img.toString().startsWith('http')
                  ? img.toString()
                  : '$imageBaseUrl$img';
            }
            return img.toString();
          })
          .toList();
    }

    return StoreDetail(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      image: fullImageUrl,
      moreImages: processedMoreImages,
      isDelivery: (json['is_delivery'] ?? 0) == 1,
      isOpen: (json['is_open'] ?? 0) == 1,
      latitude: double.tryParse(json['latitude']?.toString() ?? '0.0') ?? 0.0,
      longitude: double.tryParse(json['longitude']?.toString() ?? '0.0') ?? 0.0,
      description: json['description'] ?? '',
      rating: double.tryParse(json['rating']?.toString() ?? '0.0') ?? 0.0,
      openingTime: json['opening_time'] ?? '09:00 AM',
      closingTime: json['closing_time'] ?? '11:00 PM',
      reviews: json['lastReviews'] != null
          ? (json['lastReviews'] as List<dynamic>)
              .map((v) => Review.fromJson(v))
              .toList()
          : [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'image': image,
      'more_images': moreImages,
      'is_delivery': isDelivery ? 1 : 0,
      'is_open': isOpen ? 1 : 0,
      'latitude': latitude.toString(),
      'longitude': longitude.toString(),
      'description': description,
      'rating': rating.toString(),
      'opening_time': openingTime,
      'closing_time': closingTime,
      'lastReviews': reviews.map((r) => r.toJson()).toList(),
    };
  }
}

class Review {
  final int id;
  final String userName;
  final double rating;
  final String review;
  final String createdAt;

  Review({
    required this.id,
    required this.userName,
    required this.rating,
    required this.review,
    required this.createdAt,
  });

  factory Review.fromJson(Map<String, dynamic> json) {
    return Review(
      id: json['id'] ?? 0,
      userName: json['userName'] ?? '',
      rating: double.tryParse(json['rating']?.toString() ?? '0.0') ?? 0.0,
      review: json['review'] ?? '',
      createdAt: json['createdAt'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userName': userName,
      'rating': rating.toString(),
      'review': review,
      'createdAt': createdAt,
    };
  }
}
