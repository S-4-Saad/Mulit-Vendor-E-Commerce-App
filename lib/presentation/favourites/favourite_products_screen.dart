import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10.0),
              child: SingleChildScrollView(
                child: Wrap(
                  spacing: 10,
                  runSpacing: 10,
                  children: List.generate(
                    state.favouriteListModel?.data?.length ?? 0,
                    (index) {
                      return SizedBox(
                        width:
                            MediaQuery.of(context).size.width / 2 -
                            20, // 2 columns
                        child: ProductBox(
                          marginPadding: const Padding(
                            padding: EdgeInsets.all(0),
                          ),
                          productWidth: 200,
                          productId:
                              state.favouriteListModel?.data![index].id
                                  .toString() ??
                              '',
                          productPrice:
                              double.tryParse(
                                state
                                        .favouriteListModel
                                        ?.data![index]
                                        .product!
                                        .productDiscountedPrice ??
                                    '0',
                              ) ??
                              0,
                          productOriginalPrice:
                              double.tryParse(
                                state
                                        .favouriteListModel
                                        ?.data![index]
                                        .product!
                                        .productPrice ??
                                    '0',
                              ) ??
                              0,
                          productCategory: 'Test',
                          productRating:
                              double.tryParse(
                                state
                                        .favouriteListModel
                                        ?.data?[index]
                                        .product
                                        ?.productRating
                                        ?.toString() ??
                                    '0.0',
                              ) ??
                              0.0,

                          onProductTap: () {
                            Navigator.pushNamed(
                              context,
                              RouteNames.productScreen,
                              arguments:
                                  state
                                      .favouriteListModel
                                      ?.data![index]
                                      .product!
                                      .id
                                      .toString(),
                            );
                          },
                          productImageUrl:
                              '$imageBaseUrl${state.favouriteListModel?.data![index].product!.productImage}',
                          productTitle:
                              state
                                  .favouriteListModel
                                  ?.data![index]
                                  .product!
                                  .productName ??
                              '',
                        ),
                      );
                    },
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
