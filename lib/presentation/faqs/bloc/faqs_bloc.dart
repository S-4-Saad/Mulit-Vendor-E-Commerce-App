import 'package:bloc/bloc.dart';
import 'package:speezu/models/faqs_model.dart';

import '../../../core/services/api_services.dart';
import '../../../core/services/urls.dart';
import 'faqs_event.dart';
import 'faqs_state.dart';

class FaqsBloc extends Bloc<FaqsEvent, FaqsState> {
  FaqsBloc() : super(FaqsState()) {
    on<FetchFaqsEvent>(_fetchFaqs);
  }
  void _fetchFaqs(FetchFaqsEvent event, Emitter<FaqsState> emit) async {
    emit(state.copyWith(faqsStatus: FaqsStatus.loading));

    try {
      await ApiService.getMethod(
        apiUrl: faqsUrl,
        executionMethod: (bool success, dynamic responseData) async {
          if (success) {
            try {
              // Parse into UserModel only when success is true
              FaqsModel faqsModel = FaqsModel.fromJson(responseData);
              emit(
                state.copyWith(
                  faqsStatus: FaqsStatus.success,
                  message: responseData['message'] ?? 'Faqs Fetch Successfully',
                  faqsModel: faqsModel,
                ),
              );
            } catch (e) {
              print('Error: $e');
              emit(
                state.copyWith(
                  faqsStatus: FaqsStatus.error,
                  message: 'Parsing failed',
                ),
              );
            }
          } else {
            // Only handle error case here
            emit(
              state.copyWith(
                faqsStatus: FaqsStatus.error,
                message: responseData['message'] ?? 'Faqs Fetch Failed',
              ),
            );
          }
        },
      );
    } catch (e) {
      emit(
        state.copyWith(
          faqsStatus: FaqsStatus.error,
          message: 'Faqs Fetch Failed: $e',
        ),
      );
    }
  }
}
