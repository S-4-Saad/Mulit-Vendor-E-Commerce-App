import 'package:bloc/bloc.dart';
import 'package:speezu/presentation/shop_screen/bloc/shop_event.dart';
import 'package:speezu/presentation/shop_screen/bloc/shop_state.dart';

class ShopBloc extends Bloc<ShopEvent, ShopState> {
  ShopBloc() : super(ShopState()) {
    on<ChangeTabEvent>(_changeTab);
  }
  void _changeTab(ChangeTabEvent event, Emitter<ShopState> emit) {
    emit(state.copyWith(tabCurrentIndex: event.index));
  }
}
