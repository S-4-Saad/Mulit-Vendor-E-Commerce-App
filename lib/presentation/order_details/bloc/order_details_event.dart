abstract class OrderDetailsEvent {}
class UpdateRating extends OrderDetailsEvent {
  final int rating;
  UpdateRating(this.rating);
}