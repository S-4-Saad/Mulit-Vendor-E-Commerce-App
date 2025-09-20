import 'package:equatable/equatable.dart';
import '../../../models/shop_model.dart';

enum ShopStatus { initial, loading, success, error }

class CategoryState extends Equatable{
  final bool isGridView;
  final ShopStatus shopStatus;
  final List<ShopModel> shops;
  final String? message;
  final String categoryName;

  CategoryState({
    this.isGridView = true, 
    this.shopStatus = ShopStatus.initial,
    this.shops = const [],
    this.message,
    this.categoryName = 'Categories',
  });

  CategoryState copyWith({
    bool? isGridView,
    ShopStatus? shopStatus,
    List<ShopModel>? shops,
    String? message,
    String? categoryName,
  }) {
    return CategoryState(
      isGridView: isGridView ?? this.isGridView,
      shopStatus: shopStatus ?? this.shopStatus,
      shops: shops ?? this.shops,
      message: message ?? this.message,
      categoryName: categoryName ?? this.categoryName,
    );
  }

  @override
  List<Object?> get props => [isGridView, shopStatus, shops, message, categoryName];
}