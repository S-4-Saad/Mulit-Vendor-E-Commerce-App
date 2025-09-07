import 'package:equatable/equatable.dart';

import '../../../models/slide.dart';

enum HomeStatus { initial, loading, success, error }

class HomeState extends Equatable {
  final String message;
  final HomeStatus status;
  final SlidesModel? slidesModel;

  const HomeState({
    this.message = '',
    this.status = HomeStatus.initial,
    this.slidesModel,
  });

  HomeState copyWith({
    String? message,
    HomeStatus? status,
    SlidesModel? slidesModel,
  }) {
    return HomeState(
      message: message ?? this.message,
      status: status ?? this.status,
      slidesModel: slidesModel ?? this.slidesModel,
    );
  }

  @override
  List<Object?> get props => [message, status,slidesModel];
}
