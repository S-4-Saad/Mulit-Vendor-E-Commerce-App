import 'package:equatable/equatable.dart';

abstract class HomeEvent extends Equatable {
  const HomeEvent();

  @override
  List<Object?> get props => [];
}

class LoadHomeData extends HomeEvent {
  final bool forceRefresh; // true if you want to refresh from API

  LoadHomeData({this.forceRefresh = false});
}
