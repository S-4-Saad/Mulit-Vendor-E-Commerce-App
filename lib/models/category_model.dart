// Import the Category class from store_model.dart
import 'package:speezu/models/product_model.dart';
import 'package:speezu/models/store_model.dart';
import 'package:speezu/core/services/urls.dart';

class CategoryModel {
  final bool success;
  final String message;
  final List<CategoryData> categories;

  CategoryModel({
    required this.success,
    required this.message,
    required this.categories,
  });

  factory CategoryModel.fromJson(Map<String, dynamic> json) {
    return CategoryModel(
      success: json['success'] ?? false,
      message: json['Message'] ?? '',
      categories: (json['categories'] as List<dynamic>?)
          ?.map((item) => CategoryData.fromJson(item))
          .toList() ?? [],
    );
  }
}

class CategoryData {
  final int id;
  final String name;
  final String image;

  CategoryData({
    required this.id,
    required this.name,
    required this.image,
  });

  factory CategoryData.fromJson(Map<String, dynamic> json) {
    return CategoryData(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      image: json['image'] ?? '',
    );
  }

  // Convert to Category for UI compatibility
  Category toCategory({List<DummyProductModel> products = const []}) {
    // Construct full image URL if the image path is relative
    String fullImageUrl = image;
    if (!image.startsWith('http')) {
      fullImageUrl = "$imageBaseUrl$image";
    }
    
    return Category(
      id: id.toString(),
      name: name,
      imageUrl: fullImageUrl,
      products: products,
    );
  }
}
