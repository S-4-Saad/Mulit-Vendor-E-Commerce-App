import 'package:equatable/equatable.dart';

class ShopState extends Equatable {
  final String message;
  final int tabCurrentIndex;

  ShopState({this.message = '', this.tabCurrentIndex = 0});
  ShopState copyWith({String? message, int? tabCurrentIndex}) {
    return ShopState(message: message ?? this.message, tabCurrentIndex: tabCurrentIndex ?? this.tabCurrentIndex);
  }

  @override
  List<Object?> get props => [message, tabCurrentIndex];
}
