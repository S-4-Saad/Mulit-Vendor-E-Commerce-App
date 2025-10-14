
import 'package:equatable/equatable.dart';

import '../../../models/product_model.dart';
enum ProductsStatus { initial, loading, success, error }
class ProductsState extends Equatable {
  final int selectedTabIndex;
  final Map<String, List<ProductModel>> productsByCategory;
  final Map<String, ProductsStatus> statusByCategory;
  final Map<String, String> messageByCategory;

  const ProductsState({
    this.selectedTabIndex = 0,
    this.productsByCategory = const {},
    this.statusByCategory = const {},
    this.messageByCategory = const {},
  });

  ProductsState copyWith({
    int? selectedTabIndex,
    Map<String, List<ProductModel>>? productsByCategory,
    Map<String, ProductsStatus>? statusByCategory,
    Map<String, String>? messageByCategory,
  }) {
    return ProductsState(
      selectedTabIndex: selectedTabIndex ?? this.selectedTabIndex,
      productsByCategory: productsByCategory ?? this.productsByCategory,
      statusByCategory: statusByCategory ?? this.statusByCategory,
      messageByCategory: messageByCategory ?? this.messageByCategory,
    );
  }

  @override
  List<Object?> get props =>
      [selectedTabIndex, productsByCategory, statusByCategory, messageByCategory];
}
