import 'package:equatable/equatable.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

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

class MapDrawRouteToRestaurant extends MapEvent {
  final LatLng restaurantLocation;
  final String restaurantName;

  const MapDrawRouteToRestaurant({
    required this.restaurantLocation,
    required this.restaurantName,
  });

  @override
  List<Object> get props => [restaurantLocation, restaurantName];
}

class MapRouteFetched extends MapEvent {
  final List<LatLng> routePoints;
  final String restaurantName;
  final int distance; // in meters
  final int duration; // in seconds

  const MapRouteFetched({
    required this.routePoints,
    required this.restaurantName,
    required this.distance,
    required this.duration,
  });

  @override
  List<Object> get props => [routePoints, restaurantName, distance, duration];
}

class MapRouteError extends MapEvent {
  final String error;

  const MapRouteError(this.error);

  @override
  List<Object> get props => [error];
}

class MapClearRoute extends MapEvent {
  const MapClearRoute();
}
