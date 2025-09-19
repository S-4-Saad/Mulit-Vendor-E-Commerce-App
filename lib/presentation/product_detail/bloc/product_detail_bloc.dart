import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:speezu/presentation/product_detail/bloc/product_detail_event.dart';
import 'package:speezu/presentation/product_detail/bloc/product_detail_state.dart';

class ProductDetailBloc extends Bloc<ProductDetailEvent, ProductDetailState> {
  ProductDetailBloc() : super(const ProductDetailState()) {
    on<ShowBottomBar>((event, emit) {
      emit(state.copyWith(isBottomSheetVisible: true));
    });

    on<HideBottomBar>((event, emit) {
      emit(state.copyWith(isBottomSheetVisible: false));
    });
  }
}
