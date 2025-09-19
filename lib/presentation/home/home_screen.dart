import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:speezu/core/assets/font_family.dart';
import 'package:speezu/core/utils/labels.dart';
import 'package:speezu/core/utils/media_querry_extention.dart';
import 'package:speezu/presentation/nav_bar_screen/bloc/nav_bar_bloc.dart';
import 'package:speezu/presentation/nav_bar_screen/bloc/nav_bar_event.dart';
import 'package:speezu/presentation/product_detail/product_detail_screen.dart';
import 'package:speezu/presentation/products/bloc/products_bloc.dart';
import 'package:speezu/routes/route_names.dart';
import 'package:speezu/widgets/product_box_widget.dart';
import '../../core/assets/app_images.dart';
import '../../models/product_model.dart';
import '../../paractise.dart';
import '../../widgets/carousel_slider_widget.dart';
import '../../widgets/category_box_widget.dart';
import '../../widgets/home_header_tile.dart';
import '../../widgets/home_slider_widget.dart';
import '../../widgets/search_animated_container.dart';
import '../../widgets/title_widget.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/restaurant_list.dart';
import '../../models/restaurant_model.dart';
import '../products/bloc/products_event.dart';
import '../shop_screen/shop_navbar_screen.dart';
import 'home.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // Sample restaurant data - replace with API response
  List<String> imageUrl = [
    'https://t3.ftcdn.net/jpg/04/65/46/52/360_F_465465254_1pN9MGrA831idD6zIBL7q8rnZZpUCQTy.jpg',
    "https://static.vecteezy.com/system/resources/thumbnails/002/006/774/small/paper-art-shopping-online-on-smartphone-and-new-buy-sale-promotion-backgroud-for-banner-market-ecommerce-free-vector.jpg",
    "https://static.vecteezy.com/system/resources/thumbnails/004/299/835/small/online-shopping-on-phone-buy-sell-business-digital-web-banner-application-money-advertising-payment-ecommerce-illustration-search-free-vector.jpg",
  ];
  final List<DummyProductModel> dummyFoodProducts = [
    DummyProductModel(
      id: "1",
      productTitle: "Cheese Burger",
      productPrice: 4.99,
      productOriginalPrice: 6.99,
      productImageUrl:
          "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRctS9Fc8yYWbhqIqWuIJESV_PFF1e7Rg9i1Q&s",
      productRating: 4.5,
      productCategory: "Fast Food",
      isProductFavourite: true,
    ),
    DummyProductModel(
      id: "2",
      productTitle: "Pepperoni Pizza",
      productPrice: 8.99,
      productOriginalPrice: 11.99,
      productImageUrl:
          "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRHoML_RWrNhS3xbZNeWhpj9jjsyG7Ex-43aw&s",
      productRating: 4.7,
      productCategory: "Pizza",
    ),
    DummyProductModel(
      id: "3",
      productTitle: "Grilled Chicken Sandwich",
      productPrice: 5.49,
      productOriginalPrice: 7.49,
      productImageUrl:
          "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRfDnZMDTRzMYUGZuC_bgHNaY8xUZRhypK3cw&s",
      productRating: 4.3,
      productCategory: "Sandwiches",
    ),
    DummyProductModel(
      id: "4",
      productTitle: "Caesar Salad",
      productPrice: 3.99,
      productOriginalPrice: 5.99,
      productImageUrl:
          "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQP9oCufjbqRr8NjbEffdJW7xaYlCw6EOShWg&s",
      productRating: 4.0,
      productCategory: "Salads",
    ),
    DummyProductModel(
      id: "5",
      productTitle: "Chocolate Milkshake",
      productPrice: 2.99,
      productOriginalPrice: 4.49,
      productImageUrl:
          "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRzBfJl8vW3YMgLXZvhJp_qvSR803w6MHk2Uw&s",
      productRating: 4.6,
      productCategory: "Beverages",
    ),
    DummyProductModel(
      id: "6",
      productTitle: "French Fries",
      productPrice: 1.99,
      productOriginalPrice: 3.49,
      productImageUrl:
          "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcS8N0tUijh_HHnvvTSUA-vNph2IuwTKWUgoYg&s",
      productRating: 4.2,
      productCategory: "Snacks",
      isProductFavourite: true,
    ),
    DummyProductModel(
      id: "7",
      productTitle: "Sushi Platter",
      productPrice: 12.99,
      productOriginalPrice: 15.99,
      productImageUrl:
          "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcThQ21CGPbsX0XeK4WJXp3BoHy7ZHxuo6IIOg&s",
      productRating: 4.8,
      productCategory: "Japanese",
    ),
    DummyProductModel(
      id: "8",
      productTitle: "Pasta Alfredo",
      productPrice: 7.49,
      productOriginalPrice: 9.99,
      productImageUrl:
          "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQNb-2E4TRtAxpHsCpXdaxHBSsHEdX_WO-tyQ&s",
      productRating: 4.4,
      productCategory: "Italian",
    ),
    DummyProductModel(
      id: "9",
      productTitle: "Tacos",
      productPrice: 3.49,
      productOriginalPrice: 3.49,
      productImageUrl: "https://picsum.photos/200/300?food=9",
      productRating: 4.1,
      productCategory: "Mexican",
    ),
    DummyProductModel(
      id: "10",
      productTitle: "Ice Cream Sundae",
      productPrice: 2.49,
      productOriginalPrice: 3.99,
      productImageUrl: "https://picsum.photos/200/300?food=10",
      productRating: 4.9,
      productCategory: "Desserts",
      isProductFavourite: true,
    ),
  ];
  final List<DummyProductModel> dummySupermarketProducts = [
    DummyProductModel(
      id: "1",
      productTitle: "Fresh Bananas (1kg)",
      productPrice: 1.49,
      productOriginalPrice: 1.99,
      productImageUrl:
          "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcR_I8p1Yfj6Gom0zsG_-nboSGyXMPioUcASBQ&s",
      productRating: 4.6,
      productCategory: "Fruits",
      isProductFavourite: true,
    ),
    DummyProductModel(
      id: "2",
      productTitle: "Organic Tomatoes (1kg)",
      productPrice: 2.99,
      productOriginalPrice: 3.49,
      productImageUrl:
          "https://images.unsplash.com/photo-1567306226416-28f0efdc88ce",
      productRating: 4.4,
      productCategory: "Vegetables",
    ),
    DummyProductModel(
      id: "3",
      productTitle: "Whole Wheat Bread",
      productPrice: 1.99,
      productOriginalPrice: 2.49,
      productImageUrl:
          "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSjJAfppdNTp8GOYMmMA_HZypacPm5hGuz0XA&s",
      productRating: 4.3,
      productCategory: "Bakery",
    ),
    DummyProductModel(
      id: "4",
      productTitle: "Fresh Milk (1L)",
      productPrice: 0.99,
      productOriginalPrice: 1.29,
      productImageUrl:
          "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQcxRdeE0y3Y5gLqc86inskyoLs0dXA4sxN6w&s",
      productRating: 4.7,
      productCategory: "Dairy",
      isProductFavourite: true,
    ),
    DummyProductModel(
      id: "5",
      productTitle: "Pack of Eggs (12 pcs)",
      productPrice: 2.49,
      productOriginalPrice: 2.99,
      productImageUrl:
          "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTTvKR1PuC3P9kSw3o_i-cma-HKDUJDVDJdIA&s",
      productRating: 4.5,
      productCategory: "Dairy & Eggs",
    ),
  ];

  List<RestaurantModel> sampleRestaurants = [
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
  final List<DummyProductModel> dummyRetailProducts = [
    DummyProductModel(
      id: "1",
      productTitle: "Men's Casual T-Shirt",
      productPrice: 14.99,
      productOriginalPrice: 19.99,
      productImageUrl:
          "https://images.unsplash.com/photo-1523381210434-271e8be1f52b",
      productRating: 4.4,
      productCategory: "Clothing",
      isProductFavourite: true,
    ),
    DummyProductModel(
      id: "2",
      productTitle: "Women's Denim Jacket",
      productPrice: 39.99,
      productOriginalPrice: 49.99,
      productImageUrl:
          "https://images.unsplash.com/photo-1503341455253-b2e723bb3dbb",
      productRating: 4.7,
      productCategory: "Clothing",
    ),
    DummyProductModel(
      id: "3",
      productTitle: "Leather Handbag",
      productPrice: 59.99,
      productOriginalPrice: 79.99,
      productImageUrl:
          "https://images.unsplash.com/photo-1541099649105-f69ad21f3246",
      productRating: 4.6,
      productCategory: "Accessories",
    ),
    DummyProductModel(
      id: "4",
      productTitle: "Running Sneakers",
      productPrice: 49.99,
      productOriginalPrice: 69.99,
      productImageUrl:
          "https://images.unsplash.com/photo-1600185365483-26d7a4cc7519",
      productRating: 4.8,
      productCategory: "Footwear",
      isProductFavourite: true,
    ),
    DummyProductModel(
      id: "5",
      productTitle: "Wrist Watch",
      productPrice: 89.99,
      productOriginalPrice: 120.00,
      productImageUrl:
          "https://images.unsplash.com/photo-1523275335684-37898b6baf30",
      productRating: 4.5,
      productCategory: "Accessories",
    ),
  ];
  final List<DummyProductModel> dummyPharmacyProducts = [
    DummyProductModel(
      id: "1",
      productTitle: "Paracetamol Tablets (500mg, 20pcs)",
      productPrice: 2.49,
      productOriginalPrice: 3.49,
      productImageUrl:
          "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQUa-u17wSxpbxjFXObVWu61ive07-aJanZJg&s",
      productRating: 4.7,
      productCategory: "Pain Relief",
      isProductFavourite: true,
    ),
    DummyProductModel(
      id: "2",
      productTitle: "Vitamin C Capsules (1000mg, 30pcs)",
      productPrice: 5.99,
      productOriginalPrice: 7.49,
      productImageUrl:
          "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRQOWGOk1SEElPb9Y2xM0Hl5tcYPbb_94N9qw&s",
      productRating: 4.6,
      productCategory: "Supplements",
    ),
    DummyProductModel(
      id: "3",
      productTitle: "Cough Syrup (100ml)",
      productPrice: 3.99,
      productOriginalPrice: 5.49,
      productImageUrl:
          "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRoJsZhRLxzDwOrdGXvSDLRXuwGPhSUdyeF_g&s",
      productRating: 4.3,
      productCategory: "Cold & Flu",
    ),
    DummyProductModel(
      id: "4",
      productTitle: "Antiseptic Cream (50g)",
      productPrice: 4.49,
      productOriginalPrice: 6.99,
      productImageUrl:
          "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTV5Tf6DsscUKO_DUQ_2u5zY8Ph2WGX4myJ2w&s4",
      productRating: 4.5,
      productCategory: "First Aid",
      isProductFavourite: true,
    ),
    DummyProductModel(
      id: "5",
      productTitle: "Allergy Relief Tablets (10pcs)",
      productPrice: 3.49,
      productOriginalPrice: 4.99,
      productImageUrl:
          "https://images.unsplash.com/photo-1587854692152-cbe660dbde88",
      productRating: 4.4,
      productCategory: "Allergy",
    ),
  ];

  final List<ProductCategory> dummyCategories = [
    ProductCategory(name: "Food", imageUrl: AppImages.foodStoreIcon),
    ProductCategory(name: "Supermarket", imageUrl: AppImages.superMarketIcon),
    ProductCategory(
      name: "Retail Stores",
      imageUrl: AppImages.utilityStoreIcon,
    ),
    ProductCategory(name: "Pharmacy", imageUrl: AppImages.pharmacyIcon),
  ];
  @override
  void initState() {
    // TODO: implement initState
    // context.read<HomeBloc>().add(LoadHomeData());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: Center(
        child: BlocBuilder<HomeBloc, HomeState>(
          builder: (context, state) {
            if (state.status == HomeStatus.loading) {
              // return const Center(child: CircularProgressIndicator());
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
                    SizedBox(height: context.heightPct(.01)),
                    SearchContainer(onSearchTap: () {}),
                    SizedBox(height: context.heightPct(.005)),
                    EcommerceBanner(
                      imageUrls: imageUrl,
                      height: context.heightPct(.18),
                      // isImageTap: true,
                    ),
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children:
                            dummyCategories.map((category) {
                              return CategoryBoxWidget(
                                title: category.name,
                                imageUrl: category.imageUrl,
                                onTap: () {
                                  Navigator.pushNamed(
                                    context,
                                    RouteNames.categoryScreen,
                                    arguments: category.name,
                                  );
                                },
                              );
                            }).toList(),
                      ),
                    ),
                    SizedBox(height: context.heightPct(.02)),
                    HomeHeaderTile(
                      title: Labels.topTrendingFoods,
                      onViewAllTap: () {
                        context.read<NavBarBloc>().add(SelectTab(0));
                        context.read<ProductsBloc>().add(ChangeTabEvent(0));
                      },
                    ),
                    SizedBox(height: context.heightPct(.01)),
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children:
                            dummyFoodProducts.map((category) {
                              return ProductBox(
                                productPrice: category.productPrice,
                                productOriginalPrice:
                                    category.productOriginalPrice,
                                productCategory: category.productCategory,
                                productRating: category.productRating,
                                isProductFavourite: category.isProductFavourite,
                                onFavouriteTap: () {
                                  print('Favourite tapped');
                                },
                                onProductTap: () {
                                  // Navigator.pushNamed(context, RouteNames.productScreen);
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder:
                                          (context) => ProductDetailScreen(),
                                    ),
                                  );
                                },
                                productImageUrl: category.productImageUrl,
                                productTitle: category.productTitle,
                              );
                            }).toList(),
                      ),
                    ),
                    SizedBox(height: context.heightPct(.02)),
                    HomeHeaderTile(
                      title: Labels.topSuperMarketProducts,
                      onViewAllTap: () {
                        context.read<NavBarBloc>().add(SelectTab(0));
                        context.read<ProductsBloc>().add(ChangeTabEvent(1));
                      },
                    ),
                    SizedBox(height: context.heightPct(.01)),
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children:
                            dummySupermarketProducts.map((category) {
                              return ProductBox(
                                productPrice: category.productPrice,
                                productOriginalPrice:
                                    category.productOriginalPrice,
                                productCategory: category.productCategory,
                                productRating: category.productRating,
                                isProductFavourite: category.isProductFavourite,
                                onFavouriteTap: () {},
                                onProductTap: () {},
                                productImageUrl: category.productImageUrl,
                                productTitle: category.productTitle,
                              );
                            }).toList(),
                      ),
                    ),
                    SizedBox(height: context.heightPct(.02)),
                    HomeHeaderTile(
                      title: Labels.topTrendingProducts,
                      onViewAllTap: () {
                        context.read<NavBarBloc>().add(SelectTab(0));
                        context.read<ProductsBloc>().add(ChangeTabEvent(2));
                      },
                    ),
                    SizedBox(height: context.heightPct(.01)),
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children:
                            dummyRetailProducts.map((category) {
                              return ProductBox(
                                productPrice: category.productPrice,
                                productOriginalPrice:
                                    category.productOriginalPrice,
                                productCategory: category.productCategory,
                                productRating: category.productRating,
                                isProductFavourite: category.isProductFavourite,
                                onFavouriteTap: () {},
                                onProductTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder:
                                          (context) => ShopNavbarScreen(
                                            shopCurrentTab: 0,
                                          ),
                                    ),
                                  );
                                },
                                productImageUrl: category.productImageUrl,
                                productTitle: category.productTitle,
                              );
                            }).toList(),
                      ),
                    ),
                    SizedBox(height: context.heightPct(.02)),
                    HomeHeaderTile(
                      title: Labels.medicines,
                      onViewAllTap: () {
                        context.read<NavBarBloc>().add(SelectTab(0));
                        context.read<ProductsBloc>().add(ChangeTabEvent(3));
                      },
                    ),
                    SizedBox(height: context.heightPct(.01)),
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children:
                            dummyPharmacyProducts.map((category) {
                              return ProductBox(
                                productPrice: category.productPrice,
                                productOriginalPrice:
                                    category.productOriginalPrice,
                                productCategory: category.productCategory,
                                productRating: category.productRating,
                                isProductFavourite: category.isProductFavourite,
                                onFavouriteTap: () {},
                                onProductTap: () {},
                                productImageUrl: category.productImageUrl,
                                productTitle: category.productTitle,
                              );
                            }).toList(),
                      ),
                    ),

                    // HomeSliderWidget(slides: state.slidesModel?.data),

                    // Top Restaurants with action buttons
                    TitleWidget(
                      title: "Top Restaurants",
                      actionButtons: [
                        CustomButton(
                          text: "Delivery",
                          onPressed: () {},
                          backgroundColor: Theme.of(
                            context,
                          ).colorScheme.onSecondary.withValues(alpha: .1),
                          textColor: Theme.of(context).colorScheme.onSecondary,
                        ),
                        CustomButton(
                          text: "Pickup",
                          onPressed: () {},
                          backgroundColor:
                              Theme.of(context).colorScheme.onTertiary,
                          textColor: Theme.of(context).colorScheme.onPrimary,
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
                      subtitle:
                          "Click on the food to get more details about it",
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
                      restaurants: sampleRestaurants,
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
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
