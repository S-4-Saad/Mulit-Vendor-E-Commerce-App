import 'package:bloc/bloc.dart';
import 'package:speezu/core/services/api_services.dart';
import 'package:speezu/core/services/urls.dart';
import 'package:speezu/core/utils/category_mapper.dart';
import 'package:speezu/models/category_products_model.dart';
import 'package:speezu/presentation/products/bloc/products_event.dart';
import 'package:speezu/presentation/products/bloc/products_state.dart';

class ProductsBloc extends Bloc<ProductsEvent, ProductsState> {
  ProductsBloc() : super(ProductsState()) {
    on<ChangeTabEvent>(_changeTab);
    on<LoadProductsEvent>(_loadProducts);
  }
  
  void _changeTab(ChangeTabEvent event, Emitter<ProductsState> emit) {
    emit(state.copyWith(selectedTabIndex: event.index));
  }

  void _loadProducts(LoadProductsEvent event, Emitter<ProductsState> emit) async {
    print('🔄 Loading products for category: ${event.categoryName}');
    
    // Always emit loading state first
    emit(state.copyWith(
      status: ProductsStatus.loading,
      currentCategoryName: event.categoryName,
      products: [], // Clear previous products
    ));

    try {
      // Get category ID from CategoryMapper
      final categoryId = CategoryMapper.getCategoryId(event.categoryName);
      final apiUrl = '$addProductUrl$categoryId';

      await ApiService.getMethod(
        apiUrl: apiUrl,
        executionMethod: (bool success, dynamic responseData) async {
          if (success) {
            try {
              CategoryProductsModel productsModel = CategoryProductsModel.fromJson(responseData);
              if (productsModel.status && productsModel.data.isNotEmpty) {
                final products = productsModel.data.map((product) {
                  // Get the category name from the category object in the product data
                  String categoryName = product.category?.name ?? event.categoryName;
                  return product.toDummyProductModel(category: categoryName);
                }).toList();

                print('✅ Successfully loaded ${products.length} products for ${event.categoryName}');
                emit(state.copyWith(
                  status: ProductsStatus.success,
                  products: products,
                  message: productsModel.message,
                ));
              } else {
                emit(state.copyWith(
                  status: ProductsStatus.success,
                  products: [],
                  message: 'No products available',
                ));
              }
            } catch (e) {
              print('Error parsing products data: $e');
              emit(state.copyWith(
                status: ProductsStatus.error,
                message: 'Failed to parse products',
              ));
            }
          } else {
            emit(state.copyWith(
              status: ProductsStatus.error,
              message: responseData['message'] ?? 'Failed to load products',
            ));
          }
        },
      );
    } catch (e) {
      print('Exception caught during products loading: $e');
      emit(state.copyWith(
        status: ProductsStatus.error,
        message: 'Failed to load products: $e',
      ));
    }
  }
}
