import 'package:equatable/equatable.dart';

class CategoryState extends Equatable{
  final bool isGridView;
  CategoryState({this.isGridView = true});

  CategoryState copyWith({bool? isGridView}) {
    return CategoryState(
      isGridView: isGridView ?? this.isGridView,
    );
  }

  @override
  List<Object?> get props => [isGridView];
}