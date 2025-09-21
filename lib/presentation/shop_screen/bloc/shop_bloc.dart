import 'package:bloc/bloc.dart';
import 'package:speezu/presentation/shop_screen/bloc/shop_event.dart';
import 'package:speezu/presentation/shop_screen/bloc/shop_state.dart';
import 'package:speezu/core/services/api_services.dart';
import 'package:speezu/core/services/urls.dart';
import 'package:speezu/models/store_detail_model.dart';
import 'package:speezu/models/category_model.dart';
import 'package:speezu/models/category_products_model.dart';
import 'package:speezu/models/product_model.dart';
import 'package:speezu/models/store_model.dart';
import 'package:speezu/core/assets/app_images.dart';
import 'package:speezu/core/utils/labels.dart';

class ShopBloc extends Bloc<ShopEvent, ShopState> {
  ShopBloc() : super(ShopState()) {
    on<ChangeTabEvent>(_changeTab);
    on<LoadShopDetailEvent>(_loadShopDetail);
    on<LoadCategoriesEvent>(_loadCategories);
    on<LoadProductsEvent>(_loadProducts);
    on<ClearStoreDataEvent>(_clearStoreData);
  }
  
  void _changeTab(ChangeTabEvent event, Emitter<ShopState> emit) {
    emit(state.copyWith(tabCurrentIndex: event.index));
  }

  void _clearStoreData(ClearStoreDataEvent event, Emitter<ShopState> emit) {
    emit(ShopState()); // Reset to initial state
  }

  void _loadShopDetail(LoadShopDetailEvent event, Emitter<ShopState> emit) async {
    emit(state.copyWith(shopDetailStatus: ShopDetailStatus.loading));

    try {
      final apiUrl = '$shopDetailUrl${event.storeId}';

      await ApiService.getMethod(
        apiUrl: apiUrl,
        executionMethod: (bool success, dynamic responseData) async {
          if (success) {
            try {
              StoreDetailModel storeDetailModel = StoreDetailModel.fromJson(responseData);
              if (storeDetailModel.stores != null && storeDetailModel.stores!.isNotEmpty) {
                emit(state.copyWith(
                  shopDetailStatus: ShopDetailStatus.success,
                  storeDetail: storeDetailModel.stores!.first,
                  message: storeDetailModel.message,
                ));
              } else {
                emit(state.copyWith(
                  shopDetailStatus: ShopDetailStatus.error,
                  message: 'No store details found',
                ));
              }
            } catch (e) {
              print('Error parsing store detail data: $e');
              emit(state.copyWith(
                shopDetailStatus: ShopDetailStatus.error,
                message: 'Failed to parse store details',
              ));
            }
          } else {
            emit(state.copyWith(
              shopDetailStatus: ShopDetailStatus.error,
              message: responseData['message'] ?? 'Failed to load store details',
            ));
          }
        },
      );
    } catch (e) {
      print('Exception caught during store detail loading: $e');
      emit(state.copyWith(
        shopDetailStatus: ShopDetailStatus.error,
        message: 'Failed to load store details: $e',
      ));
    }
  }

  void _loadCategories(LoadCategoriesEvent event, Emitter<ShopState> emit) async {
    // Clear previous store data when loading new store
    emit(state.copyWith(
      categoriesStatus: CategoriesStatus.loading,
      categories: [],
      currentProducts: [],
      currentCategoryId: null,
      tabCurrentIndex: 0,
    ));

    try {
      final apiUrl = '$resCategoriesUrl${event.storeId}';

      await ApiService.getMethod(
        apiUrl: apiUrl,
        executionMethod: (bool success, dynamic responseData) async {
          if (success) {
            try {
              CategoryModel categoryModel = CategoryModel.fromJson(responseData);
              if (categoryModel.success && categoryModel.categories.isNotEmpty) {
                // Convert server categories to UI categories
                List<Category> uiCategories = categoryModel.categories
                    .map((cat) => cat.toCategory())
                    .toList();

                // Create "All Products" category with id "0" as first item
                final allProductsCategory = Category(
                  id: "0",
                  name: Labels.allProducts,
                  imageUrl: AppImages.allProducts,
                  products: [], // Will be populated with all products later
                );

                // Combine "All Products" with server categories
                final categoriesWithAll = [allProductsCategory, ...uiCategories];

                emit(state.copyWith(
                  categoriesStatus: CategoriesStatus.success,
                  categories: categoriesWithAll,
                  message: categoryModel.message,
                ));
              } else {
                // If no categories from server, still create "All Products" category
                final allProductsCategory = Category(
                  id: "0",
                  name: Labels.allProducts,
                  imageUrl: AppImages.allProducts,
                  products: [],
                );

                emit(state.copyWith(
                  categoriesStatus: CategoriesStatus.success,
                  categories: [allProductsCategory],
                  message: 'No categories found',
                ));
              }
            } catch (e) {
              print('Error parsing categories data: $e');
              emit(state.copyWith(
                categoriesStatus: CategoriesStatus.error,
                message: 'Failed to parse categories',
              ));
            }
          } else {
            emit(state.copyWith(
              categoriesStatus: CategoriesStatus.error,
              message: responseData['message'] ?? 'Failed to load categories',
            ));
          }
        },
      );
    } catch (e) {
      print('Exception caught during categories loading: $e');
      emit(state.copyWith(
        categoriesStatus: CategoriesStatus.error,
        message: 'Failed to load categories: $e',
      ));
    }
  }

  void _loadProducts(LoadProductsEvent event, Emitter<ShopState> emit) async {
    emit(state.copyWith(
      productsStatus: ProductsStatus.loading,
      currentCategoryId: event.categoryId,
    ));

    try {
      // For "All Products" category (id "0"), we don't need to fetch from server
      // We'll combine products from all categories
      if (event.categoryId == "0") {
        final allProducts = <DummyProductModel>[];
        for (final category in state.categories.skip(1)) {
          // Load products for each category
          final categoryProducts = await _fetchProductsForCategory(event.storeId, category.id);
          allProducts.addAll(categoryProducts);
        }
        
        emit(state.copyWith(
          productsStatus: ProductsStatus.success,
          currentProducts: allProducts,
          message: 'All products loaded successfully',
        ));
        return;
      }

      // Fetch products for specific category
      final products = await _fetchProductsForCategory(event.storeId, event.categoryId);
      
      emit(state.copyWith(
        productsStatus: ProductsStatus.success,
        currentProducts: products,
        message: 'Products loaded successfully',
      ));

    } catch (e) {
      print('Exception caught during products loading: $e');
      emit(state.copyWith(
        productsStatus: ProductsStatus.error,
        message: 'Failed to load products: $e',
      ));
    }
  }

  Future<List<DummyProductModel>> _fetchProductsForCategory(int storeId, String categoryId) async {
    final List<DummyProductModel> products = [];
    
    try {
      final apiUrl = '$resProductsUrl$categoryId?store_id=$storeId';

      await ApiService.getMethod(
        apiUrl: apiUrl,
        executionMethod: (bool success, dynamic responseData) async {
          if (success) {
            try {
              CategoryProductsModel productsModel = CategoryProductsModel.fromJson(responseData);
              if (productsModel.status && productsModel.data.isNotEmpty) {
                products.addAll(
                  productsModel.data.map((product) {
                    // Get the category name from the category object in the product data
                    String categoryName = product.category?.name ?? 'Product';
                    return product.toDummyProductModel(category: categoryName);
                  }).toList()
                );
              }
            } catch (e) {
              print('Error parsing products data: $e');
            }
          }
        },
      );
    } catch (e) {
      print('Error fetching products for category $categoryId: $e');
    }
    
    return products;
  }
}
