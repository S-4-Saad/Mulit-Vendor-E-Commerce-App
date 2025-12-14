import 'dart:convert';

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
          .toList() ??
          [],
      retail: (json['Retail'] as List<dynamic>?)
          ?.map((item) => ApiProductModel.fromJson(item))
          .toList() ??
          [],
      supermarket: (json['Supermarket'] as List<dynamic>?)
          ?.map((item) => ApiProductModel.fromJson(item))
          .toList() ??
          [],
      pharmacy: (json['Pharmacy'] as List<dynamic>?)
          ?.map((item) => ApiProductModel.fromJson(item))
          .toList() ??
          [],
    );
  }
}

class ApiProductModel {
  final int id;
  final int? categoryId;
  final int? storeId;
  final String productName;
  final String productPrice;
  final String productDiscount;
  final String productDiscountedPrice;
  final String productImage;
  final List<String> productMoreImages;
  final String productRating;
  final String? productDescription;

  final bool? isDeliverable;
  final bool? status;
  final String? createdAt;
  final String? updatedAt;

  final ProductStore? store;
  final ProductCategory? category;

  ApiProductModel({
    required this.id,
    this.categoryId,
    this.storeId,
    required this.productName,
    required this.productPrice,
    required this.productDiscount,
    required this.productDiscountedPrice,
    required this.productImage,
    required this.productMoreImages,
    required this.productRating,
    this.productDescription,
    this.isDeliverable,
    this.status,
    this.createdAt,
    this.updatedAt,
    this.store,
    this.category,
  });

  factory ApiProductModel.fromJson(Map<String, dynamic> json) {
    return ApiProductModel(
      id: json['id'] ?? 0,
      categoryId: json['category_id'],
      storeId: json['store_id'],
      productName: json['product_name'] ?? '',
      productPrice: json['product_price'] ?? '0',
      productDiscount: json['product_discount'] ?? '0',
      productDiscountedPrice: json['product_discounted_price'] ?? '0',
      productImage: json['product_image'] ?? '',
      productMoreImages: _parseImages(json['product_more_images']),
      productRating: json['product_rating'] ?? '0',
      productDescription: json['product_description'],
      isDeliverable: json['is_deliverable'],
      status: json['status'],
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
      store: json['store'] != null ? ProductStore.fromJson(json['store']) : null,
      category:
      json['category'] != null ? ProductCategory.fromJson(json['category']) : null,
    );
  }

  // FIXED — handles List AND JSON string
  static List<String> _parseImages(dynamic value) {
    if (value == null) return [];

    if (value is List) {
      return value.map((e) => _fixImageUrl(e.toString())).toList();
    }

    try {
      List<dynamic> list = jsonDecode(value);
      return list.map((e) => _fixImageUrl(e.toString())).toList();
    } catch (_) {
      return [];
    }
  }

  // FIXED — prefix base URL
  static String _fixImageUrl(String img) {
    if (img.startsWith('http')) return img;
    return "$imageBaseUrl$img";
  }

  ProductModel toDummyProductModel({String? category}) {
    String fullImageUrl =
    productImage.startsWith('http') ? productImage : "$imageBaseUrl$productImage";

    String categoryName = category ?? this.category?.name ?? 'Product';
    String storeName = this.store?.name ?? 'Product'; // FIXED

    return ProductModel(
      categoryName: categoryName,
      isDeliverable: isDeliverable ?? false,
      id: id.toString(),
      productTitle: productName,
      productPrice: double.tryParse(productDiscountedPrice) ?? 0.0,
      productOriginalPrice: double.tryParse(productPrice) ?? 0.0,
      productImageUrl: fullImageUrl,
      productRating: double.tryParse(productRating) ?? 0.0,
      productCategory: storeName,
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

class ProductStore {
  final int id;
  final String name;
  final String image;

  ProductStore({
    required this.id,
    required this.name,
    required this.image,
  });

  factory ProductStore.fromJson(Map<String, dynamic> json) {
    return ProductStore(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      image: json['image'] ?? '',
    );
  }
}
