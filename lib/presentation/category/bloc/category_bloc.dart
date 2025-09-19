import 'package:bloc/bloc.dart';
import 'package:speezu/presentation/category/bloc/category_event.dart';
import 'package:speezu/core/services/api_services.dart';
import 'package:speezu/core/services/urls.dart';
import 'package:speezu/core/utils/category_mapper.dart';
import 'package:speezu/models/shop_model.dart';

import 'category_state.dart';

class CategoryBloc extends Bloc<CategoryEvent,CategoryState> {
  CategoryBloc() : super(CategoryState()) {
    on<ChangeViewEvent>(_changeView);
    on<LoadShopsEvent>(_loadShops);
  }
  
  void _changeView(ChangeViewEvent event, Emitter<CategoryState> emit) {
    // Toggle the value instead of using the incoming one
    emit(state.copyWith(isGridView: !state.isGridView));
  }

  void _loadShops(LoadShopsEvent event, Emitter<CategoryState> emit) async {
    emit(state.copyWith(
      shopStatus: ShopStatus.loading,
      categoryName: event.category,
    ));

    try {
      final categoryId = CategoryMapper.getCategoryId(event.category);
      final apiUrl = '$shopsUrl$categoryId';

      await ApiService.getMethod(
        apiUrl: apiUrl,
        executionMethod: (bool success, dynamic responseData) async {
          if (success) {
            try {
              ShopsModel shopsModel = ShopsModel.fromJson(responseData);
              emit(state.copyWith(
                shopStatus: ShopStatus.success,
                shops: shopsModel.stores ?? [],
                message: shopsModel.message,
              ));
            } catch (e) {
              print('Error parsing shops data: $e');
              emit(state.copyWith(
                shopStatus: ShopStatus.error,
                message: 'Failed to parse shops data',
              ));
            }
          } else {
            emit(state.copyWith(
              shopStatus: ShopStatus.error,
              message: responseData['message'] ?? 'Failed to load shops',
            ));
          }
        },
      );
    } catch (e) {
      print('Exception caught during shops loading: $e');
      emit(state.copyWith(
        shopStatus: ShopStatus.error,
        message: 'Failed to load shops: $e',
      ));
    }
  }
}