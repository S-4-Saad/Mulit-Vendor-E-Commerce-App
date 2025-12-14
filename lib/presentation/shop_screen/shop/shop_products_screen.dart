import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:speezu/core/utils/media_querry_extention.dart';
import 'package:speezu/presentation/shop_screen/bloc/shop_bloc.dart';
import 'package:speezu/presentation/shop_screen/bloc/shop_event.dart';
import 'package:speezu/widgets/error_widget.dart';
import 'package:speezu/widgets/no_product_widget.dart';
import '../../../routes/route_names.dart';
import '../../../widgets/product_box_widget.dart';
import '../../../widgets/sub_category_widget.dart';
import '../../../widgets/shop_products_shimmer_widget.dart';
import '../bloc/shop_state.dart';

class ShopProductsScreen extends StatelessWidget {
  final int storeId;

  ShopProductsScreen({super.key, required this.storeId});

  @override
  Widget build(BuildContext context) {
    // Clear previous store data and load categories when widget is built
    context.read<ShopBloc>().add(ClearStoreDataEvent());
    context.read<ShopBloc>().add(LoadCategoriesEvent(storeId: storeId));

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: BlocBuilder<ShopBloc, ShopState>(
        builder: (context, state) {
          // Show loading state while categories are being fetched
          if (state.categoriesStatus == CategoriesStatus.loading) {
            return const ShopProductsShimmerWidget();
          }

          // Show error state if categories failed to load
          if (state.categoriesStatus == CategoriesStatus.error) {
            return Center(
              child: CustomErrorWidget(
                message: state.message,
                onRetry: () {
                  context.read<ShopBloc>().add(
                    LoadCategoriesEvent(storeId: storeId),
                  );
                },
              ),
            );
          }

          // Show categories when loaded successfully
          if (state.categoriesStatus == CategoriesStatus.success &&
              state.categories.isNotEmpty) {
            // Set initial tab if not set
            if (state.tabCurrentIndex >= state.categories.length) {
              context.read<ShopBloc>().add(ChangeTabEvent(0));
            }

            final categories = state.categories;

            return SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    SizedBox(height: context.heightPct(0.01)),

                    // Horizontal scrollable category tabs using SubCategoryBox
                    SizedBox(
                      height: 130,
                      child: ListView.separated(
                        scrollDirection: Axis.horizontal,
                        itemCount: categories.length,
                        separatorBuilder: (_, __) => SizedBox(width: 10),
                        itemBuilder: (context, index) {
                          final subCategory = categories[index];
                          final isSelected = state.tabCurrentIndex == index;

                          return SubCategoryBox(
                            marginPadding: EdgeInsets.zero,
                            title: subCategory.name,
                            imageUrl: subCategory.imageUrl,
                            isSelected: isSelected,
                            onTap: () {
                              context.read<ShopBloc>().add(
                                ChangeTabEvent(index),
                              );
                            },
                          );
                        },
                      ),
                    ),

                    SizedBox(height: context.heightPct(0.02)),

                    // Products for selected category
                    if (state.tabCurrentIndex < categories.length) ...[
                      BlocBuilder<ShopBloc, ShopState>(
                        builder: (context, state) {
                          final selectedCategory =
                              categories[state.tabCurrentIndex];

                          // Load products when category changes or if products haven't been loaded yet
                          if (state.currentCategoryId != selectedCategory.id ||
                              (state.productsStatus == ProductsStatus.initial &&
                                  state.currentProducts.isEmpty)) {
                            WidgetsBinding.instance.addPostFrameCallback((_) {
                              context.read<ShopBloc>().add(
                                LoadProductsEvent(
                                  storeId: storeId,
                                  categoryId: selectedCategory.id,
                                ),
                              );
                            });
                          }

                          // Show loading state for products
                          if (state.productsStatus == ProductsStatus.loading ||
                              (state.productsStatus == ProductsStatus.initial &&
                                  state.currentProducts.isEmpty)) {
                            return const Padding(
                              padding: EdgeInsets.all(8.0),
                              child: ProductsOnlyShimmerWidget(),
                            );
                          }

                          // Show error state for products
                          if (state.productsStatus == ProductsStatus.error) {
                            return Center(
                              child: CustomErrorWidget(
                                message: state.message,
                                onRetry: () {
                                  context.read<ShopBloc>().add(
                                    LoadProductsEvent(
                                      storeId: storeId,
                                      categoryId: selectedCategory.id,
                                    ),
                                  );
                                },
                              ),
                            );
                          }

                          // Show products
                          final products = state.currentProducts;
                          return SingleChildScrollView(
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 10.0,
                              ),
                              child:
                                  products.isEmpty
                                      ? const Center(child: NoProductsWidget())
                                      : LayoutBuilder(
                                    builder: (context, constraints) {
                                      final double screenWidth = constraints.maxWidth;

                                      // 🔹 Dynamically decide columns based on screen width
                                      int crossAxisCount;
                                      if (screenWidth >= 1200) {
                                        crossAxisCount =
                                        4; // Desktop or very large tablet
                                      } else if (screenWidth >= 700) {
                                        crossAxisCount =
                                        3; // Tablet (your 800px screen)
                                      } else if (screenWidth >= 600) {
                                        crossAxisCount =
                                        2; // Large phones / foldables
                                      } else {
                                        crossAxisCount =
                                        2; // Standard mobile (your 411px phone)
                                      }

                                      print('📱 Width: $screenWidth → Columns: $crossAxisCount');

                                      return StaggeredGrid.count(
                                        crossAxisCount: crossAxisCount,
                                        mainAxisSpacing: 10,
                                        crossAxisSpacing: 10,
                                        children: List.generate(products.length, (index) {
                                          final product = products[index];

                                          // Each product box width is calculated dynamically
                                          final double productWidth = screenWidth / crossAxisCount - 20;

                                          return StaggeredGridTile.fit(
                                            crossAxisCellCount: 1,
                                            child: ProductBox(
                                              marginPadding: const Padding(
                                                padding: EdgeInsets.all(0),
                                              ),
                                              isDeliverable: product.isDeliverable,
                                              categoryName: product.categoryName,
                                              productWidth: productWidth,
                                              productPrice: product.productPrice,
                                              productOriginalPrice: product.productOriginalPrice,
                                              productCategory: product.productCategory,
                                              productRating: product.productRating,
                                              productId: product.id,
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
                                          );
                                        }),
                                      );
                                    },
                                  ),
                            ),
                          );
                        },
                      ),
                    ],
                  ],
                ),
              ),
            );
          }

          // Default state - show loading
          return const ShopProductsShimmerWidget();
        },
      ),
    );
  }
}
