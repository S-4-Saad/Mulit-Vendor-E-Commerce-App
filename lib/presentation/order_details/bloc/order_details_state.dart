import 'package:equatable/equatable.dart';

class OrderDetailsState extends Equatable{
  final int rating;
  OrderDetailsState({ this.rating=0});


  OrderDetailsState copyWith({
    int? rating,
  }){
    return OrderDetailsState(
      rating: rating??this.rating,
    );
  }
  @override
  List<Object?> get props => [ rating];
}