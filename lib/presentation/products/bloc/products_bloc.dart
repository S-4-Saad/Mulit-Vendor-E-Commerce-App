import 'package:bloc/bloc.dart';
import 'package:speezu/presentation/products/bloc/products_event.dart';
import 'package:speezu/presentation/products/bloc/products_state.dart';

class ProductsBloc extends Bloc<ProductsEvent, ProductsState> {
  ProductsBloc() : super(ProductsState()) {
    on<ChangeTabEvent>(_changeTab);
  }
  void _changeTab(ChangeTabEvent event, Emitter<ProductsState> emit) {
    emit(state.copyWith(selectedTabIndex: event.index));
  }
}
