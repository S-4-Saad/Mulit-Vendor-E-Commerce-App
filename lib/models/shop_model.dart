import '../core/services/urls.dart';

class ShopModel {
  final int id;
  final String imageUrl;
  final String shopName;
  final String shopDescription;
  final double shopRating;
  final bool isOpen;
  final bool isDelivering;
  final double latitude;
  final double longitude;
   double? distance;

  ShopModel({
    required this.id,
    required this.imageUrl,
    required this.shopName,
    required this.shopDescription,
    required this.shopRating,
    required this.isOpen,
    required this.isDelivering,
    required this.latitude,
    required this.longitude,
    this.distance,
  });

  factory ShopModel.fromJson(Map<String, dynamic> json) {
    final String imagePath = json['image'] ?? '';
    final String fullImageUrl = imagePath.isNotEmpty
        ? (imagePath.startsWith('http') ? imagePath : '$imageBaseUrl$imagePath')
        : '';
    return ShopModel(
      id: json['id'] ?? 0,
      imageUrl: fullImageUrl,
      shopName: json['name'] ?? '',
      shopDescription: json['description'] ?? '',
      shopRating: double.tryParse(json['rating']?.toString() ?? '0.0') ?? 0.0,
      isOpen: (json['is_open'] ?? 0) == 1,
      isDelivering: (json['is_delivery'] ?? 0) == 1,
      latitude: double.tryParse(json['latitude']?.toString() ?? '0.0') ?? 0.0,
      longitude: double.tryParse(json['longitude']?.toString() ?? '0.0') ?? 0.0,
      distance: json.containsKey('distance')
          ? double.tryParse(json['distance']?.toString() ?? '0.0') ?? 0.0
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'image': imageUrl,
      'name': shopName,
      'description': shopDescription,
      'is_open': isOpen ? 1 : 0,
      'is_delivery': isDelivering ? 1 : 0,
      'latitude': latitude.toString(),
      'longitude': longitude.toString(),
      'rating': shopRating.toString(),
      if (distance != null) 'distance': distance.toString(),
    };
  }
}

class ShopsModel {
  bool? success;
  List<ShopModel>? stores;
  String? message;

  ShopsModel({this.success, this.stores, this.message});

  ShopsModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    if (json['stores'] != null) {
      stores = <ShopModel>[];
      json['stores'].forEach((v) {
        stores!.add(ShopModel.fromJson(v));
      });
    }
    message = json['message'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['success'] = success;
    if (stores != null) {
      data['stores'] = stores!.map((v) => v.toJson()).toList();
    }
    data['message'] = message;
    return data;
  }
}
