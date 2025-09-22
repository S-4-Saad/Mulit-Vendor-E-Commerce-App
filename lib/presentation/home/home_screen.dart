import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:speezu/core/utils/labels.dart';
import 'package:speezu/core/utils/media_querry_extention.dart';
import 'package:speezu/presentation/nav_bar_screen/bloc/nav_bar_bloc.dart';
import 'package:speezu/presentation/nav_bar_screen/bloc/nav_bar_event.dart';
import 'package:speezu/presentation/products/bloc/products_bloc.dart';
import 'package:speezu/routes/route_names.dart';
import 'package:speezu/widgets/product_box_widget.dart';
import '../../core/assets/app_images.dart';
import '../../models/product_model.dart';
import '../../paractise.dart';
import '../../widgets/carousel_slider_widget.dart';
import '../../widgets/category_box_widget.dart';
import '../../widgets/home_header_tile.dart';
import '../../widgets/search_animated_container.dart';
import '../../widgets/home_shimmer_widget.dart';
import '../products/bloc/products_event.dart';
import '../shop_screen/shop_navbar_screen.dart';
import 'home.dart';


class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final RefreshController _refreshController = RefreshController(
    initialRefresh: false,
  );

  Future<void> _onRefresh() async {
    context.read<HomeBloc>().add(LoadHomeData(forceRefresh: true));
    // simulate network call
    await Future.delayed(const Duration(seconds: 2));
    _refreshController.refreshCompleted(); // ✅ must call this!
  }

  // Sample restaurant data - replace with API response
  List<String> imageUrl = [
    'https://t3.ftcdn.net/jpg/04/65/46/52/360_F_465465254_1pN9MGrA831idD6zIBL7q8rnZZpUCQTy.jpg',
    "https://static.vecteezy.com/system/resources/thumbnails/002/006/774/small/paper-art-shopping-online-on-smartphone-and-new-buy-sale-promotion-backgroud-for-banner-market-ecommerce-free-vector.jpg",
    "https://static.vecteezy.com/system/resources/thumbnails/004/299/835/small/online-shopping-on-phone-buy-sell-business-digital-web-banner-application-money-advertising-payment-ecommerce-illustration-search-free-vector.jpg",
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

  // Helper methods to get API data
  List<DummyProductModel> getApiFoodProducts(HomeState state) {
    if (state.dashboardProducts?.data.restaurant != null &&
        state.dashboardProducts!.data.restaurant.isNotEmpty) {
      return state.dashboardProducts!.data.restaurant.map((product) {
        // Use real category name from the product data, fallback to "Fast Food"
        String categoryName = product.category?.name ?? "Fast Food";
        return product.toDummyProductModel(category: categoryName);
      }).toList();
    }
    return []; // Return empty list if no API data
  }

  List<DummyProductModel> getApiSupermarketProducts(HomeState state) {
    if (state.dashboardProducts?.data.supermarket != null &&
        state.dashboardProducts!.data.supermarket.isNotEmpty) {
      return state.dashboardProducts!.data.supermarket.map((product) {
        // Use real category name from the product data, fallback to "Grocery"
        String categoryName = product.category?.name ?? "Grocery";
        return product.toDummyProductModel(category: categoryName);
      }).toList();
    }
    return []; // Return empty list if no API data
  }

  List<DummyProductModel> getApiRetailProducts(HomeState state) {
    if (state.dashboardProducts?.data.retail != null &&
        state.dashboardProducts!.data.retail.isNotEmpty) {
      return state.dashboardProducts!.data.retail.map((product) {
        // Use real category name from the product data, fallback to "Clothing"
        String categoryName = product.category?.name ?? "Clothing";
        return product.toDummyProductModel(category: categoryName);
      }).toList();
    }
    return []; // Return empty list if no API data
  }

  List<DummyProductModel> getApiPharmacyProducts(HomeState state) {
    if (state.dashboardProducts?.data.pharmacy != null &&
        state.dashboardProducts!.data.pharmacy.isNotEmpty) {
      return state.dashboardProducts!.data.pharmacy.map((product) {
        // Use real category name from the product data, fallback to "Medicine"
        String categoryName = product.category?.name ?? "Medicine";
        return product.toDummyProductModel(category: categoryName);
      }).toList();
    }
    return []; // Return empty list if no API data
  }

  @override
  void initState() {
    // Load home data including dashboard products
    context.read<HomeBloc>().add(LoadHomeData());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: SmartRefresher(
        enablePullDown: true,
        onRefresh: _onRefresh,
        header:  WaterDropMaterialHeader(
          backgroundColor: Theme.of(context).colorScheme.primary,
        ),
        controller: _refreshController,
        child: BlocBuilder<HomeBloc, HomeState>(
          builder: (context, state) {
            if (state.status == HomeStatus.loading) {
              return const HomeShimmerWidget();
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
                    // SearchContainer(onSearchTap: () {}),
                    // SizedBox(height: context.heightPct(.005)),
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
                      onViewAllTap:
                          getApiFoodProducts(state).isNotEmpty
                              ? () {
                                context.read<NavBarBloc>().add(SelectTab(0));
                                context.read<ProductsBloc>().add(
                                  ChangeTabEvent(0),
                                );
                              }
                              : null,
                    ),
                    SizedBox(height: context.heightPct(.01)),
                    getApiFoodProducts(state).isEmpty
                        ? Container(
                          height: 120,
                          width: double.infinity,
                          decoration: BoxDecoration(
                            color: Colors.grey[100],
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Center(
                            child: Text(
                              "No food products available",
                              style: TextStyle(
                                color: Colors.grey[600],
                                fontSize: 16,
                              ),
                            ),
                          ),
                        )
                        : SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Row(
                            children:
                                getApiFoodProducts(state).map((category) {
                                  return ProductBox(
                                    productPrice: category.productPrice,
                                    productOriginalPrice:
                                        category.productOriginalPrice,
                                    productCategory: category.productCategory,
                                    productRating: category.productRating,
                                    isProductFavourite:
                                        category.isProductFavourite,
                                    onFavouriteTap: () {
                                      // TODO: Implement favourite functionality
                                    },
                                    onProductTap: () {
                                      Navigator.pushNamed(
                                        context,
                                        RouteNames.productScreen,
                                        arguments: category.id,
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
                      onViewAllTap:
                          getApiSupermarketProducts(state).isNotEmpty
                              ? () {
                                context.read<NavBarBloc>().add(SelectTab(0));
                                context.read<ProductsBloc>().add(
                                  ChangeTabEvent(1),
                                );
                              }
                              : null,
                    ),
                    SizedBox(height: context.heightPct(.01)),
                    getApiSupermarketProducts(state).isEmpty
                        ? Container(
                          height: 120,
                          width: double.infinity,
                          decoration: BoxDecoration(
                            color: Colors.grey[100],
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Center(
                            child: Text(
                              "No supermarket products available",
                              style: TextStyle(
                                color: Colors.grey[600],
                                fontSize: 16,
                              ),
                            ),
                          ),
                        )
                        : SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Row(
                            children:
                                getApiSupermarketProducts(state).map((
                                  category,
                                ) {
                                  return ProductBox(
                                    productPrice: category.productPrice,
                                    productOriginalPrice:
                                        category.productOriginalPrice,
                                    productCategory: category.productCategory,
                                    productRating: category.productRating,
                                    isProductFavourite:
                                        category.isProductFavourite,
                                    onFavouriteTap: () {},
                                    onProductTap: () {
                                      Navigator.pushNamed(
                                        context,
                                        RouteNames.productScreen,
                                        arguments: category.id,
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
                      title: Labels.topTrendingProducts,
                      onViewAllTap:
                          getApiRetailProducts(state).isNotEmpty
                              ? () {
                                context.read<NavBarBloc>().add(SelectTab(0));
                                context.read<ProductsBloc>().add(
                                  ChangeTabEvent(2),
                                );
                              }
                              : null,
                    ),
                    SizedBox(height: context.heightPct(.01)),
                    getApiRetailProducts(state).isEmpty
                        ? Container(
                          height: 120,
                          width: double.infinity,
                          decoration: BoxDecoration(
                            color: Colors.grey[100],
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Center(
                            child: Text(
                              "No retail products available",
                              style: TextStyle(
                                color: Colors.grey[600],
                                fontSize: 16,
                              ),
                            ),
                          ),
                        )
                        : SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Row(
                            children:
                                getApiRetailProducts(state).map((category) {
                                  return ProductBox(
                                    productPrice: category.productPrice,
                                    productOriginalPrice:
                                        category.productOriginalPrice,
                                    productCategory: category.productCategory,
                                    productRating: category.productRating,
                                    isProductFavourite:
                                        category.isProductFavourite,
                                    onFavouriteTap: () {},
                                    onProductTap: () {
                                      Navigator.pushNamed(
                                        context,
                                        RouteNames.productScreen,
                                        arguments: category.id,
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
                      onViewAllTap:
                          getApiPharmacyProducts(state).isNotEmpty
                              ? () {
                                context.read<NavBarBloc>().add(SelectTab(0));
                                context.read<ProductsBloc>().add(
                                  ChangeTabEvent(3),
                                );
                              }
                              : null,
                    ),
                    SizedBox(height: context.heightPct(.01)),
                    getApiPharmacyProducts(state).isEmpty
                        ? Container(
                          height: 120,
                          width: double.infinity,
                          decoration: BoxDecoration(
                            color: Colors.grey[100],
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Center(
                            child: Text(
                              "No pharmacy products available",
                              style: TextStyle(
                                color: Colors.grey[600],
                                fontSize: 16,
                              ),
                            ),
                          ),
                        )
                        : SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Row(
                            children:
                                getApiPharmacyProducts(state).map((category) {
                                  return ProductBox(
                                    productPrice: category.productPrice,
                                    productOriginalPrice:
                                        category.productOriginalPrice,
                                    productCategory: category.productCategory,
                                    productRating: category.productRating,
                                    isProductFavourite:
                                        category.isProductFavourite,
                                    onFavouriteTap: () {},
                                    onProductTap: () {
                                      Navigator.pushNamed(
                                        context,
                                        RouteNames.productScreen,
                                        arguments: category.id,
                                      );
                                    },
                                    productImageUrl: category.productImageUrl,
                                    productTitle: category.productTitle,
                                  );
                                }).toList(),
                          ),
                        ),
                    SizedBox(height: context.heightPct(.02)),
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
