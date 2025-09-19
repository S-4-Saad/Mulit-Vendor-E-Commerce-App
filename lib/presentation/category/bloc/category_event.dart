import 'package:equatable/equatable.dart';

abstract class CategoryEvent extends Equatable{
  @override
  List<Object?> get props => [];
}

class ChangeViewEvent extends CategoryEvent{
}

class LoadShopsEvent extends CategoryEvent{
  final String category;
  LoadShopsEvent({required this.category});
  @override
  List<Object?> get props => [category];
}