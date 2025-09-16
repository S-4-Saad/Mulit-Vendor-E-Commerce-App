import 'package:equatable/equatable.dart';

abstract class BannerSliderEvent extends Equatable {
  const BannerSliderEvent();

  @override
  List<Object?> get props => [];
}

class UpdateBannerIndexEvent extends BannerSliderEvent {
  final int index;

  const UpdateBannerIndexEvent(this.index);

  @override
  List<Object?> get props => [index];
}
