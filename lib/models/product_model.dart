class DummyProductModel {
  final String id;
  final String productTitle;
  final double productPrice; // discounted price or final price
  final double productOriginalPrice; // actual/original price
  final String productImageUrl;
  final double productRating;
  final String? productCategory;
  final bool isProductFavourite;

  DummyProductModel({
    required this.id,
    required this.productTitle,
    required this.productPrice,
    required this.productOriginalPrice,
    required this.productImageUrl,
    this.productRating = 0.0,
    this.productCategory,
    this.isProductFavourite = false,
  });
}