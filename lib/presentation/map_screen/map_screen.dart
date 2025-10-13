import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../../models/restaurant_model.dart';
import '../../models/shop_model.dart';
import '../../widgets/restaurant_list.dart';
import '../../core/distance_calculator.dart';
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
    // Trigger the map screen shown event
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<MapBloc>().add(const MapScreenShown());
    });
  }

  // Sample restaurant data - replace with API response
  List<ShopModel> _getSampleShops([LatLng? currentLocation]) {
    final shops = [
      ShopModel(
        id: 1,

        shopName: "Home Cooking Experience",
        shopDescription: "Letraset sheets containing Lorem Ipsum passages",
        shopRating: 5.0,
        isOpen: true,
        isDelivering: true,
        imageUrl: 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcS9oBl8oMj8unCKsHx9WuzVKgxc34HJnei-Qw&s',
        latitude: 31.4205338, // ~500m north of your location
        longitude: 73.1172914, // slightly west
      ),
      ShopModel(

        id: 2,
        shopName: "The Local Bistro",
        shopDescription: "Letraset sheets containing Lorem Ipsum passages",
        shopRating: 4.5,
        isOpen: true,
        isDelivering: true,
        imageUrl:'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQOOgoiSob7STY6T9gsLPRZA3omjcpx_KpiVw&s' ,

        latitude: 31.4197338, // ~400m south of your location
        longitude: 73.1180914, // slightly east
      ),
      ShopModel(
        id: 3,
        shopName: "Garden Fresh Cafe",

        shopDescription: "Fresh ingredients and healthy options",
        shopRating: 4.2,
        isOpen:false,
        isDelivering: false,
        imageUrl: 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSNgzW6LUDP_-oVca6nsAECRnKLUCtvp18HVA&s',
        latitude: 31.4210338, // ~900m north of your location
        longitude: 73.1168914, // slightly west
      ),
      ShopModel(
        id: 4,
        shopName: "Spice Palace",
        shopDescription: "Authentic Indian cuisine with traditional flavors",
        shopRating: 4.8,
        isDelivering: true,
        isOpen: true,
        imageUrl: 'https://dynamic-media-cdn.tripadvisor.com/media/photo-o/1b/1d/50/53/excellent-buffet.jpg?w=900&h=500&s=1',
        latitude: 31.4192338, // ~800m south of your location
        longitude: 73.1184914, // slightly east
      ),
    ];

    // Calculate distances if current location is available
    if (currentLocation != null) {
      for (final shop in shops) {
        if (shop.latitude != null && shop.longitude != null) {
          shop.distance = DistanceCalculator.calculateDistance(
            currentLocation.latitude,
            currentLocation.longitude,
            shop.latitude!,
            shop.longitude!,
          );
        }
      }
    }

    return shops;
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
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: const Text('Location permission denied'),
                backgroundColor: Colors.orange,
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
          } else if (state is MapLocationServiceDisabled) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: const Text('Location services are disabled'),
                backgroundColor: Colors.orange,
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
          child: ShopList(
            height: 250,
            shops: _getSampleShops(currentLocation),

            onShopTap: () {
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
            onLocationTap: (shop) {
              // Draw route to restaurant
              context.read<MapBloc>().add(MapDrawRouteToRestaurant(
                restaurantLocation: LatLng(shop.latitude!, shop.longitude!),
                restaurantName: shop.shopName ?? "Restaurant",
              ));
            },
          ),
        );
      },
    );
  }
}
