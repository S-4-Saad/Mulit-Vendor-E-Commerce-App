import 'package:equatable/equatable.dart';

class ProductDetailState extends Equatable {
  final bool isBottomSheetVisible;

  const ProductDetailState({this.isBottomSheetVisible = true});

  ProductDetailState copyWith({bool? isBottomSheetVisible}) {
    return ProductDetailState(
      isBottomSheetVisible: isBottomSheetVisible ?? this.isBottomSheetVisible,
    );
  }

  @override
  List<Object?> get props => [isBottomSheetVisible];
}
