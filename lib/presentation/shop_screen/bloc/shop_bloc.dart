import 'package:bloc/bloc.dart';
import 'package:speezu/presentation/shop_screen/bloc/shop_event.dart';
import 'package:speezu/presentation/shop_screen/bloc/shop_state.dart';
import 'package:speezu/core/services/api_services.dart';
import 'package:speezu/core/services/urls.dart';
import 'package:speezu/models/store_detail_model.dart';

class ShopBloc extends Bloc<ShopEvent, ShopState> {
  ShopBloc() : super(ShopState()) {
    on<ChangeTabEvent>(_changeTab);
    on<LoadShopDetailEvent>(_loadShopDetail);
  }
  
  void _changeTab(ChangeTabEvent event, Emitter<ShopState> emit) {
    emit(state.copyWith(tabCurrentIndex: event.index));
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
}
