import 'package:equatable/equatable.dart';

class BannerSliderState extends Equatable {
  final int currentBannerIndex;

  const BannerSliderState({this.currentBannerIndex = 0});
  BannerSliderState copyWith({int? currentBannerIndex}) {
    return BannerSliderState(
      currentBannerIndex: currentBannerIndex ?? this.currentBannerIndex,
    );
  }

  @override
  List<Object?> get props => [currentBannerIndex];
}
