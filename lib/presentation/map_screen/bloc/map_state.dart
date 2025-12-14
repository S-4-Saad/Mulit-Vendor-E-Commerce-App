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
  // Route navigation fields
  final Set<Polyline> polylines;
  final String? routeDistance;
  final String? routeDuration;
  final ShopModel? selectedShop;
  final bool isLoadingRoute;
  // Restaurant list visibility
  final bool isRestaurantListVisible;

  const MapLoaded({
    this.currentPosition,
    required this.isLocationEnabled,
    required this.mapType,
    this.controller,
    required this.cameraPosition,
    this.markers = const {},
    this.restaurants = const [],
    this.isLoadingRestaurants = false,
    this.polylines = const {},
    this.routeDistance,
    this.routeDuration,
    this.selectedShop,
    this.isLoadingRoute = false,
    this.isRestaurantListVisible = true,
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
    polylines,
    routeDistance,
    routeDuration,
    selectedShop,
    isLoadingRoute,
    isRestaurantListVisible,
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
    Set<Polyline>? polylines,
    String? routeDistance,
    String? routeDuration,
    ShopModel? selectedShop,
    bool? isLoadingRoute,
    bool? isRestaurantListVisible,
    bool clearRoute = false,
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
      polylines: clearRoute ? const {} : (polylines ?? this.polylines),
      routeDistance: clearRoute ? null : (routeDistance ?? this.routeDistance),
      routeDuration: clearRoute ? null : (routeDuration ?? this.routeDuration),
      selectedShop: clearRoute ? null : (selectedShop ?? this.selectedShop),
      isLoadingRoute: isLoadingRoute ?? this.isLoadingRoute,
      isRestaurantListVisible:
          clearRoute
              ? true
              : (isRestaurantListVisible ?? this.isRestaurantListVisible),
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
  final DateTime timestamp;

  MapLocationPermissionDenied() : timestamp = DateTime.now();

  @override
  List<Object> get props => [timestamp];
}

class MapLocationPermissionDeniedPermanently extends MapState {
  final DateTime timestamp;

  MapLocationPermissionDeniedPermanently() : timestamp = DateTime.now();

  @override
  List<Object> get props => [timestamp];
}

class MapLocationServiceDisabled extends MapState {
  final DateTime timestamp;

  MapLocationServiceDisabled() : timestamp = DateTime.now();

  @override
  List<Object> get props => [timestamp];
}
