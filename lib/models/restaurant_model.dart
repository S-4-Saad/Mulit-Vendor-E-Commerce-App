import 'media_model.dart';

class RestaurantModel {
  int? id;
  String? name;
  String? description;
  double? rating;
  String? status; // "Open", "Closed", "Busy"
  String? deliveryTime;
  String? pickupTime;
  double? deliveryFee;
  bool? isDeliveryAvailable;
  bool? isPickupAvailable;
  String? address;
  String? phone;
  List<MediaModel>? images;
  String? cuisineType;
  double? distance;
  bool? isFavorite;

  RestaurantModel({
    this.id,
    this.name,
    this.description,
    this.rating,
    this.status,
    this.deliveryTime,
    this.pickupTime,
    this.deliveryFee,
    this.isDeliveryAvailable,
    this.isPickupAvailable,
    this.address,
    this.phone,
    this.images,
    this.cuisineType,
    this.distance,
    this.isFavorite,
  });

  factory RestaurantModel.fromJson(Map<String, dynamic> json) {
    return RestaurantModel(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      rating: json['rating']?.toDouble(),
      status: json['status'],
      deliveryTime: json['delivery_time'],
      pickupTime: json['pickup_time'],
      deliveryFee: json['delivery_fee']?.toDouble(),
      isDeliveryAvailable: json['is_delivery_available'],
      isPickupAvailable: json['is_pickup_available'],
      address: json['address'],
      phone: json['phone'],
      images: json['media'] != null
          ? (json['media'] as List)
              .map((e) => MediaModel.fromJSON(e))
              .toList()
          : null,
      cuisineType: json['cuisine_type'],
      distance: json['distance']?.toDouble(),
      isFavorite: json['is_favorite'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'rating': rating,
      'status': status,
      'delivery_time': deliveryTime,
      'pickup_time': pickupTime,
      'delivery_fee': deliveryFee,
      'is_delivery_available': isDeliveryAvailable,
      'is_pickup_available': isPickupAvailable,
      'address': address,
      'phone': phone,
      'media': images?.map((e) => e.toMap()).toList(),
      'cuisine_type': cuisineType,
      'distance': distance,
      'is_favorite': isFavorite,
    };
  }
}
