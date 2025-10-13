import 'package:equatable/equatable.dart';
import 'package:speezu/models/order_detail_model.dart';

enum OrderDetailStatus { initial, loading, success, error }
enum AddReviewStatus { initial, loading, success, error }

class OrderDetailsState extends Equatable {
  final int rating;
  final OrderDetailStatus status;
  final AddReviewStatus addReviewStatus;
  final OrderDetailModel? orderDetailModel;
  final String? message;

  const OrderDetailsState({
    this.rating = 0,
    this.status = OrderDetailStatus.initial,
    this.addReviewStatus = AddReviewStatus.initial,
    this.orderDetailModel,
    this.message,
  });

  OrderDetailsState copyWith({
    int? rating,
    OrderDetailStatus? status,
    AddReviewStatus? addReviewStatus,
    OrderDetailModel? orderDetailModel,
    String? message,
  }) {
    return OrderDetailsState(
      rating: rating ?? this.rating,
      status: status ?? this.status,
      addReviewStatus: addReviewStatus ?? this.addReviewStatus,
      orderDetailModel: orderDetailModel ?? this.orderDetailModel,
      message: message ?? this.message,
    );
  }

  @override
  List<Object?> get props => [rating, status, orderDetailModel, message, addReviewStatus];
}
