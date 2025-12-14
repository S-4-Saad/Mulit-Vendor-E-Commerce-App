import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:speezu/core/utils/labels.dart';
import 'package:speezu/core/utils/media_querry_extention.dart';
import 'package:speezu/models/product_category_model.dart';
import 'package:speezu/presentation/nav_bar_screen/bloc/nav_bar_bloc.dart';
import 'package:speezu/presentation/nav_bar_screen/bloc/nav_bar_event.dart';
import 'package:speezu/presentation/products/bloc/products_bloc.dart';
import 'package:speezu/routes/route_names.dart';
import 'package:speezu/widgets/error_widget.dart';
import 'package:speezu/widgets/product_box_widget.dart';
import '../../core/assets/app_images.dart';
import '../../models/product_model.dart';
import '../../widgets/carousel_slider_widget.dart';
import '../../widgets/category_box_widget.dart';
import '../../widgets/home_header_tile.dart';
import '../../widgets/shimmer/home_shimmer_widget.dart';
import '../products/bloc/products_event.dart';
import 'bloc/home_bloc.dart';
import 'bloc/home_event.dart';
import 'bloc/home_state.dart';

enum ScreenType { mobile, mediumTablet, largeTablet }

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  final RefreshController _refreshController = RefreshController(
    initialRefresh: false,
  );

  late AnimationController _fadeController;
  late AnimationController _slideController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  Future<void> _onRefresh() async {
    context.read<HomeBloc>().add(LoadHomeData(forceRefresh: true));
    await Future.delayed(const Duration(seconds: 2));
    _refreshController.refreshCompleted();
  }

  List<String> imageUrl = [
    "https://firebasestorage.googleapis.com/v0/b/qazaumri-9f2b2.firebasestorage.app/o/extra%2FSpeezzu_Radial_Service_Banner%20(1).png?alt=media&token=9c627564-9666-474b-8f7f-5a10ac192237",
    'https://firebasestorage.googleapis.com/v0/b/qazaumri-9f2b2.firebasestorage.app/o/extra%2FImage%20December%2014%2C%202025%20-%202_38AM.png?alt=media&token=1d871787-762d-4f7a-9292-f762c4f6cb1a',
    "https://firebasestorage.googleapis.com/v0/b/qazaumri-9f2b2.firebasestorage.app/o/extra%2FGenerated%20Image%20December%2014%2C%202025%20-%203_02AM.png?alt=media&token=5f71dc66-bb2d-4eb3-9347-d4824a2615be",
    "https://firebasestorage.googleapis.com/v0/b/qazaumri-9f2b2.firebasestorage.app/o/extra%2FSpeezu_Product_Flow_Banner.png?alt=media&token=ad9c0b87-7e50-4030-af12-d853012b5f15",
    "https://firebasestorage.googleapis.com/v0/b/qazaumri-9f2b2.firebasestorage.app/o/extra%2FGenerated%20Image%20December%2014%2C%202025%20-%203_08AM.png?alt=media&token=c6d4755c-6b34-4165-a9c8-8bc1fd79fb7d",
  ];

  ScreenType _getScreenType(double width) {
    if (width < 600) return ScreenType.mobile;
    if (width < 900) return ScreenType.mediumTablet;
    return ScreenType.largeTablet;
  }

  double _getHorizontalPadding(ScreenType type) {
    switch (type) {
      case ScreenType.mobile:
        return 15;
      case ScreenType.mediumTablet:
        return 24;
      case ScreenType.largeTablet:
        return 32;
    }
  }

  double _getSectionSpacing(ScreenType type) {
    switch (type) {
      case ScreenType.mobile:
        return 20;
      case ScreenType.mediumTablet:
        return 28;
      case ScreenType.largeTablet:
        return 36;
    }
  }

  // Helper methods to get API data
  List<ProductModel> getApiFoodProducts(HomeState state) {
    if (state.dashboardProducts?.data.restaurant != null &&
        state.dashboardProducts!.data.restaurant.isNotEmpty) {
      return state.dashboardProducts!.data.restaurant.map((product) {
        String categoryName = product.category?.name ?? "Fast Food";
        return product.toDummyProductModel(category: categoryName);
      }).toList();
    }
    return [];
  }

  List<ProductModel> getApiSupermarketProducts(HomeState state) {
    if (state.dashboardProducts?.data.supermarket != null &&
        state.dashboardProducts!.data.supermarket.isNotEmpty) {
      return state.dashboardProducts!.data.supermarket.map((product) {
        String categoryName = product.category?.name ?? "Grocery";
        return product.toDummyProductModel(category: categoryName);
      }).toList();
    }
    return [];
  }

  List<ProductModel> getApiRetailProducts(HomeState state) {
    if (state.dashboardProducts?.data.retail != null &&
        state.dashboardProducts!.data.retail.isNotEmpty) {
      return state.dashboardProducts!.data.retail.map((product) {
        String categoryName = product.category?.name ?? "Clothing";
        return product.toDummyProductModel(category: categoryName);
      }).toList();
    }
    return [];
  }

  List<ProductModel> getApiPharmacyProducts(HomeState state) {
    if (state.dashboardProducts?.data.pharmacy != null &&
        state.dashboardProducts!.data.pharmacy.isNotEmpty) {
      return state.dashboardProducts!.data.pharmacy.map((product) {
        String categoryName = product.category?.name ?? "Medicine";
        return product.toDummyProductModel(category: categoryName);
      }).toList();
    }
    return [];
  }

  @override
  void initState() {
    super.initState();
    context.read<HomeBloc>().add(LoadHomeData());

    // Initialize animations
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    );

    _slideController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _fadeController,
        curve: const Interval(0.0, 0.6, curve: Curves.easeOut),
      ),
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.03),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(parent: _slideController, curve: Curves.fastOutSlowIn),
    );

    // Start animations with slight delay for smoother appearance
    Future.delayed(const Duration(milliseconds: 100), () {
      if (mounted) {
        _fadeController.forward();
        _slideController.forward();
      }
    });
  }

  @override
  void dispose() {
    _fadeController.dispose();
    _slideController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final List<ProductCategoryModel> productCategories = [
      ProductCategoryModel(
        name: Labels.food,
        imageUrl: AppImages.foodStoreIcon,
        categoryId: 1,
      ),
      ProductCategoryModel(
        name: Labels.superMarket,
        imageUrl: AppImages.superMarketIcon,
        categoryId: 3,
      ),
      ProductCategoryModel(
        name: Labels.retailStore,
        imageUrl: AppImages.utilityStoreIcon,
        categoryId: 2,
      ),
      ProductCategoryModel(
        name: Labels.pharmacy,
        imageUrl: AppImages.pharmacyIcon,
        categoryId: 4,
      ),
    ];

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: LayoutBuilder(
        builder: (context, constraints) {
          final screenType = _getScreenType(constraints.maxWidth);
          final horizontalPadding = _getHorizontalPadding(screenType);
          final sectionSpacing = _getSectionSpacing(screenType);

          return SmartRefresher(
            enablePullDown: true,
            onRefresh: _onRefresh,
            header: WaterDropMaterialHeader(
              backgroundColor: Theme.of(context).colorScheme.primary,
            ),
            controller: _refreshController,
            child: BlocBuilder<HomeBloc, HomeState>(
              builder: (context, state) {
                if (state.status == HomeStatus.loading) {
                  return const HomeShimmerWidget();
                }
                if (state.status == HomeStatus.error) {
                  return Center(
                    child: CustomErrorWidget(
                      message: state.message,
                      onRetry: () {
                        context.read<HomeBloc>().add(LoadHomeData());
                      },
                    ),
                  );
                }

                return FadeTransition(
                  opacity: _fadeAnimation,
                  child: SlideTransition(
                    position: _slideAnimation,
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          // Banner Section
                          _buildBannerSection(context, screenType),

                          // Main Content
                          Padding(
                            padding: EdgeInsets.symmetric(
                              horizontal: horizontalPadding,
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SizedBox(height: sectionSpacing * 0.5),

                                // Categories Section
                                _AnimatedSection(
                                  delay: 200,
                                  child: ResponsiveCategorySection(
                                    productCategories: productCategories,
                                  ),
                                ),

                                SizedBox(height: sectionSpacing),

                                // Food Products Section
                                _buildProductSection(
                                  context: context,
                                  state: state,
                                  screenType: screenType,
                                  title: Labels.topTrendingFoods,
                                  products: getApiFoodProducts(state),
                                  emptyMessage: Labels.noFoodProducts,
                                  onViewAllTap: () {
                                    context.read<NavBarBloc>().add(
                                      SelectTab(0),
                                    );
                                    context.read<ProductsBloc>().add(
                                      ChangeTabEvent(0),
                                    );
                                  },
                                  delay: 300,
                                ),

                                SizedBox(height: sectionSpacing),

                                // Supermarket Products Section
                                _buildProductSection(
                                  context: context,
                                  state: state,
                                  screenType: screenType,
                                  title: Labels.topSuperMarketProducts,
                                  products: getApiSupermarketProducts(state),
                                  emptyMessage: Labels.noSupermarketProducts,
                                  onViewAllTap: () {
                                    context.read<NavBarBloc>().add(
                                      SelectTab(0),
                                    );
                                    context.read<ProductsBloc>().add(
                                      ChangeTabEvent(1),
                                    );
                                  },
                                  delay: 400,
                                ),

                                SizedBox(height: sectionSpacing),

                                // Retail Products Section
                                _buildProductSection(
                                  context: context,
                                  state: state,
                                  screenType: screenType,
                                  title: Labels.topRetailProducts,
                                  products: getApiRetailProducts(state),
                                  emptyMessage: Labels.noRetailProducts,
                                  onViewAllTap: () {
                                    context.read<NavBarBloc>().add(
                                      SelectTab(0),
                                    );
                                    context.read<ProductsBloc>().add(
                                      ChangeTabEvent(2),
                                    );
                                  },
                                  delay: 500,
                                ),

                                SizedBox(height: sectionSpacing),

                                // Pharmacy Products Section
                                _buildProductSection(
                                  context: context,
                                  state: state,
                                  screenType: screenType,
                                  title: Labels.topPharmacyProducts,
                                  products: getApiPharmacyProducts(state),
                                  emptyMessage: Labels.noPharmacyProducts,
                                  onViewAllTap: () {
                                    context.read<NavBarBloc>().add(
                                      SelectTab(0),
                                    );
                                    context.read<ProductsBloc>().add(
                                      ChangeTabEvent(3),
                                    );
                                  },
                                  delay: 600,
                                ),

                                SizedBox(height: sectionSpacing),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }

  Widget _buildBannerSection(BuildContext context, ScreenType screenType) {
    double bannerHeight;
    switch (screenType) {
      case ScreenType.mobile:
        bannerHeight = context.heightPct(0.20);
        break;
      case ScreenType.mediumTablet:
        bannerHeight = context.heightPct(0.25);
        break;
      case ScreenType.largeTablet:
        bannerHeight = context.heightPct(0.30);
        break;
    }

    return _AnimatedSection(
      delay: 100,
      child: EcommerceBanner(imageUrls: imageUrl, height: bannerHeight),
    );
  }

  Widget _buildProductSection({
    required BuildContext context,
    required HomeState state,
    required ScreenType screenType,
    required String title,
    required List<ProductModel> products,
    required String emptyMessage,
    required VoidCallback onViewAllTap,
    required int delay,
  }) {
    return _AnimatedSection(
      delay: delay,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          HomeHeaderTile(
            title: title,
            onViewAllTap: products.isNotEmpty ? onViewAllTap : null,
          ),
          SizedBox(height: context.heightPct(0.01)),

          if (products.isEmpty)
            _buildEmptyState(context, emptyMessage)
          else
            _buildProductList(context, screenType, products),
        ],
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context, String message) {
    return Container(
      height: 120,
      width: double.infinity,
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Theme.of(context).colorScheme.outline.withValues(alpha: 0.1),
        ),
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.shopping_bag_outlined,
              size: 36,
              color: Theme.of(
                context,
              ).colorScheme.outline.withValues(alpha: 0.5),
            ),
            const SizedBox(height: 8),
            Text(
              message,
              style: TextStyle(
                color: Theme.of(context).colorScheme.outline,
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProductList(
    BuildContext context,
    ScreenType screenType,
    List<ProductModel> products,
  ) {
    if (screenType == ScreenType.mobile) {
      // Mobile: Horizontal scroll
      return SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children:
              products.asMap().entries.map((entry) {
                return _AnimatedProductCard(
                  delay: entry.key * 50,
                  child: ProductBox(
                    productId: entry.value.id,
                    productPrice: entry.value.productPrice,
                    productOriginalPrice: entry.value.productOriginalPrice,
                    productCategory: entry.value.productCategory,
                    productRating: entry.value.productRating,
                    onProductTap: () {
                      Navigator.pushNamed(
                        context,
                        RouteNames.productScreen,
                        arguments: entry.value.id,
                      );
                    },
                    isDeliverable: entry.value.isDeliverable,
                    categoryName: entry.value.categoryName,
                    productImageUrl: entry.value.productImageUrl,
                    productTitle: entry.value.productTitle,
                  ),
                );
              }).toList(),
        ),
      );
    } else {
      // Tablet: Staggered Grid layout
      final crossAxisCount = screenType == ScreenType.largeTablet ? 4 : 3;
      final displayProducts = products.take(crossAxisCount * 2).toList();

      return Wrap(
        spacing: 16,
        runSpacing: 16,
        children:
            displayProducts.asMap().entries.map((entry) {
              final product = entry.value;
              final width =
                  (MediaQuery.of(context).size.width -
                      (_getHorizontalPadding(screenType) * 2) -
                      (16 * (crossAxisCount - 1))) /
                  crossAxisCount;

              return _AnimatedProductCard(
                delay: entry.key * 50,
                child: SizedBox(
                  width: width,
                  child: ProductBox(
                    productId: product.id,
                    productPrice: product.productPrice,
                    productOriginalPrice: product.productOriginalPrice,
                    productCategory: product.productCategory,
                    productRating: product.productRating,
                    isDeliverable: product.isDeliverable,
                    categoryName: product.categoryName,
                    onProductTap: () {
                      Navigator.pushNamed(
                        context,
                        RouteNames.productScreen,
                        arguments: product.id,
                      );
                    },
                    productImageUrl: product.productImageUrl,
                    productTitle: product.productTitle,
                  ),
                ),
              );
            }).toList(),
      );
    }
  }
}

// Animated Section Widget
class _AnimatedSection extends StatefulWidget {
  final Widget child;
  final int delay;

  const _AnimatedSection({required this.child, this.delay = 0});

  @override
  State<_AnimatedSection> createState() => _AnimatedSectionState();
}

class _AnimatedSectionState extends State<_AnimatedSection>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.0, 0.65, curve: Curves.easeOut),
      ),
    );

    _scaleAnimation = Tween<double>(begin: 0.92, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.0, 0.8, curve: Curves.easeOutCubic),
      ),
    );

    // Start animation with delay
    Future.delayed(Duration(milliseconds: widget.delay), () {
      if (mounted) _controller.forward();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _fadeAnimation,
      child: ScaleTransition(scale: _scaleAnimation, child: widget.child),
    );
  }
}

// Animated Product Card Widget
class _AnimatedProductCard extends StatefulWidget {
  final Widget child;
  final int delay;

  const _AnimatedProductCard({required this.child, this.delay = 0});

  @override
  State<_AnimatedProductCard> createState() => _AnimatedProductCardState();
}

class _AnimatedProductCardState extends State<_AnimatedProductCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.0, 0.7, curve: Curves.easeOut),
      ),
    );

    _scaleAnimation = Tween<double>(
      begin: 0.85,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic));

    // Start animation with delay
    Future.delayed(Duration(milliseconds: widget.delay), () {
      if (mounted) _controller.forward();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _fadeAnimation,
      child: ScaleTransition(scale: _scaleAnimation, child: widget.child),
    );
  }
}
