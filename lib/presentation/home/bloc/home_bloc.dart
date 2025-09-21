import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/services/api_services.dart';
import '../../../core/services/urls.dart';
import '../../../models/dashboard_products_model.dart';
import 'home_event.dart';
import 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  HomeBloc() : super(const HomeState()) {
    on<LoadHomeData>((event, emit) async {
      emit(state.copyWith(status: HomeStatus.loading));

      try {
        // Load dashboard products only
        await ApiService.getMethod(
          apiUrl: dashboardProductsUrl,
          executionMethod: (bool productsSuccess, dynamic productsResponseData) async {
            if (productsSuccess) {
              DashboardProductsModel dashboardProducts = DashboardProductsModel.fromJson(productsResponseData);
              
              emit(state.copyWith(
                status: HomeStatus.success,
                dashboardProducts: dashboardProducts,
                message: "Dashboard products loaded successfully!",
              ));
            } else {
              emit(state.copyWith(
                status: HomeStatus.error,
                message: "Failed to load products data",
              ));
            }
          },
        );
      } catch (e, stackTrace) {
        print('Exception caught during dashboard products loading: $e');
        print(stackTrace);
        emit(state.copyWith(
          status: HomeStatus.error,
          message: e.toString(),
        ));
      }
    });
  }
}
