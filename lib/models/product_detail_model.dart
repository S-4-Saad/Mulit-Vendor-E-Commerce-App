class ProductDetail {
  final String name;
  final String thumbnail;
  final List<String> images;
  final String categoryName;
  final String subCategoryName;
  final String shopName;
  final String description;
  final ShopBoxModel shop;
  final List<ProductVariation> variations;
  final double rating ; // Example rating
  final double price ; // Example price
  final double originalPrice ; // Example original price
  final bool isFavourite ; // Example favourite status
  final bool isDeliveryAvailable;// Example delivery status
  final bool isAvailable;// Example delivery status
  final double productDiscountPercentage ;

  ProductDetail({
    required this.name,
    required this.thumbnail,
    required this.images,
    required this.categoryName,
    required this.subCategoryName,
    required this.shopName,
    required this.description,
    required this.shop,
    required this.variations,
    required this.rating,
    required this.price,
    required this.originalPrice,
    required this.isFavourite,
    required this.isDeliveryAvailable,
    required this.isAvailable,
    required this.productDiscountPercentage,
  });
}

class ShopBoxModel {
  final String name;
  final String imageUrl;
  final double rating;
  final String categoryName;

  ShopBoxModel({
    required this.name,
    required this.imageUrl,
    required this.rating,
    required this.categoryName,
  });
}

class ProductVariation {
  final String parentName;          // e.g. "Fajita", "Malai Boti"
  final String parentOptionName;    // e.g. "Flavor"
  final double parentPrice;
  final List<ProductSubVariation> children;

  ProductVariation({
    required this.parentName,
    required this.parentOptionName,
    required this.parentPrice,
    required this.children,
  });
}

class ProductSubVariation {
  final String name;                // e.g. "Large", "Medium", "Small"
  final String childOptionName;     // e.g. "Size"
  final double price;
  final int stock;
  final int stockTotal;

  ProductSubVariation({
    required this.name,
    required this.childOptionName,
    required this.price,
    required this.stock,
    required this.stockTotal,
  });
}
