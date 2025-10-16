import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../../widgets/restaurant_list.dart';
import '../../widgets/dialog_boxes/permission_dialog.dart';
import '../../widgets/restaurant_shimmer_widget.dart';
import '../../core/services/map_launcher_service.dart';
import 'bloc/map_bloc.dart';
import 'bloc/map_event.dart';
import 'bloc/map_state.dart';

class MapScreen extends StatelessWidget {
  const MapScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: MapBloc.instance,
      child: const MapView(),
    );
  }
}

class MapView extends StatefulWidget {
  const MapView({super.key});

  @override
  State<MapView> createState() => _MapViewState();
}

class _MapViewState extends State<MapView> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<MapBloc>().add(const MapScreenShown());
    });
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
    MapType mapType = MapType.normal;

    if (state is MapLoaded) {
      cameraPosition = state.cameraPosition;
      isLocationEnabled = state.isLocationEnabled;
      markers = state.markers;
      mapType = state.mapType;
    } else {
      cameraPosition = const CameraPosition(
        target: LatLng(31.5204, 74.3587), // Lahore, Pakistan
        zoom: 12,
      );
    }

    return GoogleMap(
      key: ValueKey('google_map_${state.runtimeType}'),
      mapType: mapType,
      initialCameraPosition: cameraPosition,
      myLocationEnabled: isLocationEnabled,
      myLocationButtonEnabled: isLocationEnabled,
      markers: markers,
      onMapCreated: (GoogleMapController controller) {
        context.read<MapBloc>().add(MapControllerReady(controller));
      },
      onCameraMove: (CameraPosition position) {
        context.read<MapBloc>().add(MapCameraMoved(position));
      },
      compassEnabled: true,
      mapToolbarEnabled: false,
      zoomControlsEnabled: false,
    );
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
          return Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (state.isLoadingRestaurants)
                  const RestaurantShimmerWidget()
                else
                  ShopList(
                    height: 250,
                    shops: state.restaurants,
                    onShopTap: () {
                      // Navigate to restaurant details
                    },
                    onOpenTap: () {
                      // Handle open action
                    },
                    onPickupTap: () {
                      // Handle pickup action
                    },
                    onLocationTap: (shop) {
                      _quickNavigateToRestaurant(shop, state);
                    },
                  ),
              ],
            ),
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
