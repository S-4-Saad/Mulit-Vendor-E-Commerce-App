import 'package:bloc/bloc.dart';
import 'package:speezu/presentation/category/bloc/category_event.dart';

import 'category_state.dart';

class CategoryBloc extends Bloc<CategoryEvent,CategoryState> {
  CategoryBloc() : super(CategoryState()) {
    on<ChangeViewEvent>(_changeView);
  }
  void _changeView(ChangeViewEvent event, Emitter<CategoryState> emit) {
    // Toggle the value instead of using the incoming one
    emit(state.copyWith(isGridView: !state.isGridView));
  }
}