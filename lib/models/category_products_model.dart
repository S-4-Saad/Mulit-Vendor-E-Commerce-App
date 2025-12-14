import 'package:speezu/models/product_model.dart';
import 'package:speezu/core/services/urls.dart';

class CategoryProductsModel {
  final bool status;
  final String message;
  final List<CategoryProductData> data;

  CategoryProductsModel({
    required this.status,
    required this.message,
    required this.data,
  });

  factory CategoryProductsModel.fromJson(Map<String, dynamic> json) {
    return CategoryProductsModel(
      status: json['status'] ?? false,
      message: json['message'] ?? '',
      data: (json['data'] as List<dynamic>?)
          ?.map((item) => CategoryProductData.fromJson(item))
          .toList() ??
          [],
    );
  }
}

class CategoryProductData {
  final int id;
  final String productName;
  final String productPrice;
  final String productDiscount;
  final String productDiscountedPrice;
  final String productImage;
  final String productRating;
  final String productDescription;
  final ProductCategory? category;
  final ProductStore? store;
  final bool isDeliverable;

  CategoryProductData({
    required this.id,
    required this.productName,
    required this.productPrice,
    required this.productDiscount,
    required this.productDiscountedPrice,
    required this.productImage,
    required this.productRating,
    required this.productDescription,
    required this.isDeliverable,
    this.store,
    this.category,
  });

  factory CategoryProductData.fromJson(Map<String, dynamic> json) {
    return CategoryProductData(
      id: json['id'] ?? 0,
      productName: json['product_name'] ?? '',
      productPrice: json['product_price'] ?? '0',
      productDiscount: json['product_discount'] ?? '0',
      productDiscountedPrice: json['product_discounted_price'] ?? '0',
      productImage: json['product_image'] ?? '',
      productRating: json['product_rating'] ?? '0',
      productDescription: json['product_description'] ?? '',
      isDeliverable: json['is_deliverable'] == true, // ✅ FIXED
      store: json['store'] != null ? ProductStore.fromJson(json['store']) : null,
      category:
      json['category'] != null ? ProductCategory.fromJson(json['category']) : null,
    );
  }

  /// Convert to ProductModel
  ProductModel toDummyProductModel({String? category}) {
    // Fix image path
    String fullImageUrl = productImage.startsWith('http')
        ? productImage
        : "$imageBaseUrl$productImage";

    // Correct category & store name mapping (FIXED)
    String categoryName = category ?? this.category?.name ?? '';
    String storeName = this.store?.name ?? '';

    return ProductModel(
      id: id.toString(),
      productTitle: productName,
      productPrice: double.tryParse(productDiscountedPrice) ?? 0.0,
      productOriginalPrice: double.tryParse(productPrice) ?? 0.0,
      productImageUrl: fullImageUrl,
      productRating: double.tryParse(productRating) ?? 0.0,
      productCategory: storeName, // FIXED
      isDeliverable: isDeliverable,
      categoryName: categoryName,
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
