import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:speezu/core/services/api_services.dart';
import '../../../core/services/urls.dart';
import '../../../models/favourite_list_model.dart';
import 'favourite_event.dart';
import 'favourite_state.dart';

class FavouriteBloc extends Bloc<FavouriteEvent, FavouriteState> {
  FavouriteBloc() : super(const FavouriteState()) {
    on<ToggleFavouriteEvent>(_toggleFavourite);
    on<FetchFavouritesEvent>(_fetchFavourites);
  }
  Future<void> _fetchFavourites(
    FetchFavouritesEvent event,
    Emitter<FavouriteState> emit,
  ) async {
    emit(state.copyWith(status: FavouriteStatus.loading));

    try {
      await ApiService.getMethod(
        authHeader: true,
        apiUrl: favouriteListUrl,
        executionMethod: (bool success, dynamic responseData) async {
          if (success) {
            try {
              final favouriteListModel = FavouriteListModel.fromJson(
                responseData,
              );
              emit(
                state.copyWith(
                  status: FavouriteStatus.success,
                  favouriteListModel: favouriteListModel,
                  message: 'Favourites loaded successfully',
                ),
              );
            } catch (e) {
              emit(
                state.copyWith(
                  status: FavouriteStatus.failure,
                  message: 'Error parsing favourites data: $e',
                ),
              );
            }
          } else {
            emit(
              state.copyWith(
                status: FavouriteStatus.failure,
                message: responseData['message'] ?? 'Failed to load favourites',
              ),
            );
          }
        },
      );
    } catch (e) {
      emit(
        state.copyWith(status: FavouriteStatus.failure, message: e.toString()),
      );
    }
  }

  Future<void> _toggleFavourite(
    ToggleFavouriteEvent event,
    Emitter<FavouriteState> emit,
  ) async {
    emit(state.copyWith(toggleStatus: FavouriteToggleStatus.loading));

    final completer = Completer<void>(); // 👈 ensures handler stays alive
    // final productList = state.favouriteListModel?.data ?? [];
    // final existingIndex =
    //     productList.indexWhere((item) => item.id == event.productId);
    // if (existingIndex != -1) {
    //   productList.removeAt(existingIndex);
    //   final updatedModel = state.favouriteListModel?.copyWith(data: productList);
    //   emit(state.copyWith(favouriteListModel: updatedModel));
    // }

    try {
      ApiService.postMethod(
        authHeader: true,
        apiUrl: toggleFavouriteUrl,
        postData: {'product_id': event.productId},
        executionMethod: (bool success, dynamic responseData) async {
          if (emit.isDone) return; // 🛑 prevent crash if already closed


          if (success) {
            emit(
              state.copyWith(
                toggleStatus: FavouriteToggleStatus.success,
                message: responseData['message'],
              ),
            );
            add(FetchFavouritesEvent()); // Refresh the favourites list
          } else {
            emit(
              state.copyWith(
                toggleStatus: FavouriteToggleStatus.failure,
                message:
                    responseData['message'] ?? 'Failed to toggle favourite',
              ),
            );
          }

          if (!completer.isCompleted) completer.complete(); // ✅ end async wait
        },
      );

    } catch (e) {
      emit(
        state.copyWith(
          toggleStatus: FavouriteToggleStatus.failure,
          message: e.toString(),
        ),
      );
      if (!completer.isCompleted) completer.complete();
    }

    // 👇 keep Bloc handler alive until callback finishes
    await completer.future;
  }
}
