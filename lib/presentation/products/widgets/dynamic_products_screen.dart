import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:speezu/presentation/products/bloc/products_bloc.dart';
import 'package:speezu/presentation/products/bloc/products_event.dart';
import 'package:speezu/presentation/products/bloc/products_state.dart';
import 'package:speezu/widgets/product_box_widget.dart';
import 'package:speezu/widgets/products_tab_shimmer_widget.dart';
import '../../../core/utils/labels.dart';
import '../../../routes/route_names.dart';
import '../../../widgets/error_widget.dart';

class DynamicProductsScreen extends StatefulWidget {
  final String categoryName;

  const DynamicProductsScreen({super.key, required this.categoryName});

  @override
  State<DynamicProductsScreen> createState() => _DynamicProductsScreenState();
}

class _DynamicProductsScreenState extends State<DynamicProductsScreen> {
  final RefreshController _refreshController = RefreshController();

  Future<void> _onRefresh() async {
    context.read<ProductsBloc>().add(
      LoadProductsEvent(categoryName: widget.categoryName, forceReload: true),
    );
    await Future.delayed(const Duration(seconds: 1));
    _refreshController.refreshCompleted();
  }

  @override
  void initState() {
    super.initState();
    print('🎯 Init DynamicProductsScreen for: ${widget.categoryName}');
    // WidgetsBinding.instance.addPostFrameCallback((_) {
    //   context.read<ProductsBloc>().add(
    //     LoadProductsEvent(categoryName: widget.categoryName,forceReload: true),
    //   );
    // });
  }

  @override
  Widget build(BuildContext context) {
    return SmartRefresher(
      controller: _refreshController,
      enablePullDown: true,
      onRefresh: _onRefresh,
      child: BlocBuilder<ProductsBloc, ProductsState>(
        builder: (context, state) {
          final status =
              state.statusByCategory[widget.categoryName] ??
              ProductsStatus.initial;
          final products = state.productsByCategory[widget.categoryName] ?? [];
          final message = state.messageByCategory[widget.categoryName] ?? '';

          print(
            '📊 Screen(${widget.categoryName}) → Status: $status, Products: ${products.length}',
          );

          // --- Loading ---
          if (status == ProductsStatus.loading ||
              status == ProductsStatus.initial) {
            // return const CircularProgressIndicator();
            return Center(child: ProductsTabShimmerWidget());
          }

          // --- Error ---
          if (status == ProductsStatus.error) {
            return Center(
              child: CustomErrorWidget(
                message:
                    message,
                onRetry: () {
                  context.read<ProductsBloc>().add(
                    LoadProductsEvent(categoryName: widget.categoryName),
                  );
                },
              ),
            );
          }

          // --- Empty ---
          if (status == ProductsStatus.success && products.isEmpty) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(50.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.inventory_2_outlined,
                      size: 64,
                      color: Colors.grey[400],
                    ),
                    const SizedBox(height: 16),
                    Text(
                      '${Labels.no} ${widget.categoryName.toLowerCase()} ${Labels.productAvailable}',
                      style: TextStyle(color: Colors.grey[600], fontSize: 16),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            );
          }

          // --- Success ---

          return LayoutBuilder(
            builder: (context, constraints) {
              double screenWidth = constraints.maxWidth;

              // 🔹 Dynamically decide number of columns based on device width
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
              print('📱 Screen width: $screenWidth → Columns: $crossAxisCount');

              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10.0),
                child: SingleChildScrollView(
                  child: StaggeredGrid.count(
                    crossAxisCount: crossAxisCount,
                    mainAxisSpacing: 10,
                    crossAxisSpacing: 10,
                    children: List.generate(products.length, (index) {
                      final product = products[index];
                      return StaggeredGridTile.fit(
                        crossAxisCellCount: 1,
                        child: ProductBox(

                          marginPadding: const Padding(padding: EdgeInsets.all(0)),
                          productWidth: screenWidth / crossAxisCount - 20,
                          productId: product.id,
                          isDeliverable: product.isDeliverable,
                          categoryName: product.categoryName,
                          productPrice: product.productPrice,
                          productOriginalPrice: product.productOriginalPrice,
                          productCategory: product.productCategory,
                          productRating: product.productRating,
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
                  ),
                ),
              );
            },
          );


        },
      ),
    );
  }
}
