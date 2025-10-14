import 'package:equatable/equatable.dart';

abstract class FavouriteEvent extends Equatable{}

class FetchFavouritesEvent extends FavouriteEvent{
  @override
  List<Object?> get props => [];
}
class ToggleFavouriteEvent extends FavouriteEvent{
  final String productId;

  // final bool currentStatus;
  ToggleFavouriteEvent({required this.productId,
    // required this.currentStatus
  });

  @override
  List<Object?> get props => [productId,
    // currentStatus
  ];
}