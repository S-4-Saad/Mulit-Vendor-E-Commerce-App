import 'package:bloc/bloc.dart';
import 'package:speezu/presentation/orders/bloc/order_state.dart';
import 'package:speezu/presentation/orders/bloc/orders_event.dart';

class OrdersBloc extends Bloc<OrdersEvent, OrderState> {
  OrdersBloc() : super(OrderState()) {
    on<ChangeOrdersTabEvent>(_changeTab);
  }
  void _changeTab(ChangeOrdersTabEvent event, Emitter<OrderState> emit) {
    emit(state.copyWith(selectedTabIndex: event.index));
  }
}
