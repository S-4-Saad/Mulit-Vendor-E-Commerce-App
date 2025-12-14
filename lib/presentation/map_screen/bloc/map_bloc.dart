import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../../../core/services/api_services.dart';
import '../../../core/services/directions_service.dart';
import '../../../core/services/urls.dart';
import '../../../models/shop_model.dart';
import 'map_event.dart';
import 'map_state.dart';

class MapBloc extends Bloc<MapEvent, MapState> {
  static const CameraPosition _defaultLocation = CameraPosition(
    target: LatLng(37.7749, -122.4194), // San Francisco - fallback
    zoom: 12,
  );

  // Store controller reference to ensure camera moves work
  GoogleMapController? _controller;
  // Pending location to move to when controller becomes ready
  LatLng? _pendingCameraPosition;

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
    on<MapFetchNearbyRestaurants>(_onFetchNearbyRestaurants);
    on<MapRestaurantsFetched>(_onRestaurantsFetched);
    on<MapRestaurantsError>(_onRestaurantsError);
    on<MapShowRouteToShop>(_onShowRouteToShop);
    on<MapClearRoute>(_onClearRoute);
    on<MapToggleRestaurantListVisibility>(_onToggleRestaurantListVisibility);
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

  Future<void> _onMapScreenShown(
    MapScreenShown event,
    Emitter<MapState> emit,
  ) async {
    // Always check location permission status when screen is shown
    // This ensures dialogs will show every time if permission is denied or location is off

    // Check if location services are enabled
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      emit(MapLocationServiceDisabled());
      return;
    }

    // Check location permission status
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      emit(MapLocationPermissionDenied());
      return;
    }

    if (permission == LocationPermission.deniedForever) {
      emit(MapLocationPermissionDeniedPermanently());
      return;
    }

    // Permissions are granted! Now initialize the map if needed

    // If we're in a permission denied or service disabled state, initialize the map
    if (state is MapLocationPermissionDenied ||
        state is MapLocationPermissionDeniedPermanently ||
        state is MapLocationServiceDisabled ||
        state is MapInitial) {
      add(const MapInitialized());
      return;
    }

    // If we're already loaded but don't have a position, request location
    if (state is MapLoaded && (state as MapLoaded).currentPosition == null) {
      add(const MapLocationRequested());
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
      // If location fails, show error state
      add(MapLocationError('Unable to get your current location: $e'));
    }
  }

  Future<void> _performLocationRequest() async {
    add(const MapLocationPermissionRequested());
  }

  Future<Position> _getCurrentPositionWithFallback(
    Emitter<MapState> emit,
  ) async {
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
      LocationAccuracy.low, // Fastest, least accurate
      LocationAccuracy.medium, // Balanced
      LocationAccuracy.high, // More accurate, slower
    ];

    for (int i = 0; i < accuracyLevels.length; i++) {
      try {
        // Update loading message to show current attempt
        if (i > 0) {
          emit(
            MapLoading(
              'Trying different location settings... (${i + 1}/${accuracyLevels.length})',
            ),
          );
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
            throw TimeoutException(
              'Location request timed out for ${accuracyLevels[i]}',
            );
          },
        );
        return position;
      } catch (e) {
        // If this is the last attempt, rethrow the error
        if (i == accuracyLevels.length - 1) {
          rethrow;
        }

        // Wait a bit before trying the next accuracy level (exponential backoff)
        final delay = Duration(milliseconds: 1000 * (i + 1)); // Increased delay
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
      // First check if location services are enabled (device-level)
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        emit(MapLocationServiceDisabled());
        return;
      }

      // Check current permission status using geolocator (more reliable for location on iOS)
      LocationPermission geoPermission = await Geolocator.checkPermission();

      if (geoPermission == LocationPermission.denied) {
        // Request permission - this will show iOS system dialog
        geoPermission = await Geolocator.requestPermission();
      }

      if (geoPermission == LocationPermission.whileInUse ||
          geoPermission == LocationPermission.always) {
        // Permission granted, proceed to get location
        add(const MapLocationRequested());
      } else if (geoPermission == LocationPermission.deniedForever) {
        // Permission permanently denied - user needs to go to Settings
        emit(MapLocationPermissionDeniedPermanently());
      } else {
        // Permission denied but can potentially ask again
        emit(MapLocationPermissionDenied());
      }
    } catch (e) {
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
      // Check if location services are enabled
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        emit(MapLocationServiceDisabled());
        return;
      }

      // Check location permission status
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        emit(MapLocationPermissionDenied());
        return;
      }

      if (permission == LocationPermission.deniedForever) {
        emit(MapLocationPermissionDenied());
        return;
      }

      // Try to get current position with different accuracy levels
      Position position = await _getCurrentPositionWithFallback(emit);

      final newPosition = LatLng(position.latitude, position.longitude);
      final newCameraPosition = CameraPosition(target: newPosition, zoom: 15);

      // Emit the loaded state with current location and loading restaurants
      emit(
        MapLoaded(
          currentPosition: newPosition,
          isLocationEnabled: true,
          mapType: MapType.normal,
          cameraPosition: newCameraPosition,
          restaurants: const [],
          isLoadingRestaurants: true, // Start with loading restaurants
        ),
      );

      // Store pending position in case controller isn't ready yet
      _pendingCameraPosition = newPosition;

      // Try to move camera immediately if controller is available
      if (_controller != null) {
        debugPrint(
          '📍 Moving camera to user location immediately: $newPosition',
        );
        _controller!.animateCamera(CameraUpdate.newLatLngZoom(newPosition, 15));
        _pendingCameraPosition = null;
      } else {
        debugPrint(
          '📍 Controller not ready, storing pending position: $newPosition',
        );
      }

      // Wait a bit for camera to move, then fetch nearby restaurants
      Future.delayed(const Duration(milliseconds: 1000), () {
        add(
          MapFetchNearbyRestaurants(
            latitude: position.latitude,
            longitude: position.longitude,
          ),
        );
      });
    } catch (e) {
      // Emit error state with fallback map
      emit(
        MapLoaded(
          currentPosition: null,
          isLocationEnabled: false,
          mapType: MapType.normal,
          cameraPosition: _defaultLocation,
          restaurants: const [],
          isLoadingRestaurants: false,
        ),
      );
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

      emit(
        currentState.copyWith(
          currentPosition: event.position,
          cameraPosition: newCameraPosition,
        ),
      );

      // Move camera to current location
      _moveToLocation(event.position);
    }
  }

  void _onLocationError(MapLocationError event, Emitter<MapState> emit) {
    if (state is MapLoaded) {
      emit(MapError(event.error, previousState: state as MapLoaded));
    } else {
      // If we don't have a loaded state, show error with option to use default location
      emit(MapError(event.error));
    }
  }

  void _onCameraMoved(MapCameraMoved event, Emitter<MapState> emit) {
    if (state is MapLoaded) {
      final currentState = state as MapLoaded;
      emit(currentState.copyWith(cameraPosition: event.position));
    }
  }

  void _onControllerReady(MapControllerReady event, Emitter<MapState> emit) {
    // Store the controller reference for immediate camera moves
    _controller = event.controller;

    if (state is MapLoaded) {
      final currentState = state as MapLoaded;

      // Emit the new state with the controller
      emit(currentState.copyWith(controller: event.controller));

      // Check if we have a pending camera position to move to
      LatLng? targetPosition =
          _pendingCameraPosition ?? currentState.currentPosition;

      if (targetPosition != null) {
        debugPrint('📍 Controller ready, moving camera to: $targetPosition');
        // Use a small delay to ensure the controller is fully initialized
        Future.delayed(const Duration(milliseconds: 100), () async {
          try {
            await _controller?.animateCamera(
              CameraUpdate.newLatLngZoom(targetPosition, 15),
            );
            debugPrint('📍 Camera moved successfully to: $targetPosition');
            _pendingCameraPosition = null; // Clear pending position
          } catch (e) {
            debugPrint('📍 Error moving camera: $e');
          }
        });
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

  void _onToggleMapType(MapToggleMapType event, Emitter<MapState> emit) {
    if (state is MapLoaded) {
      final currentState = state as MapLoaded;
      emit(currentState.copyWith(mapType: event.mapType));
    }
  }

  Future<void> _moveToLocation(LatLng position) async {
    if (state is MapLoaded) {
      final currentState = state as MapLoaded;
      if (currentState.controller != null) {
        try {
          await currentState.controller!.animateCamera(
            CameraUpdate.newLatLngZoom(position, 15),
          );
        } catch (e) {
          // Try alternative method
          try {
            await currentState.controller!.moveCamera(
              CameraUpdate.newCameraPosition(
                CameraPosition(target: position, zoom: 15),
              ),
            );
          } catch (e2) {
            debugPrint('🗺️ Error with moveCamera: $e2');
          }
        }
      }
    }
  }

  void _onUseDefaultLocation(
    MapUseDefaultLocation event,
    Emitter<MapState> emit,
  ) {
    if (state is MapLoaded) {
      final currentState = state as MapLoaded;
      emit(
        currentState.copyWith(
          currentPosition: null,
          cameraPosition: _defaultLocation,
        ),
      );
    }
  }

  Future<void> _onFetchNearbyRestaurants(
    MapFetchNearbyRestaurants event,
    Emitter<MapState> emit,
  ) async {
    if (state is MapLoaded) {
      final currentState = state as MapLoaded;

      // Set loading state
      emit(currentState.copyWith(isLoadingRestaurants: true));

      try {
        // Prepare request data
        final requestData = {
          'latitude': event.latitude,
          'longitude': event.longitude,
        };

        await ApiService.postMethod(
          apiUrl: nearByStoresUrl,
          postData: requestData,
          executionMethod: (bool success, dynamic responseData) async {
            if (success && responseData != null) {
              if (responseData['success'] == true &&
                  responseData['restaurants'] != null) {
                // Parse restaurants from response
                final List<dynamic> restaurantsJson =
                    responseData['restaurants'];
                final List<ShopModel> restaurants =
                    restaurantsJson
                        .map((json) => ShopModel.fromJson(json))
                        .toList();

                // Create restaurant markers
                final Set<Marker> restaurantMarkers =
                    restaurants.map((restaurant) {
                      return Marker(
                        markerId: MarkerId('restaurant_${restaurant.id}'),
                        position: LatLng(
                          restaurant.latitude,
                          restaurant.longitude,
                        ),
                        infoWindow: InfoWindow(
                          title: restaurant.shopName,
                          snippet:
                              '${restaurant.shopRating.toStringAsFixed(1)} ⭐ • ${restaurant.isOpen ? 'Open' : 'Closed'}',
                        ),
                        icon: BitmapDescriptor.defaultMarkerWithHue(
                          restaurant.isOpen
                              ? BitmapDescriptor.hueGreen
                              : BitmapDescriptor.hueRed,
                        ),
                      );
                    }).toSet();

                // Add restaurant markers to existing markers
                final Set<Marker> allMarkers = {
                  ...currentState.markers,
                  ...restaurantMarkers,
                };

                // Emit success with restaurants and markers
                add(MapRestaurantsFetched(restaurants));

                emit(
                  currentState.copyWith(
                    restaurants: restaurants,
                    isLoadingRestaurants: false,
                    markers: allMarkers,
                  ),
                );
              } else {
                add(MapRestaurantsError('No restaurants found nearby'));
              }
            } else {
              add(MapRestaurantsError('Failed to fetch restaurants'));
            }
          },
        );
      } catch (e) {
        add(MapRestaurantsError('Error fetching restaurants: $e'));
      }
    }
  }

  void _onRestaurantsFetched(
    MapRestaurantsFetched event,
    Emitter<MapState> emit,
  ) {
    // This is handled in the _onFetchNearbyRestaurants method
    // No additional action needed here
  }

  void _onRestaurantsError(MapRestaurantsError event, Emitter<MapState> emit) {
    if (state is MapLoaded) {
      final currentState = state as MapLoaded;
      emit(currentState.copyWith(isLoadingRestaurants: false));

      // You could show a snackbar or other error indication here
      print('Restaurant fetch error: ${event.error}');
    }
  }

  /// Handle showing route to a shop
  Future<void> _onShowRouteToShop(
    MapShowRouteToShop event,
    Emitter<MapState> emit,
  ) async {
    if (state is! MapLoaded) return;

    final currentState = state as MapLoaded;

    // Check if we have user's current location
    if (currentState.currentPosition == null) {
      debugPrint('Cannot show route: User location not available');
      return;
    }

    final origin = currentState.currentPosition!;
    final destination = LatLng(event.shop.latitude, event.shop.longitude);

    // Immediately animate camera to show route bounds BEFORE fetching route
    // Use _controller class variable instead of state controller (more reliable)
    if (_controller != null) {
      try {
        final bounds = DirectionsService.calculateBounds(origin, destination);
        debugPrint('📍 Animating camera to show route bounds');
        await _controller!.animateCamera(
          CameraUpdate.newLatLngBounds(bounds, 100),
        );
        debugPrint('📍 Camera animation completed successfully');
      } catch (e) {
        debugPrint('📍 Error animating camera with bounds: $e');
        // Fallback: Try simple camera move to destination
        try {
          debugPrint('📍 Fallback: Moving camera to destination');
          await _controller!.animateCamera(
            CameraUpdate.newLatLngZoom(destination, 14),
          );
        } catch (e2) {
          debugPrint('📍 Fallback camera move also failed: $e2');
        }
      }
    } else {
      debugPrint('📍 Warning: Controller is null, cannot animate camera');
    }

    // Hide restaurant list and set loading state
    emit(
      currentState.copyWith(
        isLoadingRoute: true,
        selectedShop: event.shop,
        isRestaurantListVisible: false,
      ),
    );

    try {
      // Fetch route from Directions API
      final directionsService = DirectionsService();
      final routeInfo = await directionsService.getRoute(
        origin: origin,
        destination: destination,
      );

      // Re-check state after async operation
      if (state is! MapLoaded) return;
      final updatedState = state as MapLoaded;

      if (routeInfo == null) {
        debugPrint('Failed to fetch route - API returned null');
        emit(updatedState.copyWith(isLoadingRoute: false));
        return;
      }

      debugPrint(
        'Route fetched successfully: ${routeInfo.polylinePoints.length} points',
      );

      // Create polyline for the route
      final polyline = Polyline(
        polylineId: const PolylineId('route_to_shop'),
        points: routeInfo.polylinePoints,
        color: Colors.blue,
        width: 5,
        startCap: Cap.roundCap,
        endCap: Cap.roundCap,
        geodesic: true,
      );

      // Update state with route info - use updatedState (fresh state after async)
      emit(
        updatedState.copyWith(
          polylines: {polyline},
          routeDistance: routeInfo.distanceText,
          routeDuration: routeInfo.durationText,
          selectedShop: event.shop,
          isLoadingRoute: false,
        ),
      );

      debugPrint('State emitted with polyline');
    } catch (e) {
      debugPrint('Error showing route: $e');
      if (state is MapLoaded) {
        emit((state as MapLoaded).copyWith(isLoadingRoute: false));
      }
    }
  }

  /// Clear the current route from the map
  void _onClearRoute(MapClearRoute event, Emitter<MapState> emit) {
    if (state is! MapLoaded) return;

    final currentState = state as MapLoaded;
    emit(currentState.copyWith(clearRoute: true));

    // Optionally move camera back to user location
    if (currentState.currentPosition != null) {
      _moveToLocation(currentState.currentPosition!);
    }
  }

  /// Toggle restaurant list visibility
  void _onToggleRestaurantListVisibility(
    MapToggleRestaurantListVisibility event,
    Emitter<MapState> emit,
  ) {
    if (state is! MapLoaded) return;

    final currentState = state as MapLoaded;
    emit(
      currentState.copyWith(
        isRestaurantListVisible: !currentState.isRestaurantListVisible,
      ),
    );
  }
}
