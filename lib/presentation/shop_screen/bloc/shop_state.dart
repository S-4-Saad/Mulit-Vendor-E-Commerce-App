import 'package:equatable/equatable.dart';
import '../../../models/store_detail_model.dart';
import '../../../models/store_model.dart';
import '../../../models/product_model.dart';

enum ShopDetailStatus { initial, loading, success, error }
enum CategoriesStatus { initial, loading, success, error }
enum ProductsStatus { initial, loading, success, error }

class ShopState extends Equatable {
  final String message;
  final int tabCurrentIndex;
  final ShopDetailStatus shopDetailStatus;
  final StoreDetailModel? storeDetail;
  final CategoriesStatus categoriesStatus;
  final List<Category> categories;
  final ProductsStatus productsStatus;
  final List<DummyProductModel> currentProducts;
  final String? currentCategoryId;

  ShopState({
    this.message = '', 
    this.tabCurrentIndex = 0,
    this.shopDetailStatus = ShopDetailStatus.initial,
    this.storeDetail,
    this.categoriesStatus = CategoriesStatus.initial,
    this.categories = const [],
    this.productsStatus = ProductsStatus.initial,
    this.currentProducts = const [],
    this.currentCategoryId,
  });
  
  ShopState copyWith({
    String? message, 
    int? tabCurrentIndex,
    ShopDetailStatus? shopDetailStatus,
    StoreDetailModel? storeDetail,
    CategoriesStatus? categoriesStatus,
    List<Category>? categories,
    ProductsStatus? productsStatus,
    List<DummyProductModel>? currentProducts,
    String? currentCategoryId,
  }) {
    return ShopState(
      message: message ?? this.message, 
      tabCurrentIndex: tabCurrentIndex ?? this.tabCurrentIndex,
      shopDetailStatus: shopDetailStatus ?? this.shopDetailStatus,
      storeDetail: storeDetail ?? this.storeDetail,
      categoriesStatus: categoriesStatus ?? this.categoriesStatus,
      categories: categories ?? this.categories,
      productsStatus: productsStatus ?? this.productsStatus,
      currentProducts: currentProducts ?? this.currentProducts,
      currentCategoryId: currentCategoryId ?? this.currentCategoryId,
    );
  }

  @override
  List<Object?> get props => [message, tabCurrentIndex, shopDetailStatus, storeDetail, categoriesStatus, categories, productsStatus, currentProducts, currentCategoryId];
}
