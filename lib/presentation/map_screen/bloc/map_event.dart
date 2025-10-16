import 'package:equatable/equatable.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../../../models/shop_model.dart';

abstract class MapEvent extends Equatable {
  const MapEvent();

  @override
  List<Object?> get props => [];
}

class MapInitialized extends MapEvent {
  const MapInitialized();
}

class MapScreenShown extends MapEvent {
  const MapScreenShown();
}

class MapLocationRequested extends MapEvent {
  const MapLocationRequested();
}

class MapLocationPermissionRequested extends MapEvent {
  const MapLocationPermissionRequested();
}

class MapCurrentLocationFetched extends MapEvent {
  final LatLng position;

  const MapCurrentLocationFetched(this.position);

  @override
  List<Object> get props => [position];
}

class MapLocationError extends MapEvent {
  final String error;

  const MapLocationError(this.error);

  @override
  List<Object> get props => [error];
}

class MapCameraMoved extends MapEvent {
  final CameraPosition position;

  const MapCameraMoved(this.position);

  @override
  List<Object> get props => [position];
}

class MapControllerReady extends MapEvent {
  final GoogleMapController controller;

  const MapControllerReady(this.controller);

  @override
  List<Object> get props => [controller];
}

class MapRefreshLocation extends MapEvent {
  const MapRefreshLocation();
}

class MapToggleMapType extends MapEvent {
  final MapType mapType;

  const MapToggleMapType(this.mapType);

  @override
  List<Object> get props => [mapType];
}

class MapUseDefaultLocation extends MapEvent {
  const MapUseDefaultLocation();
}

class MapFetchNearbyRestaurants extends MapEvent {
  final double latitude;
  final double longitude;

  const MapFetchNearbyRestaurants({
    required this.latitude,
    required this.longitude,
  });

  @override
  List<Object> get props => [latitude, longitude];
}

class MapRestaurantsFetched extends MapEvent {
  final List<ShopModel> restaurants;

  const MapRestaurantsFetched(this.restaurants);

  @override
  List<Object> get props => [restaurants];
}

class MapRestaurantsError extends MapEvent {
  final String error;

  const MapRestaurantsError(this.error);

  @override
  List<Object> get props => [error];
}
