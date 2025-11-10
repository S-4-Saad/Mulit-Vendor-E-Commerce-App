import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:speezu/core/assets/app_images.dart';
import 'package:speezu/core/services/urls.dart';
import 'package:speezu/presentation/search_products/bloc/search_product_state.dart';
import 'package:speezu/presentation/search_products/bloc/search_products_event.dart';
import 'package:speezu/widgets/custom_app_bar.dart';
import 'package:speezu/widgets/products_tab_shimmer_widget.dart';
import 'package:speezu/widgets/shop_box_widget.dart';

import '../../core/assets/font_family.dart';
import '../../core/utils/labels.dart';
import '../../routes/route_names.dart';
import '../../widgets/product_box_widget.dart';
import '../../widgets/search_result_shimmar.dart';
import 'bloc/search_products_bloc.dart';

class SearchResultsScreen extends StatefulWidget {
  final String searchQuery;

  const SearchResultsScreen({super.key, required this.searchQuery});

  @override
  State<SearchResultsScreen> createState() => _SearchResultsScreenState();
}

class _SearchResultsScreenState extends State<SearchResultsScreen> {
  late TextEditingController _searchController;

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController(text: widget.searchQuery);

    // Trigger initial API call
    context.read<SearchProductsBloc>().add(
      SearchProducts(query: widget.searchQuery),
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _onSearchChanged(String value) {
    if (value.trim().isNotEmpty) {
      context.read<SearchProductsBloc>().add(
        SearchProducts(query: value.trim()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: CustomAppBar(title: Labels.search),
      body: SafeArea(
        child: Column(
          children: [
            // Enhanced Search Bar with Gradient Shadow
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Theme.of(context).scaffoldBackgroundColor,
                    Theme.of(
                      context,
                    ).scaffoldBackgroundColor.withValues(alpha: 0.0),
                  ],
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 12, 16, 20),
                child: BlocBuilder<SearchProductsBloc, SearchProductsState>(
                  builder: (context, state) {
                    final allSuggestions =
                        [
                          ...?state.productNames,
                          ...?state.categoryNames,
                        ].whereType<String>().toSet().toList();

                    return Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: Theme.of(
                              context,
                            ).colorScheme.primary.withValues(alpha: 0.1),
                            blurRadius: 8,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: TypeAheadField<String>(
                        controller: _searchController,
                        hideOnEmpty: true,
                        hideWithKeyboard: false,
                        hideOnUnfocus: true,
                        suggestionsCallback: (pattern) {
                          if (pattern.isEmpty) return [];
                          return allSuggestions
                              .where(
                                (item) => item.toLowerCase().contains(
                                  pattern.toLowerCase(),
                                ),
                              )
                              .toList();
                        },
                        itemBuilder: (context, suggestion) {
                          return Container(
                            decoration: BoxDecoration(
                              color: Theme.of(context).colorScheme.onPrimary,
                              border: Border(
                                bottom: BorderSide(
                                  color: Theme.of(context)
                                      .colorScheme
                                      .onSecondary
                                      .withValues(alpha: 0.05),
                                  width: 1,
                                ),
                              ),
                            ),
                            child: ListTile(
                              contentPadding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 4,
                              ),
                              leading: Icon(
                                Icons.search,
                                color: Theme.of(
                                  context,
                                ).colorScheme.primary.withValues(alpha: 0.6),
                                size: 20,
                              ),
                              trailing: Transform.rotate(
                                angle: -0.785398, // -45 degrees in radians
                                child: Icon(
                                  Icons.arrow_forward,
                                  color: Theme.of(
                                    context,
                                  ).colorScheme.primary.withValues(alpha: 0.4),
                                  size: 18,
                                ),
                              ),
                              title: Text(
                                suggestion,
                                style: TextStyle(
                                  fontSize: 14,
                                  fontFamily: FontFamily.fontsPoppinsRegular,
                                  color:
                                      Theme.of(context).colorScheme.onSecondary,
                                ),
                              ),
                            ),
                          );
                        },
                        onSelected: (suggestion) {
                          _searchController.text = suggestion;
                          FocusScope.of(context).unfocus();
                          _onSearchChanged(suggestion);
                        },
                        builder: (context, controller, focusNode) {
                          return TextField(
                            controller: controller,
                            focusNode: focusNode,
                            cursorColor: Theme.of(context).colorScheme.primary,
                            onChanged: _onSearchChanged,
                            onSubmitted: (_) => focusNode.unfocus(),
                            style: TextStyle(
                              fontFamily: FontFamily.fontsPoppinsRegular,
                              fontSize: 14,
                              color: Theme.of(context).colorScheme.onSecondary,
                            ),
                            decoration: InputDecoration(
                              filled: true,
                              fillColor:
                                  Theme.of(context).colorScheme.onPrimary,
                              contentPadding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 14,
                              ),
                              prefixIcon: Icon(
                                Icons.search,
                                color: Theme.of(context).colorScheme.primary,
                                size: 22,
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: BorderSide(
                                  color: Theme.of(context).colorScheme.primary,
                                  width: 2,
                                ),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: BorderSide(
                                  color: Theme.of(context)
                                      .colorScheme
                                      .onSecondary
                                      .withValues(alpha: 0.15),
                                  width: 1.5,
                                ),
                              ),
                              hintText: Labels.searchProducts,
                              hintStyle: TextStyle(
                                fontFamily: FontFamily.fontsPoppinsRegular,
                                fontSize: 14,
                                color: Theme.of(context).colorScheme.onSecondary
                                    .withValues(alpha: 0.4),
                              ),
                              suffixIcon:
                                  _searchController.text.isNotEmpty
                                      ? Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          if (_searchController.text.isNotEmpty)
                                            IconButton(
                                              icon: Icon(
                                                Icons.clear,
                                                color: Theme.of(context)
                                                    .colorScheme
                                                    .onSecondary
                                                    .withValues(alpha: 0.5),
                                                size: 20,
                                              ),
                                              onPressed: () {
                                                _searchController.clear();
                                                FocusScope.of(
                                                  context,
                                                ).unfocus();
                                              },
                                            ),
                                          Container(
                                            margin: const EdgeInsets.only(
                                              right: 8,
                                            ),
                                            child: Material(
                                              color:
                                                  Theme.of(
                                                    context,
                                                  ).colorScheme.primary,
                                              borderRadius:
                                                  BorderRadius.circular(8),
                                              child: InkWell(
                                                onTap: () {
                                                  FocusScope.of(
                                                    context,
                                                  ).unfocus();
                                                  _onSearchChanged(
                                                    _searchController.text,
                                                  );
                                                },
                                                borderRadius:
                                                    BorderRadius.circular(8),
                                                child: Container(
                                                  padding:
                                                      const EdgeInsets.symmetric(
                                                        horizontal: 16,
                                                        vertical: 8,
                                                      ),
                                                  child: Text(
                                                    Labels.search,
                                                    style: TextStyle(
                                                      fontFamily:
                                                          FontFamily
                                                              .fontsPoppinsMedium,
                                                      fontSize: 13,
                                                      color:
                                                          Theme.of(context)
                                                              .colorScheme
                                                              .onPrimary,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      )
                                      : null,
                              border: InputBorder.none,
                            ),
                          );
                        },
                      ),
                    );
                  },
                ),
              ),
            ),
            BlocBuilder<SearchProductsBloc, SearchProductsState>(
              builder:
                  (context, state) => Container(
                    margin: EdgeInsets.symmetric(horizontal: 15),
                    padding: const EdgeInsets.symmetric(
                      vertical: 12,
                      horizontal: 16,
                    ),
                    decoration: BoxDecoration(
                      color: Theme.of(
                        context,
                      ).colorScheme.primary.withValues(alpha: 0.05),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          Icons.info_outline,
                          size: 18,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            '${Labels.found} ${state.searchStores?.length} ${state.searchStores?.length == 1 ? Labels.store : Labels.stores} and ${state.searchProducts?.length} ${state.searchProducts?.length == 1 ? Labels.product : Labels.products}',
                            style: TextStyle(
                              fontFamily: FontFamily.fontsPoppinsMedium,
                              fontSize: 13,
                              color: Theme.of(context).colorScheme.onSecondary,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
            ),
            // Results Section
            Expanded(
              child: BlocBuilder<SearchProductsBloc, SearchProductsState>(
                builder: (context, state) {
                  if (state.searchProductsStatus ==
                      SearchProductsStatus.loading) {
                    return const Padding(
                      padding: EdgeInsets.all(8.0),
                      child: SearchResultShimmar(),
                    );
                  }

                  if (state.searchProductsStatus ==
                      SearchProductsStatus.error) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.error_outline,
                            size: 64,
                            color: Theme.of(
                              context,
                            ).colorScheme.error.withValues(alpha: 0.5),
                          ),
                          const SizedBox(height: 16),
                          Text(
                            'Oops! Something went wrong',
                            style: TextStyle(
                              fontFamily: FontFamily.fontsPoppinsSemiBold,
                              fontSize: 16,
                              color: Theme.of(context).colorScheme.onSecondary,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            state.message ?? 'Please try again',
                            style: TextStyle(
                              fontFamily: FontFamily.fontsPoppinsRegular,
                              fontSize: 14,
                              color: Theme.of(
                                context,
                              ).colorScheme.onSecondary.withValues(alpha: 0.6),
                            ),
                          ),
                        ],
                      ),
                    );
                  }

                  if (state.searchProductsStatus ==
                          SearchProductsStatus.success &&
                      state.searchModel != null) {
                    final stores = state.searchStores ?? [];
                    final products = state.searchProducts ?? [];

                    if (stores.isEmpty && products.isEmpty) {
                      return Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.search_off,
                              size: 80,
                              color: Theme.of(
                                context,
                              ).colorScheme.onSecondary.withValues(alpha: 0.3),
                            ),
                            const SizedBox(height: 20),
                            Text(
                              Labels.noResultsFound,
                              style: TextStyle(
                                fontFamily: FontFamily.fontsPoppinsSemiBold,
                                color:
                                    Theme.of(context).colorScheme.onSecondary,
                                fontSize: 18,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              Labels.trySearching,
                              style: TextStyle(
                                fontFamily: FontFamily.fontsPoppinsRegular,
                                color: Theme.of(context).colorScheme.onSecondary
                                    .withValues(alpha: 0.6),
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                      );
                    }

                    return SingleChildScrollView(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16.0,
                        vertical: 8.0,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Results Summary
                          const SizedBox(height: 20),

                          /// 🏪 STORES SECTION
                          if (stores.isNotEmpty) ...[
                            Row(
                              children: [
                                Container(
                                  width: 4,
                                  height: 20,
                                  decoration: BoxDecoration(
                                    color:
                                        Theme.of(context).colorScheme.primary,
                                    borderRadius: BorderRadius.circular(2),
                                  ),
                                ),
                                const SizedBox(width: 10),
                                Text(
                                  Labels.resultStores,
                                  style: TextStyle(
                                    fontFamily: FontFamily.fontsPoppinsSemiBold,
                                    fontSize: 18,
                                    color:
                                        Theme.of(
                                          context,
                                        ).colorScheme.onSecondary,
                                  ),
                                ),
                                const Spacer(),
                                Text(
                                  '${stores.length}',
                                  style: TextStyle(
                                    fontFamily: FontFamily.fontsPoppinsBold,
                                    fontSize: 16,
                                    color:
                                        Theme.of(context).colorScheme.primary,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 12),

                            // Always use horizontal scroll for stores
                            SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              child: Row(
                                children: List.generate(stores.length, (index) {
                                  final store = stores[index];
                                  return Padding(
                                    padding: EdgeInsets.only(
                                      right: index < stores.length - 1 ? 12 : 0,
                                    ),
                                    child: ShopBox(
                                      isRequireDirection: false,
                                      imageUrl: '$imageBaseUrl/${store.image}',
                                      isDelivering: store.isDelivery ?? false,
                                      isOpen: store.isOpen ?? false,
                                      shopName: store.name ?? '',
                                      onShopBoxTap: () {
                                        Navigator.pushNamed(
                                          context,
                                          RouteNames.shopNavBarScreen,
                                          arguments: store.id,
                                        );
                                      },
                                      shopDescription: store.description ?? '',
                                      onDirectionTap: () {},
                                      shopRating:
                                          double.tryParse(store.rating ?? '') ??
                                          0.0,
                                    ),
                                  );
                                }),
                              ),
                            ),
                            const SizedBox(height: 24),
                          ],

                          /// 🛒 PRODUCTS SECTION
                          if (products.isNotEmpty) ...[
                            Row(
                              children: [
                                Container(
                                  width: 4,
                                  height: 20,
                                  decoration: BoxDecoration(
                                    color:
                                        Theme.of(context).colorScheme.primary,
                                    borderRadius: BorderRadius.circular(2),
                                  ),
                                ),
                                const SizedBox(width: 10),
                                Text(
                                  Labels.resultProducts,
                                  style: TextStyle(
                                    fontFamily: FontFamily.fontsPoppinsSemiBold,
                                    fontSize: 18,
                                    color:
                                        Theme.of(
                                          context,
                                        ).colorScheme.onSecondary,
                                  ),
                                ),
                                const Spacer(),
                                Text(
                                  '${products.length}',
                                  style: TextStyle(
                                    fontFamily: FontFamily.fontsPoppinsBold,
                                    fontSize: 16,
                                    color:
                                        Theme.of(context).colorScheme.primary,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 12),

                            // Always use grid layout for products
                   LayoutBuilder(
                  builder: (context, constraints) {
                  double screenWidth = constraints.maxWidth;

                  // 🔹 Dynamically decide number of columns based on screen width
                  int crossAxisCount;
                  if (screenWidth >= 1200) {
                  crossAxisCount = 4; // Desktop / large tablet
                  } else if (screenWidth >= 700) {
                  crossAxisCount = 3; // Tablet (your 800px screen)
                  } else if (screenWidth >= 600) {
                  crossAxisCount = 2; // Large phones / foldables
                  } else {
                  crossAxisCount = 2; // Standard mobile
                  }

                  print('📱 Screen width: $screenWidth → Columns: $crossAxisCount');

                  return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10.0),
                  child: SingleChildScrollView(
                  child: StaggeredGrid.count(
                  crossAxisCount: crossAxisCount,
                  mainAxisSpacing: 12,
                  crossAxisSpacing: 12,
                  children: List.generate(products.length, (index) {
                  final product = products[index];
                  final productWidth = screenWidth / crossAxisCount - 20;

                  return StaggeredGridTile.fit(
                  crossAxisCellCount: 1,
                  child: ProductBox(
                  marginPadding: const Padding(padding: EdgeInsets.all(0)),
                  productWidth: productWidth,
                  productId: product.id.toString(),
                  onProductTap: () {
                  Navigator.pushNamed(
                  context,
                  RouteNames.productScreen,
                  arguments: product.id.toString(),
                  );
                  },
                  productCategory: product.category?.name ?? '',
                  productTitle: product.productName ?? '',
                  productPrice: double.tryParse(
                  product.productDiscountedPrice ?? '',
                  ) ??
                  0.0,
                  productImageUrl: '$imageBaseUrl/${product.productImage}',
                  productOriginalPrice: double.tryParse(
                  product.productPrice ?? '',
                  ) ??
                  0.0,
                  productRating: double.tryParse(
                  product.productRating ?? '',
                  ) ??
                  0.0,
                  ),
                  );
                  }),
                  ),
                  ),
                  );
                  },
                  ),
                  ],
                        ],
                      ),
                    );
                  }

                  /// 🔹 Default (initial) state
                  return const SizedBox.shrink();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
