import 'package:equatable/equatable.dart';
import '../../../models/store_detail_model.dart';

enum ShopDetailStatus { initial, loading, success, error }

class ShopState extends Equatable {
  final String message;
  final int tabCurrentIndex;
  final ShopDetailStatus shopDetailStatus;
  final StoreDetail? storeDetail;

  ShopState({
    this.message = '', 
    this.tabCurrentIndex = 0,
    this.shopDetailStatus = ShopDetailStatus.initial,
    this.storeDetail,
  });
  
  ShopState copyWith({
    String? message, 
    int? tabCurrentIndex,
    ShopDetailStatus? shopDetailStatus,
    StoreDetail? storeDetail,
  }) {
    return ShopState(
      message: message ?? this.message, 
      tabCurrentIndex: tabCurrentIndex ?? this.tabCurrentIndex,
      shopDetailStatus: shopDetailStatus ?? this.shopDetailStatus,
      storeDetail: storeDetail ?? this.storeDetail,
    );
  }

  @override
  List<Object?> get props => [message, tabCurrentIndex, shopDetailStatus, storeDetail];
}
