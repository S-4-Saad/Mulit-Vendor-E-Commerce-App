import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:speezu/presentation/products/bloc/products_bloc.dart';
import 'package:speezu/presentation/products/bloc/products_event.dart';
import 'package:speezu/presentation/products/bloc/products_state.dart';
import 'package:speezu/widgets/product_box_widget.dart';
import 'package:speezu/widgets/products_tab_shimmer_widget.dart';

import '../../../routes/route_names.dart';

class DynamicProductsScreen extends StatefulWidget {
  final String categoryName;
  
  const DynamicProductsScreen({
    super.key,
    required this.categoryName,
  });

  @override
  State<DynamicProductsScreen> createState() => _DynamicProductsScreenState();
}

class _DynamicProductsScreenState extends State<DynamicProductsScreen> {
  @override
  void initState() {
    super.initState();
    print('🎯 DynamicProductsScreen initialized for category: ${widget.categoryName}');
    // Load products immediately when the screen is initialized
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ProductsBloc>().add(LoadProductsEvent(categoryName: widget.categoryName));
    });
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: double.infinity,
      child: BlocBuilder<ProductsBloc, ProductsState>(
        builder: (context, state) {
          print('📊 DynamicProductsScreen state: ${state.status}, category: ${state.currentCategoryName}');
          
          // Load products when category changes
          if (state.currentCategoryName != widget.categoryName) {
            print('🔄 Category changed, loading products for: ${widget.categoryName}');
            WidgetsBinding.instance.addPostFrameCallback((_) {
              context.read<ProductsBloc>().add(LoadProductsEvent(categoryName: widget.categoryName));
            });
          }

          // Show loading state (including initial state)
          if (state.status == ProductsStatus.loading || state.status == ProductsStatus.initial) {
            print('⏳ Showing shimmer for ${widget.categoryName}');
            return const ProductsTabShimmerWidget();
          }
        
        // Show error state
        if (state.status == ProductsStatus.error) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.all(50.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.error_outline,
                    size: 64,
                    color: Colors.grey[400],
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Error: ${state.message}',
                    style: TextStyle(
                      color: Colors.grey[600],
                      fontSize: 16,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      context.read<ProductsBloc>().add(
                        LoadProductsEvent(categoryName: widget.categoryName),
                      );
                    },
                    child: const Text('Retry'),
                  ),
                ],
              ),
            ),
          );
        }
        
        // Show products
        if (state.status == ProductsStatus.success) {
          if (state.products.isEmpty) {
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
                      'No ${widget.categoryName.toLowerCase()} products available',
                      style: TextStyle(
                        color: Colors.grey[600],
                        fontSize: 16,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            );
          }
          
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10.0),
            child: GridView.builder(
              padding: const EdgeInsets.symmetric(vertical: 10.0),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: 10,
                crossAxisSpacing: 10,
                childAspectRatio: 0.87,
              ),
              itemCount: state.products.length,
              itemBuilder: (context, index) {
                final product = state.products[index];
                return ProductBox(
                  marginPadding: const Padding(padding: EdgeInsets.all(0)),
                  productWidth: 200,
                  productPrice: product.productPrice,
                  productOriginalPrice: product.productOriginalPrice,
                  productCategory: product.productCategory,
                  productRating: product.productRating,
                  isProductFavourite: product.isProductFavourite,
                  onFavouriteTap: () {
                    // TODO: Implement favourite functionality
                  },
                  onProductTap: () {
                    Navigator.pushNamed(
                        context,
                        RouteNames.productScreen,
                        arguments: product.id,
                      );
                  },
                  productImageUrl: product.productImageUrl,
                  productTitle: product.productTitle,
                );
              },
            ),
          );
        }
        
          // Default state
          return const ProductsTabShimmerWidget();
        },
      ),
    );
  }
}
