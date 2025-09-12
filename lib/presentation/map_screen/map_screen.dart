import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../../models/restaurant_model.dart';
import '../../widgets/restaurant_list.dart';
import '../../core/distance_calculator.dart';
import 'bloc/map_bloc.dart';
import 'bloc/map_event.dart';
import 'bloc/map_state.dart';

class MapScreen extends StatelessWidget {
  const MapScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => MapBloc()..add(const MapInitialized()),
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
  // Sample restaurant data - replace with API response
  List<RestaurantModel> _getSampleRestaurants([LatLng? currentLocation]) {
    final restaurants = [
      RestaurantModel(
        id: 1,
        name: "Home Cooking Experience",
        description: "Letraset sheets containing Lorem Ipsum passages",
        rating: 5.0,
        status: "Open",
        isDeliveryAvailable: true,
        isPickupAvailable: true,
        isFavorite: false,
        latitude: 31.4205338, // ~500m north of your location
        longitude: 73.1172914, // slightly west
      ),
      RestaurantModel(
        id: 2,
        name: "The Local Bistro",
        description: "Letraset sheets containing Lorem Ipsum passages",
        rating: 4.5,
        status: "Open",
        isDeliveryAvailable: true,
        isPickupAvailable: true,
        isFavorite: true,
        latitude: 31.4197338, // ~400m south of your location
        longitude: 73.1180914, // slightly east
      ),
      RestaurantModel(
        id: 3,
        name: "Garden Fresh Cafe",
        description: "Fresh ingredients and healthy options",
        rating: 4.2,
        status: "Open",
        isDeliveryAvailable: false,
        isPickupAvailable: true,
        isFavorite: false,
        latitude: 31.4210338, // ~900m north of your location
        longitude: 73.1168914, // slightly west
      ),
      RestaurantModel(
        id: 4,
        name: "Spice Palace",
        description: "Authentic Indian cuisine with traditional flavors",
        rating: 4.8,
        status: "Open",
        isDeliveryAvailable: true,
        isPickupAvailable: true,
        isFavorite: true,
        latitude: 31.4192338, // ~800m south of your location
        longitude: 73.1184914, // slightly east
      ),
    ];

    // Calculate distances if current location is available
    if (currentLocation != null) {
      for (final restaurant in restaurants) {
        if (restaurant.latitude != null && restaurant.longitude != null) {
          restaurant.distance = DistanceCalculator.calculateDistance(
            currentLocation.latitude,
            currentLocation.longitude,
            restaurant.latitude!,
            restaurant.longitude!,
          );
        }
      }
    }

    return restaurants;
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
                action: SnackBarAction(
                  label: 'Retry',
                  textColor: Colors.white,
                  onPressed: () {
                    context.read<MapBloc>().add(const MapInitialized());
                  },
                ),
              ),
            );
          } else if (state is MapLocationPermissionDenied) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: const Text('Location permission denied'),
                backgroundColor: Colors.orange,
                action: SnackBarAction(
                  label: 'Retry',
                  textColor: Colors.white,
                  onPressed: () {
                    context.read<MapBloc>().add(const MapInitialized());
                  },
                ),
              ),
            );
          } else if (state is MapLocationServiceDisabled) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: const Text('Location services are disabled'),
                backgroundColor: Colors.orange,
                action: SnackBarAction(
                  label: 'Retry',
                  textColor: Colors.white,
                  onPressed: () {
                    context.read<MapBloc>().add(const MapInitialized());
                  },
                ),
              ),
            );
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
    if (state is MapLoaded) {
      return GoogleMap(
        mapType: state.mapType,
        initialCameraPosition: state.cameraPosition,
        myLocationEnabled: state.isLocationEnabled,
        myLocationButtonEnabled: state.isLocationEnabled,
        polylines: state.polylines,
        markers: state.markers,
        onMapCreated: (GoogleMapController controller) {
          context.read<MapBloc>().add(MapControllerReady(controller));
        },
        onCameraMove: (CameraPosition position) {
          context.read<MapBloc>().add(MapCameraMoved(position));
        },
      );
    }

    return const Center(child: CircularProgressIndicator());
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
        LatLng? currentLocation;
        if (state is MapLoaded) {
          currentLocation = state.currentPosition;
        }
        
        return Positioned(
          bottom: 0,
          left: 0,
          right: 0,
          child: RestaurantList(
            restaurants: _getSampleRestaurants(currentLocation),
            onRestaurantTap: () {
              // Navigate to restaurant details
              print("Restaurant tapped");
            },
            onOpenTap: () {
              // Handle open action
              print("Open tapped");
            },
            onPickupTap: () {
              // Handle pickup action
              print("Pickup tapped");
            },
            onLocationTap: (restaurant) {
              // Draw route to restaurant
              context.read<MapBloc>().add(MapDrawRouteToRestaurant(
                restaurantLocation: LatLng(restaurant.latitude!, restaurant.longitude!),
                restaurantName: restaurant.name ?? "Restaurant",
              ));
            },
          ),
        );
      },
    );
  }
}
