import 'package:equatable/equatable.dart';
import '../../../models/product_detail_model.dart';

enum ProductDetailStatus { initial, loading, success, error }

class ProductDetailState extends Equatable {
  final bool isBottomSheetVisible;
  final ProductDetailStatus status;
  final ProductDetail? productDetail;
  final String? errorMessage;
  final int quantity;

  const ProductDetailState({
    this.isBottomSheetVisible = true, 
    this.status = ProductDetailStatus.initial,
    this.productDetail,
    this.errorMessage,
    this.quantity = 1,
  });

  ProductDetailState copyWith({
    bool? isBottomSheetVisible, 
    ProductDetailStatus? status,
    ProductDetail? productDetail,
    String? errorMessage,
    int? quantity,
  }) {
    return ProductDetailState(
      isBottomSheetVisible: isBottomSheetVisible ?? this.isBottomSheetVisible,
      status: status ?? this.status,
      productDetail: productDetail ?? this.productDetail,
      errorMessage: errorMessage ?? this.errorMessage,
      quantity: quantity ?? this.quantity,
    );
  }

  @override
  List<Object?> get props => [isBottomSheetVisible, status, productDetail, errorMessage, quantity];
}
