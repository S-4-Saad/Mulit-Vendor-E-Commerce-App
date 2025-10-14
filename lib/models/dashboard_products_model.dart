import 'package:speezu/core/services/urls.dart';

import 'product_model.dart';

class DashboardProductsModel {
  final bool status;
  final String message;
  final DashboardProductsData data;

  DashboardProductsModel({
    required this.status,
    required this.message,
    required this.data,
  });

  factory DashboardProductsModel.fromJson(Map<String, dynamic> json) {
    return DashboardProductsModel(
      status: json['status'] ?? false,
      message: json['message'] ?? '',
      data: DashboardProductsData.fromJson(json['data'] ?? {}),
    );
  }
}

class DashboardProductsData {
  final List<ApiProductModel> restaurant;
  final List<ApiProductModel> retail;
  final List<ApiProductModel> supermarket;
  final List<ApiProductModel> pharmacy;

  DashboardProductsData({
    required this.restaurant,
    required this.retail,
    required this.supermarket,
    required this.pharmacy,
  });

  factory DashboardProductsData.fromJson(Map<String, dynamic> json) {
    return DashboardProductsData(
      restaurant: (json['Restaurant'] as List<dynamic>?)
          ?.map((item) => ApiProductModel.fromJson(item))
          .toList() ?? [],
      retail: (json['Retail'] as List<dynamic>?)
          ?.map((item) => ApiProductModel.fromJson(item))
          .toList() ?? [],
      supermarket: (json['Supermarket'] as List<dynamic>?)
          ?.map((item) => ApiProductModel.fromJson(item))
          .toList() ?? [],
      pharmacy: (json['Pharmacy'] as List<dynamic>?)
          ?.map((item) => ApiProductModel.fromJson(item))
          .toList() ?? [],
    );
  }
}

class ApiProductModel {
  final int id;
  final String productName;
  final String productPrice;
  final String productDiscount;
  final String productDiscountedPrice;
  final String productImage;
  final String productRating;
  final String productDescription;
  final ProductCategory? category;

  ApiProductModel({
    required this.id,
    required this.productName,
    required this.productPrice,
    required this.productDiscount,
    required this.productDiscountedPrice,
    required this.productImage,
    required this.productRating,
    required this.productDescription,
    this.category,
  });

  factory ApiProductModel.fromJson(Map<String, dynamic> json) {
    return ApiProductModel(
      id: json['id'] ?? 0,
      productName: json['product_name'] ?? '',
      productPrice: json['product_price'] ?? '0',
      productDiscount: json['product_discount'] ?? '0',
      productDiscountedPrice: json['product_discounted_price'] ?? '0',
      productImage: json['product_image'] ?? '',
      productRating: json['product_rating'] ?? '0',
      productDescription: json['product_description'] ?? '',
      category: json['category'] != null ? ProductCategory.fromJson(json['category']) : null,
    );
  }

  // Convert to DummyProductModel for UI compatibility
  ProductModel toDummyProductModel({String? category}) {
    // Construct full image URL if the image path is relative
    String fullImageUrl = productImage;
    if (!productImage.startsWith('http')) {
      fullImageUrl = "$imageBaseUrl$productImage";
    }
    
    // Use the real category name from the nested category object
    String categoryName = category ?? this.category?.name ?? 'Product';
    
    return ProductModel(
      id: id.toString(),
      productTitle: productName,
      productPrice: double.tryParse(productDiscountedPrice) ?? 0.0,
      productOriginalPrice: double.tryParse(productPrice) ?? 0.0,
      productImageUrl: fullImageUrl,
      productRating: double.tryParse(productRating) ?? 0.0,
      productCategory: categoryName,
      isProductFavourite: false,
    );
  }
}

class ProductCategory {
  final int id;
  final String name;
  final String image;

  ProductCategory({
    required this.id,
    required this.name,
    required this.image,
  });

  factory ProductCategory.fromJson(Map<String, dynamic> json) {
    return ProductCategory(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      image: json['image'] ?? '',
    );
  }
}
