import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/services/api_services.dart';
import '../../../core/services/urls.dart';
import '../../../models/slide.dart';
import 'home_event.dart';
import 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  HomeBloc() : super(const HomeState()) {
    on<LoadHomeData>((event, emit) async {
      emit(state.copyWith(status: HomeStatus.loading));

      try {
        await ApiService.getMethod(
          apiUrl: dashboardBannersUrl,
          queryParameters: {
            'with': 'food;restaurant',
            'search': 'enabled:1',
            'orderBy': 'order',
            'sortedBy': 'asc',
          },
          executionMethod: (bool success, dynamic responseData) async {
            if (success) {
              SlidesModel slidesModel = SlidesModel.fromJson(responseData);

              emit(state.copyWith(
                status: HomeStatus.success,
                slidesModel: slidesModel,

                message: "Welcome to Home Screen via BLoC!",
              ));
            }
          },
        );
      } catch (e, stackTrace) {
        print('Exception caught during login: $e');
        print(stackTrace);
        emit(state.copyWith(
          status: HomeStatus.error,
          message: e.toString(),
        ));
      }
    });
  }
}
