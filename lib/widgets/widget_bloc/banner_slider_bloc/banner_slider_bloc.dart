import 'package:bloc/bloc.dart';

import 'banner_slider_event.dart';
import 'banner_slider_state.dart';

class BannerSliderBloc extends Bloc<BannerSliderEvent, BannerSliderState> {
  BannerSliderBloc() : super(BannerSliderState()) {
    on<UpdateBannerIndexEvent>(_onUpdateBannerIndex);
  }
  void _onUpdateBannerIndex(
      UpdateBannerIndexEvent event, Emitter<BannerSliderState> emit) {
    emit(state.copyWith(currentBannerIndex: event.index));
  }
}
