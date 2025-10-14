import 'package:equatable/equatable.dart';

abstract class SearchProductsEvent extends Equatable {
  const SearchProductsEvent();

  @override
  List<Object?> get props => [];
}
class LoadSearchHistory extends SearchProductsEvent {}

class AddSearchQuery extends SearchProductsEvent {
  final String query;
  AddSearchQuery(this.query);
}
class ClearSearchHistory extends SearchProductsEvent {}
class SearchProducts extends SearchProductsEvent {
  final String query;

  SearchProducts({required this.query,});

  @override
  List<Object?> get props => [query];
}
class LoadCategoryNamesEvent extends SearchProductsEvent {}
class LoadTagNamesEvent extends SearchProductsEvent {}