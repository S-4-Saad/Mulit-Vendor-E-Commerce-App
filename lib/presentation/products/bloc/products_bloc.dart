import 'package:bloc/bloc.dart';
import 'package:speezu/core/services/api_services.dart';
import 'package:speezu/core/services/urls.dart';
import 'package:speezu/core/utils/category_mapper.dart';
import 'package:speezu/models/category_products_model.dart';
import 'package:speezu/presentation/products/bloc/products_event.dart';
import 'package:speezu/presentation/products/bloc/products_state.dart';
class ProductsBloc extends Bloc<ProductsEvent, ProductsState> {
  ProductsBloc() : super(const ProductsState()) {
    on<ChangeTabEvent>(_changeTab);
    on<LoadProductsEvent>(_loadProducts);
  }

  void _changeTab(ChangeTabEvent event, Emitter<ProductsState> emit) {
    emit(state.copyWith(selectedTabIndex: event.index));
  }

  void _loadProducts(
    LoadProductsEvent event,
    Emitter<ProductsState> emit,
  ) async {
    final categoryName = event.categoryName;
    print('🔄 Loading products for category: $categoryName');

    // If already loaded, skip reload (cached)
    if (!event.forceReload &&
        state.productsByCategory[categoryName]?.isNotEmpty == true) {
      print('✅ Using cached products for $categoryName');
      return;
    }

    // Set loading state for this category
    emit(
      state.copyWith(
        statusByCategory: {
          ...state.statusByCategory,
          categoryName: ProductsStatus.loading,
        },
      ),
    );

    try {
      final categoryId = CategoryMapper.getCategoryId(categoryName);
      final apiUrl = '$addProductUrl$categoryId';

      await ApiService.getMethod(
        apiUrl: apiUrl,
        executionMethod: (bool success, dynamic responseData) async {
          if (success) {
            try {
              CategoryProductsModel productsModel =
                  CategoryProductsModel.fromJson(responseData);

              if (productsModel.status && productsModel.data.isNotEmpty) {
                final products =
                    productsModel.data.map((product) {
                      final name = product.category?.name ?? categoryName;
                      return product.toDummyProductModel(category: name);
                    }).toList();

                emit(
                  state.copyWith(
                    productsByCategory: {
                      ...state.productsByCategory,
                      categoryName: products,
                    },
                    statusByCategory: {
                      ...state.statusByCategory,
                      categoryName: ProductsStatus.success,
                    },
                    messageByCategory: {
                      ...state.messageByCategory,
                      categoryName: productsModel.message,
                    },
                  ),
                );
                print('✅ Loaded ${products.length} products for $categoryName');
              } else {
                emit(
                  state.copyWith(
                    productsByCategory: {
                      ...state.productsByCategory,
                      categoryName: [],
                    },
                    statusByCategory: {
                      ...state.statusByCategory,
                      categoryName: ProductsStatus.success,
                    },
                    messageByCategory: {
                      ...state.messageByCategory,
                      categoryName: 'No products available',
                    },
                  ),
                );
              }
            } catch (e) {
              emit(
                state.copyWith(
                  statusByCategory: {
                    ...state.statusByCategory,
                    categoryName: ProductsStatus.error,
                  },
                  messageByCategory: {
                    ...state.messageByCategory,
                    categoryName: 'Failed to parse products',
                  },
                ),
              );
            }
          } else {
            emit(
              state.copyWith(
                statusByCategory: {
                  ...state.statusByCategory,
                  categoryName: ProductsStatus.error,
                },
                messageByCategory: {
                  ...state.messageByCategory,
                  categoryName:
                      responseData['message'] ?? 'Failed to load products',
                },
              ),
            );
          }
        },
      );
    } catch (e) {
      emit(
        state.copyWith(
          statusByCategory: {
            ...state.statusByCategory,
            categoryName: ProductsStatus.error,
          },
          messageByCategory: {
            ...state.messageByCategory,
            categoryName: 'Failed to load products: $e',
          },
        ),
      );
    }
  }
}
