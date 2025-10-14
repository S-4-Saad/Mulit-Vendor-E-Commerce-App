import 'package:equatable/equatable.dart';
import 'package:speezu/models/search_product_model.dart';

enum SearchProductsStatus { initial, loading, success, error }

class SearchProductsState extends Equatable {
  final List<String>? productNames;
  final List<String>? categoryNames;
  final String searchQuery;
  final List<String>? searchTags;
  final List<String> searchHistory;
  final SearchProductsStatus searchProductsStatus;
  final SearchModel? searchModel;
final  List<Products>? searchProducts;
 final List<Stores>? searchStores;
  final String? message;
  SearchProductsState({
    this.productNames,
    this.categoryNames,
    this.searchQuery = '', // New: Search query
    this.searchTags,
    this.searchHistory = const [],
    this.searchProductsStatus = SearchProductsStatus.initial,
    this.searchModel,
    this.searchProducts,
    this.searchStores,
    this.message,
  });
  SearchProductsState copyWith({
    String? searchQuery,
    List<String>? productNames,
    List<String>? categoryNames,
    List<String>? searchTags,
    List<String>? filteredSuggestions,
    List<String>? searchHistory,
    SearchProductsStatus? searchProductsStatus,
    SearchModel? searchModel,
    List<Products>? searchProducts,
    List<Stores>? searchStores,
    String? message,
  }) {
    return SearchProductsState(
      searchQuery: searchQuery ?? this.searchQuery,
      searchTags: searchTags ?? this.searchTags,
      productNames: productNames ?? this.productNames,

      categoryNames: categoryNames ?? this.categoryNames,
      searchHistory: searchHistory ?? this.searchHistory,
      searchProductsStatus: searchProductsStatus ?? this.searchProductsStatus,
      searchModel: searchModel ?? this.searchModel,
      searchProducts: searchProducts ?? this.searchProducts,
      searchStores: searchStores ?? this.searchStores,
      message: message ?? this.message,
    );
  }

  @override
  // TODO: implement props
  List<Object?> get props => [
    productNames,
    categoryNames,
    searchQuery,
    searchTags,
    searchHistory,
    searchProductsStatus,
    searchModel,
    searchProducts,
    searchStores,
    message,
  ];
}
