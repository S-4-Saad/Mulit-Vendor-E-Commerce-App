import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:speezu/routes/route_names.dart';
import '../../widgets/restaurant_list.dart';
import '../../widgets/dialog_boxes/permission_dialog.dart';
import '../../widgets/restaurant_shimmer_widget.dart';
import '../../core/services/map_launcher_service.dart';
import '../../core/utils/map_styles.dart';
import '../../core/theme/app_theme.dart';
import '../../core/theme/theme_bloc/theme_bloc.dart';
import 'bloc/map_bloc.dart';
import 'bloc/map_event.dart';
import 'bloc/map_state.dart';

class MapScreen extends StatelessWidget {
  const MapScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(value: MapBloc.instance, child: const MapView());
  }
}

class MapView extends StatefulWidget {
  const MapView({super.key});

  @override
  State<MapView> createState() => _MapViewState();
}

class _MapViewState extends State<MapView> with WidgetsBindingObserver {
  GoogleMapController? _mapController;

  @override
  void initState() {
    super.initState();
    // Add lifecycle observer to detect app resume
    WidgetsBinding.instance.addObserver(this);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<MapBloc>().add(const MapScreenShown());
    });
  }

  @override
  void dispose() {
    // Remove lifecycle observer
    WidgetsBinding.instance.removeObserver(this);
    _mapController?.dispose();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);

    // When app resumes from background, re-check location permissions
    if (state == AppLifecycleState.resumed) {
      context.read<MapBloc>().add(const MapScreenShown());
    }
  }

  /// Get current map style based on theme
  String _getCurrentMapStyle() {
    final themeMode = context.read<ThemeBloc>().state.themeMode;
    final isDark = themeMode == AppThemeMode.dark;
    return isDark ? MapStyles.darkMode : MapStyles.lightMode;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocConsumer<MapBloc, MapState>(
        listener: (context, state) {
          if (state is MapError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.error),
                backgroundColor: Colors.red,
                duration: const Duration(seconds: 5),
                action: SnackBarAction(
                  label: 'Use Default',
                  textColor: Colors.white,
                  onPressed: () {
                    context.read<MapBloc>().add(const MapUseDefaultLocation());
                  },
                ),
              ),
            );
          } else if (state is MapLocationPermissionDenied) {
            // Permission denied but can be requested again
            WidgetsBinding.instance.addPostFrameCallback((_) {
              PermissionDialog.showLocationPermissionDeniedDialog(
                context,
                isPermanentlyDenied: false,
              );
            });
          } else if (state is MapLocationPermissionDeniedPermanently) {
            // Permission permanently denied - need to go to settings
            WidgetsBinding.instance.addPostFrameCallback((_) {
              PermissionDialog.showLocationPermissionDeniedDialog(
                context,
                isPermanentlyDenied: true,
              );
            });
          } else if (state is MapLocationServiceDisabled) {
            // Location services are disabled on device
            WidgetsBinding.instance.addPostFrameCallback((_) {
              PermissionDialog.showLocationServicesDisabledDialog(context);
            });
          }
        },
        builder: (context, state) {
          return Stack(
            children: [
              _buildMap(state),
              _buildLoadingOverlay(state),
              _buildRouteInfoOverlay(state),
              _buildRestaurantList(),
            ],
          );
        },
      ),
    );
  }

  Widget _buildMap(MapState state) {
    CameraPosition cameraPosition;
    bool isLocationEnabled = false;
    Set<Marker> markers = const {};
    Set<Polyline> polylines = const {};
    MapType mapType = MapType.normal;

    if (state is MapLoaded) {
      cameraPosition = state.cameraPosition;
      isLocationEnabled = state.isLocationEnabled;
      markers = state.markers;
      polylines = state.polylines;
      mapType = state.mapType;
    } else {
      cameraPosition = const CameraPosition(
        target: LatLng(31.5204, 74.3587), // Lahore, Pakistan
        zoom: 12,
      );
    }

    return Stack(
      children: [
        GoogleMap(
          mapType: mapType,
          initialCameraPosition: cameraPosition,
          myLocationEnabled: isLocationEnabled,
          myLocationButtonEnabled: isLocationEnabled,
          markers: markers,
          polylines: polylines,
          style: _getCurrentMapStyle(), // Apply dark/light mode style
          onMapCreated: (GoogleMapController controller) {
            _mapController = controller;
            context.read<MapBloc>().add(MapControllerReady(controller));
          },
          onCameraMove: (CameraPosition position) {
            context.read<MapBloc>().add(MapCameraMoved(position));
          },
          compassEnabled: true,
          mapToolbarEnabled: false,
          zoomControlsEnabled: false,
        ),

        // Refresh Restaurants Button (Top Left)
        Positioned(
          top: 10,
          left: 16,
          child: Container(
            padding: EdgeInsets.all(6),
            decoration: BoxDecoration(
              color: Theme.of(
                context,
              ).colorScheme.onPrimary.withValues(alpha: 0.8),
              borderRadius: BorderRadius.circular(2),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.2),
                  offset: const Offset(0, 2),
                  blurRadius: 4,
                ),
              ],
            ),
            child: InkWell(
              onTap: () {
                // Get current position and reload restaurants
                final mapBloc = context.read<MapBloc>();
                final currentState = mapBloc.state;

                if (currentState is MapLoaded &&
                    currentState.currentPosition != null) {
                  mapBloc.add(
                    MapFetchNearbyRestaurants(
                      latitude: currentState.currentPosition!.latitude,
                      longitude: currentState.currentPosition!.longitude,
                    ),
                  );
                }
              },
              child: Icon(
                Icons.refresh_rounded,
                color: Colors.black.withValues(alpha: 0.6),
              ),
            ),
          ),
        ),
      ],
    );
  }

  /// Build route info overlay showing distance and duration
  Widget _buildRouteInfoOverlay(MapState state) {
    if (state is! MapLoaded) return const SizedBox.shrink();

    // Show loading indicator when fetching route
    if (state.isLoadingRoute) {
      return Positioned(
        bottom: 400,
        left: 16,
        right: 16,
        child: Card(
          elevation: 4,
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: const [
                SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(strokeWidth: 2),
                ),
                SizedBox(width: 12),
                Text('Calculating route...'),
              ],
            ),
          ),
        ),
      );
    }

    // Show route info when available
    if (state.routeDistance != null && state.selectedShop != null) {
      return Positioned(
        bottom: 40,
        left: 16,
        right: 16,
        child: Card(
          elevation: 4,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            child: Row(
              children: [
                // Route icon
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Theme.of(
                      context,
                    ).colorScheme.primary.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    Icons.directions,
                    color: Theme.of(context).colorScheme.primary,
                    size: 24,
                  ),
                ),
                const SizedBox(width: 12),
                // Route info
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        state.selectedShop!.shopName,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                          color: Theme.of(context).colorScheme.onSurface,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 2),
                      Row(
                        children: [
                          Icon(
                            Icons.straighten,
                            size: 14,
                            color: Theme.of(context).colorScheme.primary,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            state.routeDistance!,
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.bold,
                              color: Theme.of(context).colorScheme.onSecondary,
                            ),
                          ),
                          if (state.routeDuration != null) ...[
                            const SizedBox(width: 12),
                            Icon(
                              Icons.access_time,
                              size: 14,
                              color: Theme.of(context).colorScheme.primary,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              state.routeDuration!,
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.bold,
                                color:
                                    Theme.of(context).colorScheme.onSecondary,
                              ),
                            ),
                          ],
                        ],
                      ),
                    ],
                  ),
                ),
                // Close button
                IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () {
                    context.read<MapBloc>().add(const MapClearRoute());
                  },
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                ),
              ],
            ),
          ),
        ),
      );
    }

    return const SizedBox.shrink();
  }

  Widget _buildLoadingOverlay(MapState state) {
    if (state is MapLoading) {
      return Center(
        child: Card(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const CircularProgressIndicator(),
                    const SizedBox(width: 16),
                    Text(state.message),
                  ],
                ),
              ],
            ),
          ),
        ),
      );
    }
    return const SizedBox.shrink();
  }

  Widget _buildRestaurantList() {
    return BlocBuilder<MapBloc, MapState>(
      builder: (context, state) {
        if (state is MapLoaded) {
          return Stack(
            children: [
              // Animated Restaurant List
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: AnimatedSlide(
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeInOut,
                  offset:
                      state.isRestaurantListVisible
                          ? Offset.zero
                          : const Offset(0, 1), // Slide down when hidden
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (state.isLoadingRestaurants)
                        const RestaurantShimmerWidget()
                      else
                        ShopList(
                          height: 250,
                          shops: state.restaurants,
                          onShopTap: (shop) {
                            Navigator.pushNamed(
                              context,
                              RouteNames.shopNavBarScreen,
                              arguments: shop.id,
                            );
                          },
                          onLocationTap: (shop) {
                            _quickNavigateToRestaurant(shop, state);
                          },
                        ),
                    ],
                  ),
                ),
              ),

              // Toggle Button - Show when list is hidden
              // if (!state.isRestaurantListVisible)
              // Positioned(
              //   bottom: 10,
              //   right: 16,
              //   child: Material(
              //     elevation: 6,
              //     borderRadius: BorderRadius.circular(16),
              //     child: InkWell(
              //       onTap: () {
              //         context.read<MapBloc>().add(
              //           const MapToggleRestaurantListVisibility(),
              //         );
              //       },
              //       borderRadius: BorderRadius.circular(16),
              //       child: Container(
              //         padding: const EdgeInsets.symmetric(
              //           horizontal: 20,
              //           vertical: 14,
              //         ),
              //         decoration: BoxDecoration(
              //           gradient: LinearGradient(
              //             colors: [
              //               Theme.of(context).colorScheme.primary,
              //               Theme.of(
              //                 context,
              //               ).colorScheme.primary.withValues(alpha: 0.8),
              //             ],
              //             begin: Alignment.topLeft,
              //             end: Alignment.bottomRight,
              //           ),
              //           borderRadius: BorderRadius.circular(16),
              //           boxShadow: [
              //             BoxShadow(
              //               color: Theme.of(
              //                 context,
              //               ).colorScheme.primary.withValues(alpha: 0.4),
              //               blurRadius: 12,
              //               offset: const Offset(0, 4),
              //             ),
              //           ],
              //         ),
              //         child: Row(
              //           mainAxisSize: MainAxisSize.min,
              //           children: [
              //             const Icon(
              //               Icons.restaurant_menu,
              //               color: Colors.white,
              //               size: 20,
              //             ),
              //             const SizedBox(width: 8),
              //             Text(
              //               'Show Stores',
              //               style: TextStyle(
              //                 color: Colors.white,
              //                 fontWeight: FontWeight.w600,
              //                 fontSize: 14,
              //               ),
              //             ),
              //           ],
              //         ),
              //       ),
              //     ),
              //   ),
              // ),
            ],
          );
        }
        return const SizedBox.shrink();
      },
    );
  }

  /// Quick navigation - directly opens Google Maps
  void _quickNavigateToRestaurant(shop, MapLoaded state) {
    // Get user's current location if available
    double? userLatitude;
    double? userLongitude;

    if (state.currentPosition != null) {
      userLatitude = state.currentPosition!.latitude;
      userLongitude = state.currentPosition!.longitude;
    }

    // Directly open Google Maps
    MapLauncherService.navigateToLocation(
      latitude: shop.latitude,
      longitude: shop.longitude,
      destinationName: shop.shopName,
      userLatitude: userLatitude,
      userLongitude: userLongitude,
    );
  }
}
