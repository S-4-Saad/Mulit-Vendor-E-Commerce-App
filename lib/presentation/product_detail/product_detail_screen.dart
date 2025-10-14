import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:shimmer/shimmer.dart';
import 'package:speezu/core/utils/currency_icon.dart';
import 'package:speezu/core/utils/media_querry_extention.dart';
import 'package:speezu/core/utils/snackbar_helper.dart';
import 'package:speezu/presentation/favourites/bloc/favourite_bloc.dart';
import 'package:speezu/presentation/favourites/bloc/favourite_event.dart';
import 'package:speezu/presentation/product_detail/bloc/product_detail_bloc.dart';
import 'package:speezu/presentation/cart/bloc/cart_bloc.dart';
import 'package:speezu/presentation/cart/bloc/cart_event.dart';
import 'package:speezu/presentation/cart/bloc/cart_state.dart';
import 'package:speezu/core/services/localStorage/my-local-controller.dart';
import 'package:speezu/core/utils/constants.dart';
import 'package:speezu/repositories/user_repository.dart';
import 'package:speezu/routes/route_names.dart';
import 'package:speezu/widgets/login_required_bottom%20sheet.dart';
import '../../core/assets/font_family.dart';
import '../../core/utils/labels.dart';
import '../../models/product_detail_model.dart';
import '../../widgets/image_gallery_viewer_widget.dart';
import '../../widgets/image_type_extention.dart';
import '../../widgets/option_selector_widget.dart';
import '../../widgets/product_box_widget.dart';
import '../../widgets/shop_product_box.dart';
import 'bloc/product_detail_event.dart';
import 'bloc/product_detail_state.dart';

class ProductDetailScreen extends StatefulWidget {
  final String productId;

  const ProductDetailScreen({super.key, required this.productId});

  @override
  State<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  String? selectedParent;
  // e.g. "Fajita"
  String? selectedChild;
  final ScrollController _scrollController = ScrollController();
  StreamSubscription<CartState>? _cartSubscription;

  // e.g. "Medium"
  @override
  void initState() {
    super.initState();
    // Load product detail (quantity will be reset in BLoC)
    context.read<ProductDetailBloc>().add(
      LoadProductDetail(productId: widget.productId),
    );

    _scrollController.addListener(() {
      if (_scrollController.position.userScrollDirection ==
          ScrollDirection.reverse) {
        context.read<ProductDetailBloc>().add(HideBottomBar());
      } else if (_scrollController.position.userScrollDirection ==
          ScrollDirection.forward) {
        context.read<ProductDetailBloc>().add(ShowBottomBar());
      }
    });
  }

  @override
  void dispose() {
    _cartSubscription?.cancel();
    _scrollController.dispose();
    super.dispose();
  }

  // Calculate the current price based on selected variations
  double getCurrentPrice(ProductDetail product) {
    // If no variations, return base price
    if (product.variations.isEmpty) {
      return product.price;
    }

    // If no parent selected, return base price
    if (selectedParent == null) {
      return product.price;
    }

    // Find the selected parent variation
    final selectedParentVariation = product.variations.firstWhere(
      (v) => v.parentName == selectedParent,
      orElse: () => product.variations.first,
    );

    // If parent has children and child is selected, use child price
    if (selectedParentVariation.children.isNotEmpty && selectedChild != null) {
      final selectedChildVariation = selectedParentVariation.children
          .firstWhere(
            (child) => child.name == selectedChild,
            orElse: () => selectedParentVariation.children.first,
          );
      return selectedChildVariation.price;
    }

    // If parent has no children or child not selected, use parent price
    return selectedParentVariation.parentPrice;
  }

  // Calculate the current original price based on selected variations
  double getCurrentOriginalPrice(ProductDetail product) {
    // If no variations, return base original price
    if (product.variations.isEmpty) {
      return product.originalPrice;
    }

    // If no parent selected, return base original price
    if (selectedParent == null) {
      return product.originalPrice;
    }

    // Find the selected parent variation
    final selectedParentVariation = product.variations.firstWhere(
      (v) => v.parentName == selectedParent,
      orElse: () => product.variations.first,
    );

    // If parent has children and child is selected, use child original price
    if (selectedParentVariation.children.isNotEmpty && selectedChild != null) {
      final selectedChildVariation = selectedParentVariation.children
          .firstWhere(
            (child) => child.name == selectedChild,
            orElse: () => selectedParentVariation.children.first,
          );
      return selectedChildVariation.originalPrice;
    }

    // If parent has no children or child not selected, use parent original price
    return selectedParentVariation.parentOriginalPrice;
  }

  // Calculate the current discount percentage based on selected variations
  double getCurrentDiscountPercentage(ProductDetail product) {
    // If no variations, return base discount percentage
    if (product.variations.isEmpty) {
      return product.productDiscountPercentage;
    }

    // If no parent selected, return base discount percentage
    if (selectedParent == null) {
      return product.productDiscountPercentage;
    }

    // Find the selected parent variation
    final selectedParentVariation = product.variations.firstWhere(
      (v) => v.parentName == selectedParent,
      orElse: () => product.variations.first,
    );

    // If parent has children and child is selected, use child discount percentage
    if (selectedParentVariation.children.isNotEmpty && selectedChild != null) {
      final selectedChildVariation = selectedParentVariation.children
          .firstWhere(
            (child) => child.name == selectedChild,
            orElse: () => selectedParentVariation.children.first,
          );
      return selectedChildVariation.discountPercentage;
    }

    // If parent has no children or child not selected, use parent discount percentage
    return selectedParentVariation.parentDiscountPercentage;
  }

  // Calculate total price based on quantity from BLoC state
  double calculateTotalPrice(ProductDetail product, int quantity) {
    return getCurrentPrice(product) * quantity;
  }

  // Check if user is authenticated
  Future<bool> _isUserAuthenticated() async {
    final token = await LocalStorage.getData(key: AppKeys.authToken);
    return token != null && token.isNotEmpty;
  }

  // Show login required dialog
  // void _showLoginRequiredDialog(BuildContext context) {
  //   showDialog(
  //     context: context,
  //     builder: (BuildContext context) {
  //       return AlertDialog(
  //         title: Text(
  //           'Login Required',
  //           style: TextStyle(
  //             fontFamily: FontFamily.fontsPoppinsSemiBold,
  //             fontSize: 18,
  //           ),
  //         ),
  //         content: Text(
  //           'You need to be logged in to add items to your cart. Please login to continue.',
  //           style: TextStyle(
  //             fontFamily: FontFamily.fontsPoppinsRegular,
  //             fontSize: 14,
  //           ),
  //         ),
  //         actions: [
  //           TextButton(
  //             onPressed: () {
  //               Navigator.of(context).pop();
  //             },
  //             child: Text(
  //               'Cancel',
  //               style: TextStyle(
  //                 fontFamily: FontFamily.fontsPoppinsRegular,
  //                 color: Theme.of(context).colorScheme.onSecondary,
  //               ),
  //             ),
  //           ),
  //           TextButton(
  //             onPressed: () {
  //               Navigator.of(context).pop();
  //               // Navigate to login screen
  //               Navigator.pushNamed(context, RouteNames.login);
  //             },
  //             child: Text(
  //               'Login',
  //               style: TextStyle(
  //                 fontFamily: FontFamily.fontsPoppinsSemiBold,
  //                 color: Theme.of(context).colorScheme.primary,
  //               ),
  //             ),
  //           ),
  //         ],
  //       );
  //     },
  //   );
  // }

  // Validate if required variations are selected
  bool _areVariationsValid(ProductDetail product) {
    // If no variations, always valid
    if (product.variations.isEmpty) {
      return true;
    }

    // If variations exist, check if parent is selected
    if (selectedParent == null) {
      return false;
    }

    // Find the selected parent variation
    final selectedParentVariation = product.variations.firstWhere(
      (v) => v.parentName == selectedParent,
      orElse: () => product.variations.first,
    );

    // If parent variation has children, child must be selected
    if (selectedParentVariation.children.isNotEmpty && selectedChild == null) {
      return false;
    }

    return true;
  }

  // Get the missing variation message
  String _getMissingVariationMessage(ProductDetail product) {
    if (product.variations.isEmpty) {
      return '';
    }

    if (selectedParent == null) {
      final parentName = product.variations.first.parentOptionName;
      return '${Labels.pleaseSelectA} $parentName';
    }

    final selectedParentVariation = product.variations.firstWhere(
      (v) => v.parentName == selectedParent,
      orElse: () => product.variations.first,
    );

    if (selectedParentVariation.children.isNotEmpty && selectedChild == null) {
      final childName = selectedParentVariation.children.first.childOptionName;
      return '${Labels.pleaseSelectA} $childName';
    }

    return '';
  }

  void _handleAddToCart(
    BuildContext context,
    ProductDetail product,
    int quantity,
  ) async {
    // Check if user is authenticated
    final isAuthenticated = await _isUserAuthenticated();
    if (!isAuthenticated) {
      LoginRequiredBottomSheet.show(context);
      return;
    }

    // Check if variations are required and selected
    if (!_areVariationsValid(product)) {
      _showVariationRequiredSnackBar(context, product);
      return;
    }

    // Set up stream listener for store conflicts BEFORE adding to cart
    _cartSubscription?.cancel(); // Cancel any existing subscription
    _cartSubscription = context.read<CartBloc>().stream.listen((cartState) {
      print(
        'Cart state changed: ${cartState.status}, error: ${cartState.errorMessage}',
      );
      if (mounted &&
          cartState.status == CartStatus.error &&
          cartState.errorMessage != null &&
          cartState.errorMessage!.startsWith('STORE_CONFLICT:')) {
        print('Showing store conflict dialog for product: ${product.name}');
        _showStoreConflictDialog(context, cartState.errorMessage!, product);
      }
    });

    // Handle products with no variations
    if (product.variations.isEmpty) {
      context.read<CartBloc>().add(
        AddToCart(
          product: product,
          quantity: quantity,
          variationParentName: null,
          variationParentValue: null,
          variationChildName: null,
          variationChildValue: null,
          variationParentId: null,
          variationChildId: null,
        ),
      );
      return;
    }

    // Find the selected parent variation
    final selectedParentVariation = product.variations.firstWhere(
      (v) => v.parentName == selectedParent,
      orElse: () => product.variations.first,
    );

    // Find the selected child variation if child is selected and parent has children
    ProductSubVariation? selectedChildVariation;
    if (selectedChild != null && selectedParentVariation.children.isNotEmpty) {
      selectedChildVariation = selectedParentVariation.children.firstWhere(
        (child) => child.name == selectedChild,
        orElse: () => selectedParentVariation.children.first,
      );
    }

    // Add product to cart with selected variations
    context.read<CartBloc>().add(
      AddToCart(
        product: product,
        quantity: quantity,
        variationParentName: selectedParent,
        variationParentValue: selectedParent,
        variationChildName: selectedChild,
        variationChildValue: selectedChild,
        variationParentId: selectedParentVariation.id,
        variationChildId: selectedChildVariation?.id,
      ),
    );
  }

  void _showStoreConflictDialog(
    BuildContext context,
    String errorMessage,
    ProductDetail product,
  ) {
    // Check if the widget is still mounted before showing dialog
    if (!mounted) return;

    final parts = errorMessage.split(':');
    final newStoreId = parts.length > 1 ? parts[1] : product.shopName;
    final currentStoreId = parts.length > 2 ? parts[2] : 'Unknown Store';
    final currentQuantity = context.read<ProductDetailBloc>().state.quantity;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            'Store Conflict',
            style: TextStyle(
              fontFamily: FontFamily.fontsPoppinsSemiBold,
              fontSize: 18,
            ),
          ),
          content: Text(
            'You have items from "$currentStoreId" in your cart. '
            'To add items from "$newStoreId", you need to either:\n\n'
            '• Checkout current items first, or\n'
            '• Clear your cart to add items from the new store',
            style: TextStyle(
              fontFamily: FontFamily.fontsPoppinsRegular,
              fontSize: 14,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text(
                'Cancel',
                style: TextStyle(
                  fontFamily: FontFamily.fontsPoppinsRegular,
                  color: Theme.of(context).colorScheme.onSecondary,
                ),
              ),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                // Navigate to cart
                Navigator.pushNamed(context, RouteNames.cartScreen);
              },
              child: Text(
                'Checkout',
                style: TextStyle(
                  fontFamily: FontFamily.fontsPoppinsSemiBold,
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                // Clear cart and add new item
                context.read<CartBloc>().add(
                  ClearCartForNewStore(newStoreId: newStoreId),
                );

                // Add the new item after clearing
                Future.delayed(Duration(milliseconds: 100), () {
                  // Check if widget is still mounted before proceeding
                  if (!mounted) return;

                  // Handle products with no variations
                  if (product.variations.isEmpty) {
                    context.read<CartBloc>().add(
                      AddToCart(
                        product: product,
                        quantity: currentQuantity,
                        variationParentName: null,
                        variationParentValue: null,
                        variationChildName: null,
                        variationChildValue: null,
                        variationParentId: null,
                        variationChildId: null,
                      ),
                    );
                    return;
                  }

                  // Find the selected parent variation
                  final selectedParentVariation = product.variations.firstWhere(
                    (v) => v.parentName == selectedParent,
                    orElse: () => product.variations.first,
                  );

                  // Find the selected child variation if child is selected and parent has children
                  ProductSubVariation? selectedChildVariation;
                  if (selectedChild != null &&
                      selectedParentVariation.children.isNotEmpty) {
                    selectedChildVariation = selectedParentVariation.children
                        .firstWhere(
                          (child) => child.name == selectedChild,
                          orElse: () => selectedParentVariation.children.first,
                        );
                  }

                  context.read<CartBloc>().add(
                    AddToCart(
                      product: product,
                      quantity: currentQuantity,
                      variationParentName: selectedParent,
                      variationParentValue: selectedParent,
                      variationChildName: selectedChild,
                      variationChildValue: selectedChild,
                      variationParentId: selectedParentVariation.id,
                      variationChildId: selectedChildVariation?.id,
                    ),
                  );
                });
              },
              child: Text(
                'Clear & Add',
                style: TextStyle(
                  fontFamily: FontFamily.fontsPoppinsSemiBold,
                  color: Colors.red,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  void _showVariationRequiredSnackBar(
    BuildContext context,
    ProductDetail product,
  ) {
    final missingMessage = _getMissingVariationMessage(product);

    SnackBarHelper.showError(context, missingMessage);

    // showDialog(
    //   context: context,
    //   builder: (BuildContext context) {
    //     return AlertDialog(
    //       title: Text(
    //         'Selection Required',
    //         style: TextStyle(
    //           fontFamily: FontFamily.fontsPoppinsSemiBold,
    //           fontSize: 18,
    //         ),
    //       ),
    //       content: Text(
    //         missingMessage.isEmpty
    //             ? 'Please select your preferences before adding to cart.'
    //             : missingMessage,
    //         style: TextStyle(
    //           fontFamily: FontFamily.fontsPoppinsRegular,
    //           fontSize: 14,
    //         ),
    //       ),
    //       actions: [
    //         TextButton(
    //           onPressed: () {
    //             Navigator.of(context).pop();
    //           },
    //           child: Text(
    //             'OK',
    //             style: TextStyle(
    //               fontFamily: FontFamily.fontsPoppinsSemiBold,
    //               color: Theme.of(context).colorScheme.primary,
    //             ),
    //           ),
    //         ),
    //       ],
    //     );
    //   },
    // );
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProductDetailBloc, ProductDetailState>(
      builder: (context, state) {
        if (state.status == ProductDetailStatus.loading) {
          return const ProductDetailShimmer();
        }

        if (state.status == ProductDetailStatus.error ||
            state.productDetail == null) {
          return Scaffold(
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.error, size: 64, color: Colors.red),
                  SizedBox(height: 16),
                  Text(
                    state.errorMessage ?? 'Failed to load product details',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 16),
                  ),
                  SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      context.read<ProductDetailBloc>().add(
                        LoadProductDetail(productId: widget.productId),
                      );
                    },
                    child: Text('Retry'),
                  ),
                ],
              ),
            ),
          );
        }

        final product = state.productDetail!;

        // Handle different variation scenarios
        final hasVariations = product.variations.isNotEmpty;
        final parentNames =
            hasVariations
                ? product.variations.map((e) => e.parentName).toList()
                : [];

        ProductVariation selectedParentVariation = ProductVariation(
          id: '',
          parentName: '',
          parentOptionName: '',
          parentPrice: 0,
          parentOriginalPrice: 0,
          parentDiscountPercentage: 0,
          children: [],
        );

        if (hasVariations) {
          selectedParentVariation = product.variations.firstWhere(
            (v) => v.parentName == selectedParent,
            orElse: () => product.variations.first,
          );
        }

        final childOptions =
            selectedParent == null ? [] : selectedParentVariation.children;
        final hasChildVariations = childOptions.isNotEmpty;

        return Scaffold(
          body: Stack(
            children: [
              CustomScrollView(
                controller: _scrollController,
                slivers: [
                  SliverAppBar(
                    backgroundColor: Theme.of(
                      context,
                    ).colorScheme.primary.withValues(alpha: 0.9),
                    expandedHeight: 300,
                    elevation: 0,
                    automaticallyImplyLeading: false,
                    leading: IconButton(
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all(
                          Theme.of(
                            context,
                          ).colorScheme.primary.withValues(alpha: 0.5),
                        ),
                      ),
                      icon: Icon(
                        Icons.arrow_back,
                        color: Theme.of(context).colorScheme.onPrimary,
                      ),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    ),
                    flexibleSpace: FlexibleSpaceBar(
                      collapseMode: CollapseMode.parallax,
                      background: CustomImageView(
                        fit: BoxFit.cover,
                        imagePath: product.thumbnail,
                      ),
                    ),
                  ),
                  SliverToBoxAdapter(
                    child: Wrap(
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Name + Rating
                              SizedBox(height: context.heightPct(.01)),
                              Text(
                                product.shopName,
                                style: TextStyle(
                                  fontFamily: FontFamily.fontsPoppinsRegular,
                                  color:
                                      Theme.of(context).colorScheme.onSecondary,
                                  fontSize: 13,
                                ),
                              ),
                              SizedBox(height: context.heightPct(.01)),
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Expanded(
                                    child: Text(
                                      product.name,
                                      style: TextStyle(
                                        fontFamily:
                                            FontFamily.fontsPoppinsSemiBold,
                                        color:
                                            Theme.of(
                                              context,
                                            ).colorScheme.onSecondary,
                                        fontSize: context.scaledFont(18),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 10),
                                  if (getCurrentDiscountPercentage(product) > 0)
                                    Container(
                                      padding: EdgeInsets.symmetric(
                                        horizontal: 10,
                                        vertical: 2,
                                      ),
                                      decoration: BoxDecoration(
                                        color: Colors.red,
                                        borderRadius: BorderRadius.only(
                                          topLeft: Radius.circular(10),
                                          bottomRight: Radius.circular(10),
                                        ),
                                      ),
                                      child: Text(
                                        '${getCurrentDiscountPercentage(product).toStringAsFixed(0)}% off',
                                        style: TextStyle(
                                          fontFamily:
                                              FontFamily.fontsPoppinsSemiBold,
                                          fontSize: 13,
                                          color: Colors.white.withValues(
                                            alpha: 0.8,
                                          ),
                                        ),
                                      ),
                                    ),
                                ],
                              ),
                              SizedBox(height: context.heightPct(.01)),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    children: [
                                      Text(
                                        "${CurrencyIcon.currencyIcon}${getCurrentPrice(product).toStringAsFixed(2)}",
                                        style: TextStyle(
                                          fontFamily:
                                              FontFamily.fontsPoppinsSemiBold,
                                          color:
                                              Theme.of(
                                                context,
                                              ).colorScheme.primary,
                                          fontSize: 22,
                                        ),
                                      ),
                                      SizedBox(width: context.widthPct(.02)),
                                      if (getCurrentOriginalPrice(product) !=
                                          getCurrentPrice(product))
                                        Text(
                                          "${CurrencyIcon.currencyIcon}${getCurrentOriginalPrice(product).toStringAsFixed(2)}",
                                          style: TextStyle(
                                            fontFamily:
                                                FontFamily.fontsPoppinsLight,
                                            decoration:
                                                TextDecoration.lineThrough,
                                            color:
                                                Theme.of(
                                                  context,
                                                ).colorScheme.onSecondary,
                                            fontSize: context.scaledFont(12),
                                          ),
                                        ),
                                    ],
                                  ),
                                ],
                              ),
                              SizedBox(height: context.heightPct(.02)),

                              // Show parent variation selector only if variations exist
                              if (hasVariations) ...[
                                // Parent variation selector with required indicator
                                Row(
                                  children: [
                                    Expanded(
                                      child: OptionSelectorWidget(
                                        name:
                                            product
                                                .variations
                                                .first
                                                .parentOptionName,
                                        options: parentNames,
                                        selectedOption: selectedParent,
                                        onSelect: (value) {
                                          setState(() {
                                            selectedParent = value;
                                            selectedChild =
                                                null; // reset child when parent changes
                                          });
                                        },
                                      ),
                                    ),
                                    if (selectedParent == null) ...[
                                      SizedBox(width: 8),
                                      Container(
                                        padding: EdgeInsets.symmetric(
                                          horizontal: 8,
                                          vertical: 4,
                                        ),
                                        decoration: BoxDecoration(
                                          color: Colors.red.withValues(
                                            alpha: 0.1,
                                          ),
                                          borderRadius: BorderRadius.circular(
                                            12,
                                          ),
                                          border: Border.all(
                                            color: Colors.red.withValues(
                                              alpha: 0.3,
                                            ),
                                          ),
                                        ),
                                        child: Text(
                                          'Required',
                                          style: TextStyle(
                                            color: Colors.red,
                                            fontSize: 10,
                                            fontFamily:
                                                FontFamily.fontsPoppinsSemiBold,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ],
                                ),
                                SizedBox(height: context.heightPct(.01)),

                                // Show child variation selector only if parent is selected and has children
                                if (selectedParent != null &&
                                    hasChildVariations) ...[
                                  Row(
                                    children: [
                                      Expanded(
                                        child: OptionSelectorWidget(
                                          name:
                                              selectedParentVariation
                                                  .children
                                                  .first
                                                  .childOptionName,
                                          options:
                                              childOptions
                                                  .map((e) => e.name)
                                                  .toList(),
                                          selectedOption: selectedChild,
                                          onSelect: (value) {
                                            setState(() {
                                              selectedChild = value;
                                            });
                                          },
                                        ),
                                      ),
                                      if (selectedChild == null) ...[
                                        SizedBox(width: 8),
                                        Container(
                                          padding: EdgeInsets.symmetric(
                                            horizontal: 8,
                                            vertical: 4,
                                          ),
                                          decoration: BoxDecoration(
                                            color: Colors.red.withValues(
                                              alpha: 0.1,
                                            ),
                                            borderRadius: BorderRadius.circular(
                                              12,
                                            ),
                                            border: Border.all(
                                              color: Colors.red.withValues(
                                                alpha: 0.3,
                                              ),
                                            ),
                                          ),
                                          child: Text(
                                            'Required',
                                            style: TextStyle(
                                              color: Colors.red,
                                              fontSize: 10,
                                              fontFamily:
                                                  FontFamily
                                                      .fontsPoppinsSemiBold,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ],
                                  ),
                                ],
                              ],

                              SizedBox(height: 10),

                              SizedBox(
                                height: 200,
                                child: ListView.separated(
                                  scrollDirection: Axis.horizontal,
                                  padding: const EdgeInsets.all(12),
                                  itemCount: product.images.length,
                                  separatorBuilder:
                                      (_, __) => const SizedBox(width: 10),
                                  itemBuilder: (context, index) {
                                    return CustomImageView(
                                      onTap: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder:
                                                (context) => ImageGalleryViewer(
                                                  imageUrls: product.images,
                                                  initialIndex: index,
                                                ),
                                          ),
                                        );
                                        print(index);
                                      },
                                      radius: BorderRadius.circular(10),

                                      imagePath: product.images[index],
                                      width: context.widthPct(.55),
                                      fit: BoxFit.cover,
                                    );
                                  },
                                ),
                              ),
                              SizedBox(height: 10),
                              Container(
                                // padding: EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                  color:
                                      Theme.of(context).colorScheme.onPrimary,
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(
                                    color: Theme.of(
                                      context,
                                    ).colorScheme.outline.withValues(alpha: .3),
                                  ),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.grey.withValues(alpha: 0.1),
                                      spreadRadius: 1,
                                      blurRadius: 4,
                                      offset: const Offset(0, 2),
                                    ),
                                  ],
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    SizedBox(height: 10),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 10.0,
                                      ),
                                      child: Text(
                                        Labels.description,
                                        style: TextStyle(
                                          fontFamily:
                                              FontFamily.fontsPoppinsSemiBold,
                                          color:
                                              Theme.of(
                                                context,
                                              ).colorScheme.onSecondary,
                                          fontSize: 14,
                                        ),
                                      ),
                                    ),
                                    Divider(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .outline
                                          .withValues(alpha: .3),
                                    ),

                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 10.0,
                                      ),
                                      child: Text(
                                        product.description,
                                        style: TextStyle(
                                          fontFamily:
                                              FontFamily.fontsPoppinsLight,

                                          color:
                                              Theme.of(
                                                context,
                                              ).colorScheme.onSecondary,
                                          fontSize: context.scaledFont(12),
                                        ),
                                      ),
                                    ),
                                    SizedBox(height: 10),
                                  ],
                                ),
                              ),
                              SizedBox(height: 10),
                              ShopProductBox(
                                categoryName: product.shop.categoryName,
                                shopImageUrl: product.shop.imageUrl,
                                rating: product.shop.rating * 20,
                                shopName: product.shop.name,
                                onViewStoreTap: () {
                                  Navigator.pushNamed(
                                    context,
                                    RouteNames.shopNavBarScreen,
                                    arguments: product.shop.id,
                                  );
                                  // Navigate to shop page
                                },
                              ),

                              SizedBox(height: 15),

                              Text(
                                Labels.youMightAlsoLike,
                                style: TextStyle(
                                  fontFamily: FontFamily.fontsPoppinsSemiBold,
                                  color:
                                      Theme.of(context).colorScheme.onSecondary,
                                  fontSize: 14,
                                ),
                              ),
                              SizedBox(height: 15),
                              StaggeredGrid.count(
                                crossAxisCount: 2, // Defines 2 columns
                                mainAxisSpacing: 10,
                                crossAxisSpacing: 10,
                                children: List.generate(
                                  product.relatedProducts.length,
                                  (index) {
                                    var relatedProduct =
                                        product.relatedProducts[index];
                                    return StaggeredGridTile.fit(
                                      crossAxisCellCount:
                                          1, // Each item takes 1 column space
                                      child: ProductBox(
                                        marginPadding: const Padding(
                                          padding: EdgeInsets.all(0),
                                        ),
                                        productWidth: 200,
                                        productPrice: relatedProduct.price,
                                        productOriginalPrice:
                                            relatedProduct.originalPrice,
                                        productCategory:
                                            relatedProduct.categoryName,
                                        productRating:
                                            4.0, // Default rating since not provided in API
                                        productId: relatedProduct.id,
                                        // isProductFavourite:
                                        //     relatedProduct.isProductFavourite, // Default since not provided in API
                                        // onFavouriteTap: () {},
                                        onProductTap: () {
                                          Navigator.pushReplacementNamed(
                                            context,
                                            RouteNames.productScreen,
                                            arguments: relatedProduct.id,
                                          );
                                        },
                                        productImageUrl:
                                            relatedProduct.imageUrl,
                                        productTitle: relatedProduct.name,
                                      ),
                                    );
                                  },
                                ),
                              ),
                              SizedBox(height: 15),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              BlocBuilder<ProductDetailBloc, ProductDetailState>(
                builder:
                    (context, state) => SafeArea(
                      child: Align(
                        alignment: Alignment.bottomCenter,
                        child: AnimatedSlide(
                          duration: const Duration(milliseconds: 400),
                          curve: Curves.easeInOut,
                          offset:
                              state.isBottomSheetVisible
                                  ? Offset(0, 0)
                                  : Offset(0, 1),
                          child: AnimatedOpacity(
                            duration: const Duration(milliseconds: 300),
                            opacity: state.isBottomSheetVisible ? 1 : 0,
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 15.0,
                                vertical: 8.0,
                              ),
                              decoration: BoxDecoration(
                                color: Theme.of(context).colorScheme.onPrimary,
                                borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(30),
                                  topRight: Radius.circular(30),
                                ),
                                border: Border.all(
                                  color: Theme.of(
                                    context,
                                  ).colorScheme.primary.withValues(alpha: .3),
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withValues(alpha: 0.1),
                                    spreadRadius: 1,
                                    blurRadius: 4,
                                    offset: const Offset(2, 0),
                                  ),
                                ],
                              ),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        Labels.quantity,
                                        style: TextStyle(
                                          fontFamily:
                                              FontFamily.fontsPoppinsSemiBold,
                                          color:
                                              Theme.of(
                                                context,
                                              ).colorScheme.onSecondary,
                                          fontSize: 16,
                                        ),
                                      ),
                                      Row(
                                        children: [
                                          IconButton(
                                            onPressed: () {
                                              context
                                                  .read<ProductDetailBloc>()
                                                  .add(DecrementQuantity());
                                            },
                                            icon: Icon(
                                              Icons.remove_circle_outline,
                                              color:
                                                  Theme.of(
                                                    context,
                                                  ).colorScheme.primary,
                                            ),
                                          ),
                                          SizedBox(width: 10),
                                          Text(
                                            "${state.quantity}",
                                            style: TextStyle(
                                              fontFamily:
                                                  FontFamily
                                                      .fontsPoppinsSemiBold,
                                              color:
                                                  Theme.of(
                                                    context,
                                                  ).colorScheme.onSecondary,
                                              fontSize: 16,
                                            ),
                                          ),
                                          SizedBox(width: 10),
                                          IconButton(
                                            onPressed: () {
                                              context
                                                  .read<ProductDetailBloc>()
                                                  .add(IncrementQuantity());
                                            },
                                            icon: Icon(
                                              Icons.add_circle_outline,
                                              color:
                                                  Theme.of(
                                                    context,
                                                  ).colorScheme.primary,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: 10),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      IconButton(
                                        style: ButtonStyle(
                                          backgroundColor:
                                              MaterialStateProperty.all(
                                                state.productDetail!.isFavourite
                                                    ? Theme.of(
                                                      context,
                                                    ).colorScheme.primary
                                                    : Theme.of(context)
                                                        .colorScheme
                                                        .onSecondary
                                                        .withValues(alpha: .3),
                                              ),
                                          minimumSize:
                                              MaterialStateProperty.all(
                                                Size(60, 50),
                                              ),
                                          shape: MaterialStateProperty.all(
                                            RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(50),
                                            ),
                                          ),
                                        ),
                                        onPressed: () async {
                                          final isLoggedIn=await UserRepository().isUserAuthenticated();

                                          if (!isLoggedIn) {
                                            // 🔸 If not logged in, show login sheet and stop here
                                            await LoginRequiredBottomSheet.show(
                                              context,
                                            );

                                            return;
                                          }
                                          final productDetailBloc =
                                              context.read<ProductDetailBloc>();
                                          final favouriteBloc =
                                              context.read<FavouriteBloc>();

                                          final currentFav =
                                              state.productDetail!.isFavourite;
                                          final productId =
                                              state.productDetail!.id ?? '';

                                          // 1️⃣ Update UI instantly
                                          productDetailBloc.add(
                                            UpdateFavouriteStatusEvent(
                                              productId: productId,
                                              isFavourite: !currentFav,
                                            ),
                                          );

                                          // 2️⃣ Call API quietly
                                          favouriteBloc.add(
                                            ToggleFavouriteEvent(
                                              productId: productId,
                                            ),
                                          );
                                        },
                                        icon: Icon(
                                          Icons.favorite,
                                          color: Colors.white,
                                        ),
                                      ),

                                      SizedBox(width: 10),
                                      Expanded(
                                        child: ElevatedButton(
                                          style: ButtonStyle(
                                            backgroundColor:
                                                MaterialStateProperty.all(
                                                  _areVariationsValid(product)
                                                      ? Theme.of(
                                                        context,
                                                      ).colorScheme.primary
                                                      : Colors.grey.withValues(
                                                        alpha: 0.6,
                                                      ),
                                                ),
                                            minimumSize:
                                                MaterialStateProperty.all(
                                                  Size(250, 50),
                                                ),
                                            shape: MaterialStateProperty.all(
                                              RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(50),
                                              ),
                                            ),
                                          ),
                                          onPressed:
                                              _areVariationsValid(product)
                                                  ? () {
                                                    _handleAddToCart(
                                                      context,
                                                      product,
                                                      state.quantity,
                                                    );
                                                  }
                                                  : () {
                                                _showVariationRequiredSnackBar(
                                                      context,
                                                      product,
                                                    );
                                                  },
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text(
                                                Labels.addToCart,
                                                style: TextStyle(
                                                  fontFamily:
                                                      FontFamily
                                                          .fontsPoppinsSemiBold,
                                                  color: Colors.white,
                                                  fontSize: 15,
                                                ),
                                              ),
                                              Text(
                                                '${calculateTotalPrice(product, state.quantity).toStringAsFixed(2)}\$',
                                                style: TextStyle(
                                                  fontFamily:
                                                      FontFamily
                                                          .fontsPoppinsSemiBold,
                                                  color: Colors.white,
                                                  fontSize: 16,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
              ),
              Positioned(
                top: 50,
                right: 20,
                child: BlocBuilder<CartBloc, CartState>(
                  builder: (context, cartState) {
                    final cartCount = cartState.totalItems;
                    return Stack(
                      children: [
                        FloatingActionButton(
                          backgroundColor:
                              Theme.of(context).colorScheme.primary,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(100),
                          ),
                          onPressed: ()async {
                            final isLoggedIn=await UserRepository().isUserAuthenticated();
                            if(!isLoggedIn){
                              await LoginRequiredBottomSheet.show(context);
                              return;
                            }
                            Navigator.pushNamed(context, RouteNames.cartScreen);
                          },
                          child: Icon(
                            Icons.shopping_cart_rounded,
                            color: Colors.white,
                            size: 25,
                          ),
                        ),
                        if (cartCount > 0)
                          Positioned(
                            right: 0,
                            top: 0,
                            child: Container(
                              padding: const EdgeInsets.all(2),
                              decoration: BoxDecoration(
                                color: Colors.red,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              constraints: const BoxConstraints(
                                minWidth: 20,
                                minHeight: 20,
                              ),
                              child: Text(
                                cartCount.toString(),
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ),
                      ],
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class ProductDetailShimmer extends StatelessWidget {
  const ProductDetailShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          CustomScrollView(
            slivers: [
              // Shimmer for app bar with image
              SliverAppBar(
                expandedHeight: 300,
                pinned: true,
                flexibleSpace: FlexibleSpaceBar(
                  background: Shimmer.fromColors(
                    baseColor: Colors.grey[300]!,
                    highlightColor: Colors.grey[100]!,
                    child: Container(
                      width: double.infinity,
                      height: 300,
                      color: Colors.white,
                    ),
                  ),
                ),
                leading: Container(
                  margin: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    shape: BoxShape.circle,
                  ),
                ),
                actions: [
                  Container(
                    margin: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      shape: BoxShape.circle,
                    ),
                    width: 40,
                    height: 40,
                  ),
                ],
              ),
              // Shimmer for content
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Shop name shimmer
                      Shimmer.fromColors(
                        baseColor: Colors.grey[300]!,
                        highlightColor: Colors.grey[100]!,
                        child: Container(
                          width: 150,
                          height: 20,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(4),
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      // Product name shimmer
                      Shimmer.fromColors(
                        baseColor: Colors.grey[300]!,
                        highlightColor: Colors.grey[100]!,
                        child: Container(
                          width: double.infinity,
                          height: 24,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(4),
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),
                      // Price shimmer
                      Shimmer.fromColors(
                        baseColor: Colors.grey[300]!,
                        highlightColor: Colors.grey[100]!,
                        child: Container(
                          width: 100,
                          height: 20,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(4),
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      // Options shimmer
                      Shimmer.fromColors(
                        baseColor: Colors.grey[300]!,
                        highlightColor: Colors.grey[100]!,
                        child: Container(
                          width: 80,
                          height: 20,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(4),
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),
                      Row(
                        children: List.generate(
                          3,
                          (index) => Container(
                            margin: const EdgeInsets.only(right: 10),
                            child: Shimmer.fromColors(
                              baseColor: Colors.grey[300]!,
                              highlightColor: Colors.grey[100]!,
                              child: Container(
                                width: 60,
                                height: 30,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(15),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      // Images shimmer
                      Shimmer.fromColors(
                        baseColor: Colors.grey[300]!,
                        highlightColor: Colors.grey[100]!,
                        child: Container(
                          width: double.infinity,
                          height: 120,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      // Description shimmer
                      Shimmer.fromColors(
                        baseColor: Colors.grey[300]!,
                        highlightColor: Colors.grey[100]!,
                        child: Container(
                          width: double.infinity,
                          height: 80,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      // Shop info shimmer
                      Shimmer.fromColors(
                        baseColor: Colors.grey[300]!,
                        highlightColor: Colors.grey[100]!,
                        child: Container(
                          width: double.infinity,
                          height: 80,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      // Related products title shimmer
                      Shimmer.fromColors(
                        baseColor: Colors.grey[300]!,
                        highlightColor: Colors.grey[100]!,
                        child: Container(
                          width: 200,
                          height: 20,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(4),
                          ),
                        ),
                      ),
                      const SizedBox(height: 15),
                      // Related products grid shimmer
                      StaggeredGrid.count(
                        crossAxisCount: 2,
                        mainAxisSpacing: 10,
                        crossAxisSpacing: 10,
                        children: List.generate(
                          4,
                          (index) => StaggeredGridTile.fit(
                            crossAxisCellCount: 1,
                            child: Shimmer.fromColors(
                              baseColor: Colors.grey[300]!,
                              highlightColor: Colors.grey[100]!,
                              child: Container(
                                height: 200,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 100,
                      ), // Space for bottom navigation
                    ],
                  ),
                ),
              ),
            ],
          ),
          // Bottom navigation shimmer
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withValues(alpha: 0.3),
                    spreadRadius: 1,
                    blurRadius: 5,
                    offset: const Offset(0, -2),
                  ),
                ],
              ),
              child: SafeArea(
                child: Row(
                  children: [
                    Expanded(
                      child: Shimmer.fromColors(
                        baseColor: Colors.grey[300]!,
                        highlightColor: Colors.grey[100]!,
                        child: Container(
                          height: 50,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Shimmer.fromColors(
                      baseColor: Colors.grey[300]!,
                      highlightColor: Colors.grey[100]!,
                      child: Container(
                        width: 50,
                        height: 50,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
