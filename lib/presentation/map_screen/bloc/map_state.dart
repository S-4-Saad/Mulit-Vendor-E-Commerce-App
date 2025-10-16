import 'package:equatable/equatable.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../../../models/shop_model.dart';

abstract class MapState extends Equatable {
  const MapState();

  @override
  List<Object?> get props => [];
}

class MapInitial extends MapState {
  const MapInitial();
}

class MapLoading extends MapState {
  final String message;

  const MapLoading(this.message);

  @override
  List<Object> get props => [message];
}

class MapLoaded extends MapState {
  final LatLng? currentPosition;
  final bool isLocationEnabled;
  final MapType mapType;
  final GoogleMapController? controller;
  final CameraPosition cameraPosition;
  final Set<Marker> markers;
  final List<ShopModel> restaurants;
  final bool isLoadingRestaurants;

  const MapLoaded({
    this.currentPosition,
    required this.isLocationEnabled,
    required this.mapType,
    this.controller,
    required this.cameraPosition,
    this.markers = const {},
    this.restaurants = const [],
    this.isLoadingRestaurants = false,
  });

  @override
  List<Object?> get props => [
        currentPosition,
        isLocationEnabled,
        mapType,
        controller,
        cameraPosition,
        markers,
        restaurants,
        isLoadingRestaurants,
      ];

  MapLoaded copyWith({
    LatLng? currentPosition,
    bool? isLocationEnabled,
    MapType? mapType,
    GoogleMapController? controller,
    CameraPosition? cameraPosition,
    Set<Marker>? markers,
    List<ShopModel>? restaurants,
    bool? isLoadingRestaurants,
  }) {
    return MapLoaded(
      currentPosition: currentPosition ?? this.currentPosition,
      isLocationEnabled: isLocationEnabled ?? this.isLocationEnabled,
      mapType: mapType ?? this.mapType,
      controller: controller ?? this.controller,
      cameraPosition: cameraPosition ?? this.cameraPosition,
      markers: markers ?? this.markers,
      restaurants: restaurants ?? this.restaurants,
      isLoadingRestaurants: isLoadingRestaurants ?? this.isLoadingRestaurants,
    );
  }
}

class MapError extends MapState {
  final String error;
  final MapLoaded? previousState;

  const MapError(this.error, {this.previousState});

  @override
  List<Object?> get props => [error, previousState];
}

class MapLocationPermissionDenied extends MapState {
  const MapLocationPermissionDenied();
}

class MapLocationPermissionDeniedPermanently extends MapState {
  const MapLocationPermissionDeniedPermanently();
}

class MapLocationServiceDisabled extends MapState {
  const MapLocationServiceDisabled();
}
