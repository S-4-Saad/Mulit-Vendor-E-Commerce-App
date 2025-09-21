import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:speezu/presentation/order_details/bloc/order_details_event.dart';
import 'package:speezu/presentation/order_details/bloc/order_details_state.dart';

class OrderDetailsBloc extends Bloc<OrderDetailsEvent,OrderDetailsState>{
  OrderDetailsBloc():super(OrderDetailsState()) {
    on<UpdateRating>(_onUpdateRating);
  }
  void _onUpdateRating(UpdateRating event, Emitter<OrderDetailsState> emit) {
    emit(state.copyWith(rating: event.rating));
  }
}