import 'package:equatable/equatable.dart';
import '../../../models/product_model.dart';

enum ProductsStatus { initial, loading, success, error }

class ProductsState extends Equatable {
  final int selectedTabIndex;
  final ProductsStatus status;
  final List<DummyProductModel> products;
  final String message;
  final String currentCategoryName;

  const ProductsState({
    this.selectedTabIndex = 0,
    this.status = ProductsStatus.initial,
    this.products = const [],
    this.message = '',
    this.currentCategoryName = '',
  });

  ProductsState copyWith({
    int? selectedTabIndex,
    ProductsStatus? status,
    List<DummyProductModel>? products,
    String? message,
    String? currentCategoryName,
  }) {
    return ProductsState(
      selectedTabIndex: selectedTabIndex ?? this.selectedTabIndex,
      status: status ?? this.status,
      products: products ?? this.products,
      message: message ?? this.message,
      currentCategoryName: currentCategoryName ?? this.currentCategoryName,
    );
  }

  @override
  List<Object?> get props => [selectedTabIndex, status, products, message, currentCategoryName];
}
