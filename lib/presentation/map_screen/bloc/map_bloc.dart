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
  
  // Singleton instance
  static MapBloc? _instance;
  static MapBloc get instance {
    _instance ??= MapBloc._internal();
    return _instance!;
  }
  
  // Private constructor for singleton
  MapBloc._internal() : super(const MapInitial()) {
    _initializeEventHandlers();
  }
  
  // Public constructor for backward compatibility (creates singleton)
  MapBloc() : this._internal();
  
  void _initializeEventHandlers() {
    on<MapInitialized>(_onMapInitialized);
    on<MapScreenShown>(_onMapScreenShown);
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
    // If we already have a loaded state with location, don't reload
    if (state is MapLoaded) {
      final currentState = state as MapLoaded;
      if (currentState.currentPosition != null) {
        return;
      }
    }

    // If we're already loading, don't start another loading process
    if (state is MapLoading) {
      return;
    }

    // Show loading while getting current location
    emit(const MapLoading('Getting your current location...'));

    // Request location permission with timeout
    await _requestLocationWithTimeout();
  }

  void _onMapScreenShown(
    MapScreenShown event,
    Emitter<MapState> emit,
  ) {
    // If we already have a loaded state, just return it
    if (state is MapLoaded) {
      print('MapBloc: Map screen shown, location already available');
      return;
    }

    // If we're in initial state, initialize the map
    if (state is MapInitial) {
      print('MapBloc: Map screen shown, initializing for first time');
      add(const MapInitialized());
    }
  }

  Future<void> _requestLocationWithTimeout() async {
    try {
      // Add a timeout for the entire location request process
      await Future.any([
        _performLocationRequest(),
        Future.delayed(const Duration(seconds: 20), () {
          throw TimeoutException('Location request timed out after 20 seconds');
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

  Future<Position> _getCurrentPositionWithFallback(Emitter<MapState> emit) async {
    // First, try to get last known location (faster)
    try {
      Position? lastKnownPosition = await Geolocator.getLastKnownPosition();
      if (lastKnownPosition != null) {
        // Check if the last known position is recent (within 5 minutes)
        final now = DateTime.now();
        final positionTime = lastKnownPosition.timestamp;
        final age = now.difference(positionTime);
        if (age.inMinutes < 5) {
          return lastKnownPosition;
        }
      }
    } catch (e) {
      print('MapBloc: Last known location not available: $e');
    }

    // Try different accuracy levels in order of preference
    final accuracyLevels = [
      LocationAccuracy.low,      // Fastest, least accurate
      LocationAccuracy.medium,   // Balanced
      LocationAccuracy.high,     // More accurate, slower
    ];

    for (int i = 0; i < accuracyLevels.length; i++) {
      try {
        print('MapBloc: Trying accuracy level ${accuracyLevels[i]} (attempt ${i + 1})');
        
        // Update loading message to show current attempt
        if (i > 0) {
          emit(MapLoading('Trying different location settings... (${i + 1}/${accuracyLevels.length})'));
        }
        
        // Adjust timeout based on attempt - give more time for higher accuracy
        final timeoutSeconds = i == 0 ? 8 : (i == 1 ? 10 : 12);
        final timeLimitSeconds = i == 0 ? 6 : (i == 1 ? 8 : 10);
        
        Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: accuracyLevels[i],
          timeLimit: Duration(seconds: timeLimitSeconds),
        ).timeout(
          Duration(seconds: timeoutSeconds),
          onTimeout: () {
            throw TimeoutException('Location request timed out for ${accuracyLevels[i]}');
          },
        );
        
        print('MapBloc: Successfully got location with ${accuracyLevels[i]} accuracy');
        return position;
      } catch (e) {
        print('MapBloc: Failed with ${accuracyLevels[i]} accuracy: $e');
        
        // If this is the last attempt, rethrow the error
        if (i == accuracyLevels.length - 1) {
          rethrow;
        }
        
        // Wait a bit before trying the next accuracy level (exponential backoff)
        final delay = Duration(milliseconds: 1000 * (i + 1)); // Increased delay
        print('MapBloc: Waiting ${delay.inMilliseconds}ms before next attempt');
        await Future.delayed(delay);
      }
    }
    
    // This should never be reached, but just in case
    throw Exception('All location accuracy levels failed');
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

      // Check location permission status
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        print('MapBloc: Location permission denied');
        emit(const MapLocationPermissionDenied());
        return;
      }

      if (permission == LocationPermission.deniedForever) {
        print('MapBloc: Location permission permanently denied');
        emit(const MapLocationPermissionDenied());
        return;
      }

      print('MapBloc: Requesting current position...');

      // Try to get current position with different accuracy levels
      Position position = await _getCurrentPositionWithFallback(emit);

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
      
      // Provide more user-friendly error messages
      String errorMessage;
      if (e.toString().contains('TimeoutException')) {
        errorMessage = 'Location request timed out. Please check your GPS settings and try again.';
      } else if (e.toString().contains('LocationServiceDisabledException')) {
        errorMessage = 'Location services are disabled. Please enable GPS in your device settings.';
      } else if (e.toString().contains('PermissionDeniedException')) {
        errorMessage = 'Location permission denied. Please enable location access in app settings.';
      } else {
        errorMessage = 'Unable to get your current location. Please check your GPS settings and try again.';
      }
      
      // Emit error state
      emit(MapError(errorMessage));
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
      // If we don't have a loaded state, show error with option to use default location
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
