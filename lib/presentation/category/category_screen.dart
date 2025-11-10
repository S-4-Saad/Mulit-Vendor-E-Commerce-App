import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:speezu/core/utils/media_querry_extention.dart';
import 'package:speezu/presentation/category/bloc/category_event.dart';
import 'package:speezu/presentation/category/bloc/category_state.dart';
import 'package:speezu/routes/route_names.dart';
import 'package:speezu/widgets/custom_app_bar.dart';
import 'package:speezu/widgets/error_widget.dart';
import 'package:speezu/widgets/image_type_extention.dart';
import 'package:speezu/widgets/rating_display_widget.dart';
import 'package:speezu/widgets/search_animated_container.dart';
import 'package:speezu/widgets/shop_shimmer_widget.dart';

import '../../core/assets/font_family.dart';
import '../../core/utils/labels.dart';
import '../../widgets/shop_box_widget.dart';
import 'bloc/category_bloc.dart';

class CategoryScreen extends StatefulWidget {
  final String categoryName;
  final int categoryId;

  const CategoryScreen({
    super.key,
    required this.categoryName,
    required this.categoryId,
  });

  @override
  State<CategoryScreen> createState() => _CategoryScreenState();
}

class _CategoryScreenState extends State<CategoryScreen> {
  @override
  void initState() {
    super.initState();
    // Load shops when the screen initializes
    context.read<CategoryBloc>().add(
      LoadShopsEvent(
        categoryId: widget.categoryId,
        category: widget.categoryName,
      ),
    );
  }

  // Helper method to determine if device is tablet
  bool _isTablet(BuildContext context) {
    final shortestSide = MediaQuery.of(context).size.shortestSide;
    return shortestSide >= 600;
  }

  // Get responsive padding
  double _getHorizontalPadding(BuildContext context, bool isTablet) {
    return isTablet ? 24.0 : 13.0;
  }

  // Get responsive cross axis count for grid
  int _getCrossAxisCount(double maxWidth) {
    if (maxWidth >= 1200) return 4; // Large tablets/desktop
    if (maxWidth >= 900) return 3;  // Medium tablets
    if (maxWidth >= 600) return 2;  // Small tablets
    return 1; // Mobile
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: widget.categoryName,
        action: BlocBuilder<CategoryBloc, CategoryState>(
          builder: (context, state) => IconButton(
            onPressed: () {
              context.read<CategoryBloc>().add(ChangeViewEvent());
            },
            icon: Icon(
              state.isGridView ? Icons.grid_4x4 : Icons.list_rounded,
              color: Theme.of(context).colorScheme.onSecondary,
            ),
          ),
        ),
      ),
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: LayoutBuilder(
        builder: (context, constraints) {
          final isTablet = _isTablet(context);
          final horizontalPadding = _getHorizontalPadding(context, isTablet);
          final maxWidth = constraints.maxWidth;

          return Padding(
            padding: EdgeInsets.symmetric(
              horizontal: horizontalPadding,
              vertical: 8,
            ),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  // Constrain search container width on tablets
                  ConstrainedBox(
                    constraints: BoxConstraints(
                      maxWidth: isTablet ? 600 : double.infinity,
                    ),
                    child: SearchContainer(),
                  ),
                  SizedBox(height: context.heightPct(0.01)),
                  Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: isTablet ? 16.0 : 10.0,
                    ),
                    child: Row(
                      children: [
                        Icon(
                          Icons.store_mall_directory_outlined,
                          color: Theme.of(context)
                              .colorScheme
                              .onSecondary
                              .withValues(alpha: .7),
                          size: isTablet ? 28 : 24,
                        ),
                        SizedBox(width: context.widthPct(0.02)),
                        Text(
                          Labels.topStores,
                          style: TextStyle(
                            fontSize: isTablet ? 18 : context.scaledFont(15),
                            fontFamily: FontFamily.fontsPoppinsSemiBold,
                            color: Theme.of(context).colorScheme.onSecondary,
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: context.heightPct(0.01)),
                  BlocBuilder<CategoryBloc, CategoryState>(
                    builder: (context, state) {
                      bool isGridView = state.isGridView;

                      if (state.shopStatus == ShopStatus.loading) {
                        return ShimmerLoadingWidget(
                          isGridView: isGridView,
                          itemCount: isTablet ? 8 : 6,
                        );
                      }

                      if (state.shopStatus == ShopStatus.error) {
                        return Center(
                          child: CustomErrorWidget(
                            message: state.message ?? Labels.error,
                            onRetry: () {
                              context.read<CategoryBloc>().add(
                                LoadShopsEvent(
                                  categoryId: widget.categoryId,
                                  category: widget.categoryName,
                                ),
                              );
                            },
                          ),
                        );
                      }

                      if (state.shops.isEmpty) {
                        return Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.store_outlined,
                                size: isTablet ? 80 : 64,
                                color: Colors.grey,
                              ),
                              SizedBox(height: 16),
                              Text(
                                widget.categoryId == 1
                                    ? Labels.noStoresForFood
                                    : widget.categoryId == 2
                                    ? Labels.noStoresForRetail
                                    : widget.categoryId == 3
                                    ? Labels.noStoresForSupermarket
                                    : Labels.noStoresForPharmacy,
                                style: TextStyle(
                                  fontSize: isTablet ? 18 : 16,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                        );
                      }

                      // Grid view for big shop boxes
                      if (isGridView) {
                        // On tablets, use StaggeredGrid layout
                        if (isTablet) {
                          final crossAxisCount = _getCrossAxisCount(maxWidth);
                          return StaggeredGrid.count(
                            crossAxisCount: crossAxisCount,
                            mainAxisSpacing: 12,
                            crossAxisSpacing: 12,
                            children: state.shops.map((shop) {
                              return StaggeredGridTile.fit(
                                crossAxisCellCount: 1,
                                child: ShopBoxBigWidget(
                                  imageUrl: shop.imageUrl,
                                  shopName: shop.shopName,
                                  shopDescription: shop.shopDescription,
                                  shopRating: shop.shopRating,
                                  isOpen: shop.isOpen,
                                  isDelivering: shop.isDelivering,
                                  onShopBoxTap: () {
                                    Navigator.pushNamed(
                                      context,
                                      RouteNames.shopNavBarScreen,
                                      arguments: shop.id,
                                    );
                                  },
                                  onDirectionTap: () {
                                    print('Direction to ${shop.shopName}');
                                  },
                                ),
                              );
                            }).toList(),
                          );
                        }

                        // On mobile, keep column layout
                        return Column(
                          children: state.shops.map((shop) {
                            return ShopBoxBigWidget(
                              imageUrl: shop.imageUrl,
                              shopName: shop.shopName,
                              shopDescription: shop.shopDescription,
                              shopRating: shop.shopRating,
                              isOpen: shop.isOpen,
                              isDelivering: shop.isDelivering,
                              onShopBoxTap: () {
                                Navigator.pushNamed(
                                  context,
                                  RouteNames.shopNavBarScreen,
                                  arguments: shop.id,
                                );
                              },
                              onDirectionTap: () {
                                print('Direction to ${shop.shopName}');
                              },
                            );
                          }).toList(),
                        );
                      }

                      // List view for compact shop boxes
                      final crossAxisCount = isTablet
                          ? _getCrossAxisCount(maxWidth)
                          : 1;

                      if (isTablet && crossAxisCount > 1) {
                        // StaggeredGrid layout for tablets in list view
                        return StaggeredGrid.count(
                          crossAxisCount: crossAxisCount,
                          mainAxisSpacing: 12,
                          crossAxisSpacing: 12,
                          children: state.shops.map((shop) {
                            return StaggeredGridTile.fit(
                              crossAxisCellCount: 1,
                              child: _buildListShopItem(
                                context,
                                shop,
                                isTablet,
                              ),
                            );
                          }).toList(),
                        );
                      }

                      // Single column list for mobile
                      return ListView.separated(
                        padding: EdgeInsets.zero,
                        itemCount: state.shops.length,
                        separatorBuilder: (_, __) => SizedBox(
                          height: isTablet ? 12 : 10,
                        ),
                        itemBuilder: (context, index) {
                          final shop = state.shops[index];
                          return _buildListShopItem(
                            context,
                            shop,
                            isTablet,
                          );
                        },
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                      );
                    },
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildListShopItem(
      BuildContext context,
      dynamic shop,
      bool isTablet,
      ) {
    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(
          context,
          RouteNames.shopNavBarScreen,
          arguments: shop.id,
        );
      },
      child: Container(
        clipBehavior: Clip.antiAlias,
        margin: EdgeInsets.only(
          right: 5,
          bottom: 5,
          left: 5,
        ),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: Theme.of(context).colorScheme.onPrimary,
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withValues(alpha: 0.2),
              spreadRadius: 1,
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            CustomImageView(
              imagePath: shop.imageUrl,
              width: isTablet ? 120 : 100,
              height: isTablet ? 100 : 80,
              fit: BoxFit.cover,
            ),
            SizedBox(width: context.widthPct(0.03)),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    shop.shopName,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: isTablet ? 16 : context.scaledFont(14),
                      fontFamily: FontFamily.fontsPoppinsSemiBold,
                      color: Theme.of(context).colorScheme.onSecondary,
                    ),
                  ),
                  Text(
                    shop.shopDescription,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: isTablet ? 14 : context.scaledFont(12),
                      fontFamily: FontFamily.fontsPoppinsRegular,
                      color: Theme.of(context)
                          .colorScheme
                          .onSecondary
                          .withValues(alpha: .7),
                    ),
                  ),
                  RatingDisplayWidget(
                    rating: shop.shopRating,
                    starSize: isTablet ? 16 : 14,
                  ),
                ],
              ),
            ),
            SizedBox(width: context.widthPct(0.02)),
          ],
        ),
      ),
    );
  }
}