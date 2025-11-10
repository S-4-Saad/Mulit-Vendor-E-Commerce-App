import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:speezu/core/services/urls.dart';
import 'package:speezu/presentation/favourites/bloc/favourite_event.dart';

import '../../routes/route_names.dart';
import '../../widgets/empty_favourite_list.dart';
import '../../widgets/error_widget.dart';
import '../../widgets/product_box_widget.dart';
import '../../widgets/products_tab_shimmer_widget.dart';
import 'bloc/favourite_bloc.dart';
import 'bloc/favourite_state.dart';

class FavouriteProductsScreen extends StatefulWidget {
  const FavouriteProductsScreen({super.key});

  @override
  State<FavouriteProductsScreen> createState() =>
      _FavouriteProductsScreenState();
}

class _FavouriteProductsScreenState extends State<FavouriteProductsScreen> {
  @override
  void initState() {
    super.initState();

    context.read<FavouriteBloc>().add(FetchFavouritesEvent());
  }

  Future<void> _onRefresh() async {
    context.read<FavouriteBloc>().add(FetchFavouritesEvent());
    // simulate network call
    await Future.delayed(const Duration(seconds: 2));
    _refreshController.refreshCompleted(); // ✅ must call this!
  }

  final RefreshController _refreshController = RefreshController(
    initialRefresh: false,
  );

  Widget build(BuildContext context) {
    return SmartRefresher(
      enablePullDown: true,
      onRefresh: _onRefresh,
      header: WaterDropMaterialHeader(
        backgroundColor: Theme.of(context).colorScheme.primary,
      ),
      controller: _refreshController,
      child: Scaffold(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        body: BlocBuilder<FavouriteBloc, FavouriteState>(
          builder: (context, state) {
            if (state.status == FavouriteStatus.loading) {
              return Center(child: const ProductsTabShimmerWidget());
            } else if (state.status == FavouriteStatus.failure) {
              return Center(
                child: CustomErrorWidget(
                  message: state.message,
                  onRetry: () {
                    context.read<FavouriteBloc>().add(FetchFavouritesEvent());
                  },
                ),
              );
            } else if (state.favouriteListModel?.data == null ||
                state.favouriteListModel!.data!.isEmpty) {
              return const Center(child: EmptyFavouritesWidget());
            }
            return LayoutBuilder(
              builder: (context, constraints) {
                double screenWidth = constraints.maxWidth;

                // 🔹 Dynamically decide number of columns based on screen width
                int crossAxisCount;
                if (screenWidth >= 1200) {
                  crossAxisCount = 4; // Desktop / large tablet
                } else if (screenWidth >= 800) {
                  crossAxisCount = 3; // Tablet (like 800px width)
                } else if (screenWidth >= 600) {
                  crossAxisCount = 2; // Large mobile / foldable
                } else {
                  crossAxisCount = 2; // Standard mobile (like 411px width)
                }

                print('📱 Screen width: $screenWidth → Columns: $crossAxisCount');

                final favorites = state.favouriteListModel?.data ?? [];

                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10.0),
                  child: SingleChildScrollView(
                    child: StaggeredGrid.count(
                      crossAxisCount: crossAxisCount,
                      mainAxisSpacing: 10,
                      crossAxisSpacing: 10,
                      children: List.generate(favorites.length, (index) {
                        final favItem = favorites[index];
                        final product = favItem.product;

                        if (product == null) return const SizedBox();

                        final productId = product.id?.toString() ?? '';
                        final imageUrl = '$imageBaseUrl${product.productImage}';
                        final productName = product.productName ?? '';
                        final productPrice =
                            double.tryParse(product.productDiscountedPrice ?? '0') ?? 0;
                        final productOriginalPrice =
                            double.tryParse(product.productPrice ?? '0') ?? 0;
                        final productRating =
                            double.tryParse(product.productRating?.toString() ?? '0.0') ??
                                0.0;

                        return StaggeredGridTile.fit(
                          crossAxisCellCount: 1,
                          child: ProductBox(
                            marginPadding: const Padding(padding: EdgeInsets.all(0)),
                            productWidth: screenWidth / crossAxisCount - 20,
                            productId: productId,
                            productPrice: productPrice,
                            productOriginalPrice: productOriginalPrice,
                            productCategory: 'Test',
                            productRating: productRating,
                            onProductTap: () {
                              Navigator.pushNamed(
                                context,
                                RouteNames.productScreen,
                                arguments: productId,
                              );
                            },
                            productImageUrl: imageUrl,
                            productTitle: productName,
                          ),
                        );
                      }),
                    ),
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}
