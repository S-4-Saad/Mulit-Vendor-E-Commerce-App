import 'package:equatable/equatable.dart';
import 'package:speezu/models/favourite_list_model.dart';

enum FavouriteStatus { initial, loading, success, failure }
enum FavouriteToggleStatus { initial, loading, success, failure }

class FavouriteState extends Equatable{
  final String message;
  final FavouriteStatus status;
  final FavouriteToggleStatus toggleStatus;
  final FavouriteListModel? favouriteListModel;


  const FavouriteState({
    this.message = '',
    this.status = FavouriteStatus.initial,
    this.toggleStatus = FavouriteToggleStatus.initial,
    this.favouriteListModel,
  });

  FavouriteState copyWith({
    String? message,
    FavouriteStatus? status,
    FavouriteToggleStatus? toggleStatus,
    FavouriteListModel? favouriteListModel,
  }) {
    return FavouriteState(
      message: message ?? this.message,
      status: status ?? this.status,
      toggleStatus: toggleStatus ?? this.toggleStatus,
      favouriteListModel: favouriteListModel ?? this.favouriteListModel,
    );
  }
  @override
  List<Object?> get props => [message, status, toggleStatus, favouriteListModel];

}