abstract class OrderDetailsEvent {}
class UpdateRating extends OrderDetailsEvent {
  final int rating;
  UpdateRating(this.rating);
}
class FetchOrderDetails extends OrderDetailsEvent {
  final String orderId;
  FetchOrderDetails(this.orderId);
}
class SubmitReviewEvent extends OrderDetailsEvent {
  final String orderId;
  final String review;
  SubmitReviewEvent({
    required this.orderId,
    required this.review,

  });
}
class ResetReviewStatusEvent extends OrderDetailsEvent {}
