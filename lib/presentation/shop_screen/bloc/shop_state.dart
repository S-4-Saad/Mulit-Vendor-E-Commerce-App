import 'package:equatable/equatable.dart';
import '../../../models/store_detail_model.dart';
import '../../../models/store_model.dart';
import '../../../models/product_model.dart';
import '../../../models/store_reviews_model.dart';

enum ShopDetailStatus { initial, loading, success, error }

enum CategoriesStatus { initial, loading, success, error }

enum ProductsStatus { initial, loading, success, error }

enum ShopReviewsStatus { initial, loading, success, error }

class ShopState extends Equatable {
  final String message;
  final int tabCurrentIndex;
  final ShopDetailStatus shopDetailStatus;
  ShopReviewsStatus shopReviewsStatus;
  final StoreDetailModel? storeDetail;
  final CategoriesStatus categoriesStatus;
  final List<Category> categories;
  final ProductsStatus productsStatus;
  final List<ProductModel> currentProducts;
  final String? currentCategoryId;
  final ShopReviewsModel? shopReviewsModel;
  final double? shopDistance;

  ShopState({
    this.message = '',
    this.tabCurrentIndex = 0,
    this.shopDetailStatus = ShopDetailStatus.initial,
    this.shopReviewsStatus = ShopReviewsStatus.initial,
    this.storeDetail,
    this.shopReviewsModel,
    this.categoriesStatus = CategoriesStatus.initial,
    this.categories = const [],
    this.productsStatus = ProductsStatus.initial,
    this.currentProducts = const [],
    this.currentCategoryId,
    this.shopDistance
  });

  ShopState copyWith({
    String? message,
    int? tabCurrentIndex,
    ShopDetailStatus? shopDetailStatus,
    ShopReviewsStatus? shopReviewsStatus,
    StoreDetailModel? storeDetail,
    CategoriesStatus? categoriesStatus,
    ShopReviewsModel? shopReviewsModel,
    List<Category>? categories,
    ProductsStatus? productsStatus,
    List<ProductModel>? currentProducts,
    String? currentCategoryId,
    double? shopDistance
  }) {
    return ShopState(
      message: message ?? this.message,
      tabCurrentIndex: tabCurrentIndex ?? this.tabCurrentIndex,
      shopDetailStatus: shopDetailStatus ?? this.shopDetailStatus,
      storeDetail: storeDetail ?? this.storeDetail,
      categoriesStatus: categoriesStatus ?? this.categoriesStatus,
      categories: categories ?? this.categories,
      productsStatus: productsStatus ?? this.productsStatus,
      shopReviewsModel: shopReviewsModel ?? this.shopReviewsModel,
      shopReviewsStatus: shopReviewsStatus ?? this.shopReviewsStatus,
      currentProducts: currentProducts ?? this.currentProducts,
      currentCategoryId: currentCategoryId ?? this.currentCategoryId,
      shopDistance: shopDistance ?? this.shopDistance
    );
  }

  @override
  List<Object?> get props => [
    message,
    tabCurrentIndex,
    shopDetailStatus,
    storeDetail,
    categoriesStatus,
    categories,
    productsStatus,
    currentProducts,
    currentCategoryId,
    shopReviewsStatus,
    shopReviewsModel,
    shopDistance
  ];
}
