import 'package:equatable/equatable.dart';

class ProductsState extends Equatable {
  final int selectedTabIndex;
  const ProductsState({this.selectedTabIndex = 0});

  ProductsState copyWith({int? selectedTabIndex}) {
    return ProductsState(
      selectedTabIndex: selectedTabIndex ?? this.selectedTabIndex,
    );
  }

  @override
  List<Object?> get props => [selectedTabIndex];
}
