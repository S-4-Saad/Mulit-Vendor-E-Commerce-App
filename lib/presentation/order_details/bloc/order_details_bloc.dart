import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:speezu/models/order_detail_model.dart';
import 'package:speezu/presentation/order_details/bloc/order_details_event.dart';
import 'package:speezu/presentation/order_details/bloc/order_details_state.dart';

import '../../../core/services/api_services.dart';
import '../../../core/services/urls.dart';

class OrderDetailsBloc extends Bloc<OrderDetailsEvent, OrderDetailsState> {
  OrderDetailsBloc() : super(OrderDetailsState()) {
    on<UpdateRating>(_onUpdateRating);
    on<FetchOrderDetails>(_onFetchOrderDetails);
    on<SubmitReviewEvent>(_onAddReviewEvent);
    on<ResetReviewStatusEvent>(_onResetReviewStatus);
  }
  void _onUpdateRating(UpdateRating event, Emitter<OrderDetailsState> emit) {
    emit(state.copyWith(rating: event.rating));
  }

  void _onFetchOrderDetails(
    FetchOrderDetails event,
    Emitter<OrderDetailsState> emit,
  ) async {
    emit(state.copyWith(status: OrderDetailStatus.loading));

    try {
      await ApiService.getMethod(
        authHeader: true,
        apiUrl: '$orderDetailUrl${event.orderId}',
        executionMethod: (bool success, dynamic responseData) async {
          if (success) {
            try {
              // Parse into UserModel only when success is true
              OrderDetailModel orderDetailModel = OrderDetailModel.fromJson(
                responseData,
              );
              emit(
                state.copyWith(
                  status: OrderDetailStatus.success,
                  message: responseData['message'] ?? 'Faqs Fetch Successfully',
                  orderDetailModel: orderDetailModel,
                ),
              );
            } catch (e) {
              print('Error: $e');
              emit(
                state.copyWith(
                  status: OrderDetailStatus.error,
                  message: 'Parsing failed',
                ),
              );
            }
          } else {
            // Only handle error case here
            emit(
              state.copyWith(
                status: OrderDetailStatus.error,
                message: responseData['message'] ?? 'Faqs Fetch Failed',
              ),
            );
          }
        },
      );
    } catch (e) {
      emit(
        state.copyWith(
          status: OrderDetailStatus.error,
          message: 'Faqs Fetch Failed: $e',
        ),
      );
    }
  }

  void _onAddReviewEvent(
      SubmitReviewEvent event,
    Emitter<OrderDetailsState> emit,
  ) async {
    emit(state.copyWith(addReviewStatus: AddReviewStatus.loading));

    try {
      await ApiService.postMethod(
        authHeader: true,
        apiUrl: addReviewUrl,
        postData: {
          'review_text': event.review,
          'rating': state.rating,
          'order_id': event.orderId,
        },
        executionMethod: (bool success, dynamic responseData) async {
          if (success) {
            add(FetchOrderDetails(event.orderId));
            emit(
              state.copyWith(
                addReviewStatus: AddReviewStatus.success,
                message: responseData['message'] ?? 'Review Added Successfully',
              ),
            );
          } else {
            emit(
              state.copyWith(
                addReviewStatus: AddReviewStatus.error,
                message: responseData['message'] ?? 'Review Adding Failed',
              ),
            );
          }
        },
      );
    } catch (e) {
      emit(
        state.copyWith(
          addReviewStatus: AddReviewStatus.error,
          message: 'Review Adding Failed: $e',
        ),
      );
    }
  }

  void _onResetReviewStatus(
    ResetReviewStatusEvent event,
    Emitter<OrderDetailsState> emit,
  ) {
    emit(state.copyWith(addReviewStatus: AddReviewStatus.initial));
  }
}
