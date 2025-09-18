import 'package:speezu/models/product_model.dart';

class Store {
  final String id;
  final String name;
  final String image;
  final List<String> moreImages;
  final double latitude;
  final double longitude;
  final String description;
  final String information;
  final String whatsappNumber;
  final String primaryNumber;
  final String secondaryNumber;
  final String address;
  final String openingTime;
  final String closingTime;
  final List<Review> reviews;
  final bool isOpen;
  final bool isDelivering;
  final double ratting;

  /// ✅ New: Store has multiple categories
  final List<Category> categories;

  Store({
    required this.ratting,
    required this.id,
    required this.name,
    required this.image,
    required this.moreImages,
    required this.latitude,
    required this.longitude,
    required this.description,
    required this.information,
    required this.whatsappNumber,
    required this.primaryNumber,
    required this.secondaryNumber,
    required this.address,
    required this.reviews,
    required this.openingTime,
    required this.closingTime,
    required this.isOpen,
    required this.isDelivering,
    this.categories = const [],
  });
}

class Review {
  final String username;
  final String id;
  final String reviewerName;
  final String reviewerImage;
  final String reviewText;
  final double rating;
  final DateTime date;
  final List<String> images;

  Review({
    required this.username,
    required this.id,
    required this.reviewerName,
    required this.reviewerImage,
    required this.reviewText,
    required this.rating,
    required this.date,
    this.images = const [],
  });
}

/// ✅ New: Category model
class Category {
  final String id;
  final String name;
  final String imageUrl;
  final List<DummyProductModel> products;

  Category({
    required this.id,
    required this.name,
    required this.imageUrl,
    this.products = const [],
  });
}

