class ProductDetail {
  final String id; // Real server product ID
  final String name;
  final String thumbnail;
  final List<String> images;
  final String categoryName;
  final String subCategoryName;
  final String categoryId; // Real server category ID
  final String shopName;
  final String description;
  final ShopBoxModel shop;
  final List<ProductVariation> variations;
  final List<RelatedProduct> relatedProducts;
  final double rating ; // Example rating
  final double price ; // Example price
  final double originalPrice ; // Example original price
  final bool isFavourite ; // Example favourite status
  final bool isDeliveryAvailable;// Example delivery status
  final bool isAvailable;// Example delivery status
  final double productDiscountPercentage ;

  ProductDetail({
    required this.id,
    required this.name,
    required this.thumbnail,
    required this.images,
    required this.categoryName,
    required this.subCategoryName,
    required this.categoryId,
    required this.shopName,
    required this.description,
    required this.shop,
    required this.variations,
    required this.relatedProducts,
    required this.rating,
    required this.price,
    required this.originalPrice,
    required this.isFavourite,
    required this.isDeliveryAvailable,
    required this.isAvailable,
    required this.productDiscountPercentage,
  });
  ProductDetail copyWith({
    String? id,
    double? productDiscountPercentage,
    bool? isAvailable,
    bool? isDeliveryAvailable,
    double? price,
    double? originalPrice,
    double? rating,
    bool? isFavourite,
    String? name,
    String? thumbnail,
    List<String>? images,
    String? categoryName,
    String? subCategoryName,
    String? categoryId,
    String? shopName,
    String? description,
    ShopBoxModel? shop,
    List<ProductVariation>? variations,
    List<RelatedProduct>? relatedProducts,
  }) {
    return ProductDetail(
      id: id ?? this.id,
      productDiscountPercentage:
      productDiscountPercentage ?? this.productDiscountPercentage,
      isAvailable: isAvailable ?? this.isAvailable,
      isDeliveryAvailable: isDeliveryAvailable ?? this.isDeliveryAvailable,
      price: price ?? this.price,
      originalPrice: originalPrice ?? this.originalPrice,
      rating: rating ?? this.rating,
      isFavourite: isFavourite ?? this.isFavourite,
      name: name ?? this.name,
      thumbnail: thumbnail ?? this.thumbnail,
      images: images ?? List<String>.from(this.images),
      categoryName: categoryName ?? this.categoryName,
      subCategoryName: subCategoryName ?? this.subCategoryName,
      categoryId: categoryId ?? this.categoryId,
      shopName: shopName ?? this.shopName,
      description: description ?? this.description,
      shop: shop ?? this.shop,
      variations: variations ?? List<ProductVariation>.from(this.variations),
      relatedProducts:
      relatedProducts ?? List<RelatedProduct>.from(this.relatedProducts),
    );
  }

}

class ShopBoxModel {
  final String name;
  final String imageUrl;
  final double rating;
  final String categoryName;
  final int id;

  ShopBoxModel({
    required this.name,
    required this.imageUrl,
    required this.rating,
    required this.categoryName,
    required this.id,
  });
}

class ProductVariation {
  final String id;
  final String parentName;
  final String parentOptionName;
  final double parentPrice;
  final double parentOriginalPrice;
  final double parentDiscountPercentage;
  final List<ProductSubVariation> children;

  ProductVariation({
    required this.id,
    required this.parentName,
    required this.parentOptionName,
    required this.parentPrice,
    required this.parentOriginalPrice,
    required this.parentDiscountPercentage,
    required this.children,
  });
}

class ProductSubVariation {
  final String id;
  final String name;
  final String childOptionName;
  final double price;
  final double originalPrice;
  final double discountPercentage;
  final int stock;
  final int stockTotal;

  ProductSubVariation({
    required this.id,
    required this.name,
    required this.childOptionName,
    required this.price,
    required this.originalPrice,
    required this.discountPercentage,
    required this.stock,
    required this.stockTotal,
  });
}

class RelatedProduct {
  final String id;
  final String name;
  final double price;
  final double originalPrice;
  final double discountPercentage;
  final String imageUrl;
  final String categoryId;
  final String categoryName;
  final bool isProductFavourite;

  RelatedProduct({
    required this.id,
    required this.name,
    required this.price,
    required this.originalPrice,
    required this.discountPercentage,
    required this.imageUrl,
    required this.categoryId,
    required this.categoryName,
    required this.isProductFavourite
  });
}
