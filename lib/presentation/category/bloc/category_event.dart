import 'package:equatable/equatable.dart';

abstract class CategoryEvent extends Equatable{
  @override
  List<Object?> get props => [];
}

class ChangeViewEvent extends CategoryEvent{
}

class LoadShopsEvent extends CategoryEvent{
  final String category;
  final int categoryId;
  LoadShopsEvent({required this.category,required this.categoryId});
  @override
  List<Object?> get props => [category,categoryId];
}