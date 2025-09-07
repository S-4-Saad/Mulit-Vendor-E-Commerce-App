import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../widgets/home_slider_widget.dart';
import '../../widgets/title_widget.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/restaurant_list.dart';
import '../../models/restaurant_model.dart';
import 'home.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  // Sample restaurant data - replace with API response
  List<RestaurantModel> _getSampleRestaurants() {
    return [
      RestaurantModel(
        id: 1,
        name: "Home Cooking Experience",
        description: "Letraset sheets containing Lorem Ipsum passages",
        rating: 5.0,
        status: "Open",
        isDeliveryAvailable: true,
        isPickupAvailable: true,
        isFavorite: false,
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
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => HomeBloc()..add(LoadHomeData()),
      child: Scaffold(
        backgroundColor: Theme.of(context).colorScheme.onPrimary,
        body: Center(
          child: BlocBuilder<HomeBloc, HomeState>(
            builder: (context, state) {
              if (state.status == HomeStatus.loading) {
                return const Center(child: CircularProgressIndicator());
              }
              if (state.status == HomeStatus.error) {
                return Center(child: Text("Error: ${state.message}"));
              }
              return SingleChildScrollView(
                child: Padding(
                  padding: EdgeInsets.only(left: 15, right: 15),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      HomeSliderWidget(slides: state.slidesModel?.data,),
                
                      // Top Restaurants with action buttons
                      TitleWidget(
                
                        title: "Top Restaurants",
                        actionButtons: [
                          CustomButton(
                            text: "Delivery",
                            onPressed: () {},
                            backgroundColor: const Color(0xFFF4F4F9),
                            textColor: const Color(0xFF2C3E50),
                          ),
                          CustomButton(
                            text: "Pickup",
                            onPressed: () {},
                            backgroundColor: const Color(0xFFE74C3C),
                            textColor: Colors.white,
                            isSelected: true,
                          ),
                        ],
                      ),
                
                      const SizedBox(height: 20),
                
                      // Trending This Week with subtitle
                      TitleWidget(
                        leadingIcon: const Icon(
                          Icons.trending_up,
                          color: Color(0xFF2C3E50),
                          size: 20,
                        ),
                        title: "Trending This Week",
                        subtitle: "Click on the food to get more details about it",
                      ),
                
                      const SizedBox(height: 20),
                
                      // Food Categories with icon
                      TitleWidget(
                        leadingIcon: Container(
                          width: 20,
                          height: 20,
                          decoration: const BoxDecoration(
                            color: Color(0xFF2C3E50),
                          ),
                          child: const Icon(
                            Icons.category,
                            color: Colors.white,
                            size: 12,
                          ),
                        ),
                        title: "Food Categories",
                      ),
                
                      const SizedBox(height: 20),
                
                      // Top Restaurants List
                      RestaurantList(
                        restaurants: _getSampleRestaurants(),
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
                        onFavoriteTap: () {
                          // Handle favorite toggle
                          print("Favorite tapped");
                        },
                      ),
                
                    ],
                  ),
                ),
              );

            },
          ),
        ),
      ),
    );
  }
}
