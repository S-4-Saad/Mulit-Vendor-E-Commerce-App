import 'package:equatable/equatable.dart';

abstract class ShopEvent extends Equatable{
  @override
  List<Object?> get props => [];
}

class ChangeTabEvent extends ShopEvent{
  final int index;
  ChangeTabEvent(this.index);

  @override
  List<Object?> get props => [index];
}