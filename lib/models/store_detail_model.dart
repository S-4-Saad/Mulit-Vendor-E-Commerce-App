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
  final String primaryNumber;
  final String whatsappNumber;
  final int reviewsCount;
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
    required this.primaryNumber,
    required this.whatsappNumber,
    required this.reviewsCount,
    this.reviews = const [],
  });

  factory StoreDetail.fromJson(Map<String, dynamic> json) {
    final String imagePath = json['image'] ?? '';
    final String fullImageUrl = imagePath.isNotEmpty
        ? (imagePath.startsWith('http') ? imagePath : '$imageBaseUrl$imagePath')
        : '';

    List<String> processedMoreImages = [];
    if (json['more_images'] != null) {
      processedMoreImages = (json['more_images'] as List<dynamic>).map((img) {
        if (img.toString().isNotEmpty) {
          return img.toString().startsWith('http')
              ? img.toString()
              : '$imageBaseUrl$img';
        }
        return img.toString();
      }).toList();
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
      openingTime: json['opening_time'] ?? '',
      closingTime: json['closing_time'] ?? '',
      primaryNumber: json['primary_number'] ?? '',
      whatsappNumber: json['whatsapp_number'] ?? '',
      reviewsCount: json['reviews_count'] ?? 0,
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
      'primary_number': primaryNumber,
      'whatsapp_number': whatsappNumber,
      'reviews_count': reviewsCount,
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
