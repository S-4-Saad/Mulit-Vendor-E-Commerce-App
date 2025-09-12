import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:permission_handler/permission_handler.dart';
import '../../../core/directions_service.dart';
import 'map_event.dart';
import 'map_state.dart';

class MapBloc extends Bloc<MapEvent, MapState> {
  static const CameraPosition _defaultLocation = CameraPosition(
    target: LatLng(37.7749, -122.4194), // San Francisco - fallback
    zoom: 12,
  );

  final DirectionsService _directionsService = DirectionsService();

  MapBloc() : super(const MapInitial()) {
    on<MapInitialized>(_onMapInitialized);
    on<MapLocationPermissionRequested>(_onLocationPermissionRequested);
    on<MapLocationRequested>(_onLocationRequested);
    on<MapCurrentLocationFetched>(_onCurrentLocationFetched);
    on<MapLocationError>(_onLocationError);
    on<MapCameraMoved>(_onCameraMoved);
    on<MapControllerReady>(_onControllerReady);
    on<MapRefreshLocation>(_onRefreshLocation);
    on<MapToggleMapType>(_onToggleMapType);
    on<MapUseDefaultLocation>(_onUseDefaultLocation);
    on<MapDrawRouteToRestaurant>(_onDrawRouteToRestaurant);
    on<MapRouteFetched>(_onRouteFetched);
    on<MapRouteError>(_onRouteError);
    on<MapClearRoute>(_onClearRoute);
  }

  Future<void> _onMapInitialized(
    MapInitialized event,
    Emitter<MapState> emit,
  ) async {
    // Show loading while getting current location
    emit(const MapLoading('Getting your current location...'));

    // Request location permission with timeout
    await _requestLocationWithTimeout();
  }

  Future<void> _requestLocationWithTimeout() async {
    try {
      // Add a timeout for the entire location request process
      await Future.any([
        _performLocationRequest(),
        Future.delayed(const Duration(seconds: 15), () {
          throw TimeoutException('Location request timed out');
        }),
      ]);
    } catch (e) {
      print('MapBloc: Location request failed or timed out - $e');
      // If location fails, show error state
      add(MapLocationError('Unable to get your current location: $e'));
    }
  }

  Future<void> _performLocationRequest() async {
    add(const MapLocationPermissionRequested());
  }

  Future<void> _onLocationPermissionRequested(
    MapLocationPermissionRequested event,
    Emitter<MapState> emit,
  ) async {
    try {
      final status = await Permission.location.request();
      final isEnabled = status.isGranted;

      if (isEnabled) {
        // Automatically request current location when permission is granted
        print('MapBloc: Location permission granted, fetching current location...');
        add(const MapLocationRequested());
      } else {
        // If permission denied, show error
        emit(MapError('Location permission denied. Please enable location access in settings.'));
      }
    } catch (e) {
      print('MapBloc: Permission request failed - $e');
      emit(MapError('Failed to request location permission: $e'));
    }
  }

  Future<void> _onLocationRequested(
    MapLocationRequested event,
    Emitter<MapState> emit,
  ) async {
    // Keep the loading state while fetching location
    emit(const MapLoading('Getting your current location...'));

    try {
      print('MapBloc: Checking location services...');
      // Check if location services are enabled
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        print('MapBloc: Location services disabled');
        emit(const MapLocationServiceDisabled());
        return;
      }

      print('MapBloc: Requesting current position...');

      // Get current position with timeout
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.medium,
        timeLimit: const Duration(seconds: 8),
      ).timeout(
        const Duration(seconds: 10),
        onTimeout: () {
          throw TimeoutException('Location request timed out');
        },
      );

      final newPosition = LatLng(position.latitude, position.longitude);
      final newCameraPosition = CameraPosition(
        target: newPosition,
        zoom: 15,
      );

      print('MapBloc: Location received - Lat: ${position.latitude}, Lng: ${position.longitude}');

      // Emit the loaded state with current location
      emit(MapLoaded(
        currentPosition: newPosition,
        isLocationEnabled: true,
        mapType: MapType.normal,
        cameraPosition: newCameraPosition,
      ));

      // Move camera to current location
      _moveToLocation(newPosition);
    } catch (e) {
      print('MapBloc: Location error - $e');
      // Emit error state
      emit(MapError('Failed to get your current location: $e'));
    }
  }

  void _onCurrentLocationFetched(
    MapCurrentLocationFetched event,
    Emitter<MapState> emit,
  ) {
    if (state is MapLoaded) {
      final currentState = state as MapLoaded;
      final newCameraPosition = CameraPosition(
        target: event.position,
        zoom: 15,
      );

      emit(currentState.copyWith(
        currentPosition: event.position,
        cameraPosition: newCameraPosition,
      ));

      // Move camera to current location
      _moveToLocation(event.position);
    }
  }

  void _onLocationError(
    MapLocationError event,
    Emitter<MapState> emit,
  ) {
    if (state is MapLoaded) {
      emit(MapError(event.error, previousState: state as MapLoaded));
    } else {
      emit(MapError(event.error));
    }
  }

  void _onCameraMoved(
    MapCameraMoved event,
    Emitter<MapState> emit,
  ) {
    if (state is MapLoaded) {
      final currentState = state as MapLoaded;
      emit(currentState.copyWith(cameraPosition: event.position));
    }
  }

  void _onControllerReady(
    MapControllerReady event,
    Emitter<MapState> emit,
  ) {
    if (state is MapLoaded) {
      final currentState = state as MapLoaded;
      emit(currentState.copyWith(controller: event.controller));

      // Move to current location if available
      if (currentState.currentPosition != null) {
        _moveToLocation(currentState.currentPosition!);
      }
    }
  }

  Future<void> _onRefreshLocation(
    MapRefreshLocation event,
    Emitter<MapState> emit,
  ) async {
    if (state is MapLoaded) {
      final currentState = state as MapLoaded;
      if (currentState.isLocationEnabled) {
        add(const MapLocationRequested());
      }
    }
  }

  void _onToggleMapType(
    MapToggleMapType event,
    Emitter<MapState> emit,
  ) {
    if (state is MapLoaded) {
      final currentState = state as MapLoaded;
      emit(currentState.copyWith(mapType: event.mapType));
    }
  }

  Future<void> _moveToLocation(LatLng position) async {
    if (state is MapLoaded) {
      final currentState = state as MapLoaded;
      if (currentState.controller != null) {
        await currentState.controller!.animateCamera(
          CameraUpdate.newLatLngZoom(position, 15),
        );
      }
    }
  }

  // Public methods for external use
  Future<void> moveToLocation(LatLng position) async {
    await _moveToLocation(position);
  }

  Future<void> refreshLocation() async {
    add(const MapRefreshLocation());
  }

  void toggleMapType(MapType mapType) {
    add(MapToggleMapType(mapType));
  }

  void _onUseDefaultLocation(
    MapUseDefaultLocation event,
    Emitter<MapState> emit,
  ) {
    if (state is MapLoaded) {
      final currentState = state as MapLoaded;
      emit(currentState.copyWith(
        currentPosition: null, // Clear current position
        cameraPosition: _defaultLocation, // Use default location
      ));
    }
  }

  Future<void> _onDrawRouteToRestaurant(
    MapDrawRouteToRestaurant event,
    Emitter<MapState> emit,
  ) async {
    if (state is MapLoaded) {
      final currentState = state as MapLoaded;
      
      // Only draw route if we have current position
      if (currentState.currentPosition == null) {
        return;
      }

      // Show loading state
      emit(MapRouteLoading(event.restaurantName));

      try {
        // Fetch directions from Google Directions API
        final directionsResult = await _directionsService.getDirections(
          origin: currentState.currentPosition!,
          destination: event.restaurantLocation,
        );

        if (directionsResult != null && directionsResult.routes.isNotEmpty) {
          final route = directionsResult.routes.first;
          
          // Emit route fetched event
          add(MapRouteFetched(
            routePoints: route.points,
            restaurantName: event.restaurantName,
            distance: route.distance,
            duration: route.duration,
          ));
        } else {
          // Fallback to straight line if API fails
          add(MapRouteError('Failed to fetch route, showing direct path'));
        }
      } catch (e) {
        add(MapRouteError('Error fetching route: $e'));
      }
    }
  }

  void _onRouteFetched(
    MapRouteFetched event,
    Emitter<MapState> emit,
  ) {
    if (state is MapRouteLoading) {
      
      // Create polyline from route points
      final polyline = Polyline(
        polylineId: const PolylineId('route_to_restaurant'),
        points: event.routePoints,
        color: const Color(0xFF1ABC9C), // Teal color to match the button
        width: 4,
        patterns: [],
      );

      // Create marker only for restaurant location
      final restaurantMarker = Marker(
        markerId: const MarkerId('restaurant_location'),
        position: event.routePoints.last,
        infoWindow: InfoWindow(
          title: event.restaurantName,
          snippet: '${(event.distance / 1000).toStringAsFixed(1)} km • ${(event.duration / 60).toStringAsFixed(0)} min',
        ),
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
      );

      // Update state with new polylines and restaurant marker only
      emit(MapLoaded(
        currentPosition: event.routePoints.first,
        isLocationEnabled: true,
        mapType: MapType.normal,
        cameraPosition: CameraPosition(
          target: event.routePoints.first,
          zoom: 15,
        ),
        polylines: {polyline},
        markers: {restaurantMarker},
      ));

      // Move camera to show the route
      _moveToShowRoute(event.routePoints.first, event.routePoints.last);
    }
  }

  void _onRouteError(
    MapRouteError event,
    Emitter<MapState> emit,
  ) {
    // Fallback to straight line if route fetching fails
    if (state is MapRouteLoading) {
      // For now, just show error and let user retry
      emit(MapError(event.error));
    }
  }

  void _onClearRoute(
    MapClearRoute event,
    Emitter<MapState> emit,
  ) {
    if (state is MapLoaded) {
      final currentState = state as MapLoaded;
      emit(currentState.copyWith(
        polylines: const {},
        markers: const {},
      ));
    }
  }

  Future<void> _moveToShowRoute(LatLng start, LatLng end) async {
    if (state is MapLoaded) {
      final currentState = state as MapLoaded;
      if (currentState.controller != null) {
        // Calculate bounds to show both points
        final bounds = _calculateBounds([start, end]);
        await currentState.controller!.animateCamera(
          CameraUpdate.newLatLngBounds(bounds, 100.0),
        );
      }
    }
  }

  LatLngBounds _calculateBounds(List<LatLng> points) {
    double minLat = points.first.latitude;
    double maxLat = points.first.latitude;
    double minLng = points.first.longitude;
    double maxLng = points.first.longitude;

    for (final point in points) {
      minLat = minLat < point.latitude ? minLat : point.latitude;
      maxLat = maxLat > point.latitude ? maxLat : point.latitude;
      minLng = minLng < point.longitude ? minLng : point.longitude;
      maxLng = maxLng > point.longitude ? maxLng : point.longitude;
    }

    return LatLngBounds(
      southwest: LatLng(minLat, minLng),
      northeast: LatLng(maxLat, maxLng),
    );
  }
}
