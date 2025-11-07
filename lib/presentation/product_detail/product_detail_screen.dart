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
import 'package:speezu/widgets/error_widget.dart';
import 'package:speezu/widgets/login_required_bottom%20sheet.dart';
import '../../core/assets/font_family.dart';
import '../../core/utils/labels.dart';
import '../../models/product_detail_model.dart';
import '../../widgets/image_gallery_viewer_widget.dart';
import '../../widgets/image_type_extention.dart';
import '../../widgets/option_selector_widget.dart';
import '../../widgets/product_box_widget.dart';
import '../../widgets/shimmer/product_detail_shimmar.dart';
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
    if (!mounted) return;

    final parts = errorMessage.split(':');
    final newStoreId = parts.length > 1 ? parts[1] : product.shopName;
    final newStoreName = product.shopName;
    final currentStoreId = parts.length > 2 ? parts[2] : 'Unknown Store';
    final currentQuantity = context.read<ProductDetailBloc>().state.quantity;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          child: Padding(
            padding: EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Icon
                Container(
                  padding: EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.orange.shade50,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.warning_amber_rounded,
                    size: 48,
                    color: Colors.orange.shade600,
                  ),
                ),

                SizedBox(height: 20),

                // Title
                Text(
                  Labels.differentStore,
                  style: TextStyle(
                    fontFamily: FontFamily.fontsPoppinsSemiBold,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                SizedBox(height: 12),

                // Message
                Text(
                  '${Labels.youHaveItemsInYourCartFromAnotherStore} $newStoreName?',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontFamily: FontFamily.fontsPoppinsRegular,
                    fontSize: 14,
                    color: Colors.grey.shade700,
                    height: 1.5,
                  ),
                ),

                SizedBox(height: 24),

                // Buttons
                Row(
                  children: [
                    // Cancel
                    Expanded(
                      child: TextButton(
                        onPressed: () => Navigator.of(context).pop(),
                        style: TextButton.styleFrom(
                          padding: EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: Text(
                          Labels.cancel,
                          style: TextStyle(
                            fontFamily: FontFamily.fontsPoppinsSemiBold,
                            fontSize: 15,
                            color: Colors.grey.shade600,
                          ),
                        ),
                      ),
                    ),

                    SizedBox(width: 12),

                    // View Cart
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                          Navigator.pushNamed(context, RouteNames.cartScreen);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor:
                              Theme.of(context).colorScheme.primary,
                          padding: EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          elevation: 0,
                        ),
                        child: Text(
                          Labels.viewCart,
                          style: TextStyle(
                            fontFamily: FontFamily.fontsPoppinsSemiBold,
                            fontSize: 15,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),

                SizedBox(height: 8),

                // Clear Cart Button
                SizedBox(
                  width: double.infinity,
                  child: TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                      context.read<CartBloc>().add(
                        ClearCartForNewStore(newStoreId: newStoreId),
                      );

                      Future.delayed(Duration(milliseconds: 100), () {
                        if (!mounted) return;

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

                        final selectedParentVariation = product.variations
                            .firstWhere(
                              (v) => v.parentName == selectedParent,
                              orElse: () => product.variations.first,
                            );

                        ProductSubVariation? selectedChildVariation;
                        if (selectedChild != null &&
                            selectedParentVariation.children.isNotEmpty) {
                          selectedChildVariation = selectedParentVariation
                              .children
                              .firstWhere(
                                (child) => child.name == selectedChild,
                                orElse:
                                    () =>
                                        selectedParentVariation.children.first,
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
                    style: TextButton.styleFrom(
                      padding: EdgeInsets.symmetric(vertical: 12),
                    ),
                    child: Text(
                      Labels.clearCartAndSwitchProducts,
                      style: TextStyle(
                        fontFamily: FontFamily.fontsPoppinsSemiBold,
                        fontSize: 14,
                        color: Colors.red.shade600,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
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
              child: CustomErrorWidget(
                message: state.errorMessage ?? Labels.error,
                onRetry: () {
                  context.read<ProductDetailBloc>().add(
                    LoadProductDetail(productId: widget.productId),
                  );
                },
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

        return LayoutBuilder(
          builder: (context, constraints) {
            final screenWidth = constraints.maxWidth;
            final screenHeight = constraints.maxHeight;
            final isTablet = screenWidth >= 600;
            final isLargeTablet = screenWidth >= 900;

            // Responsive values
            final horizontalPadding = isTablet ? 40.0 : 20.0;
            final sliverAppBarHeight = isTablet ? 400.0 : 300.0;
            final backButtonSize = isTablet ? 28.0 : 24.0;
            final shopNameFontSize = isTablet ? 15.0 : 13.0;
            final productNameFontSize = isTablet ? 22.0 : context.scaledFont(18);
            final priceFontSize = isTablet ? 26.0 : 22.0;
            final discountFontSize = isTablet ? 15.0 : 13.0;
            final imageHeight = isTablet ? 250.0 : 200.0;
            final imageWidth = isTablet ? context.widthPct(.45) : context.widthPct(.55);
            final fabSize = isTablet ? 60.0 : 56.0;
            final fabIconSize = isTablet ? 28.0 : 25.0;
            final fabTopPosition = isTablet ? 55.0 : 45.0;
            final fabRightPosition = isTablet ? 30.0 : 20.0;

            return Scaffold(
              body: Stack(
                children: [
                  CustomScrollView(
                    controller: _scrollController,
                    slivers: [
                      SliverAppBar(
                        backgroundColor: Theme.of(context).colorScheme.primary,
                        expandedHeight: sliverAppBarHeight,
                        pinned: true,
                        elevation: 0,
                        automaticallyImplyLeading: false,
                        leading: IconButton(
                          style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all(
                              Theme.of(context).colorScheme.primary.withValues(alpha: 0.5),
                            ),
                          ),
                          icon: Icon(
                            Icons.arrow_back,
                            color: Theme.of(context).colorScheme.onPrimary,
                            size: backButtonSize,
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
                              padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  // Name + Rating
                                  SizedBox(height: context.heightPct(.01)),
                                  Text(
                                    product.shopName,
                                    style: TextStyle(
                                      fontFamily: FontFamily.fontsPoppinsRegular,
                                      color: Theme.of(context).colorScheme.onSecondary,
                                      fontSize: shopNameFontSize,
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
                                            fontFamily: FontFamily.fontsPoppinsSemiBold,
                                            color: Theme.of(context).colorScheme.onSecondary,
                                            fontSize: productNameFontSize,
                                          ),
                                        ),
                                      ),
                                      SizedBox(width: isTablet ? 15 : 10),
                                      if (getCurrentDiscountPercentage(product) > 0)
                                        Container(
                                          padding: EdgeInsets.symmetric(
                                            horizontal: isTablet ? 12 : 10,
                                            vertical: isTablet ? 4 : 2,
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
                                              fontFamily: FontFamily.fontsPoppinsSemiBold,
                                              fontSize: discountFontSize,
                                              color: Colors.white.withValues(alpha: 0.8),
                                            ),
                                          ),
                                        ),
                                    ],
                                  ),
                                  SizedBox(height: context.heightPct(.01)),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Row(
                                        children: [
                                          Text(
                                            "${CurrencyIcon.currencyIcon}${getCurrentPrice(product).toStringAsFixed(2)}",
                                            style: TextStyle(
                                              fontFamily: FontFamily.fontsPoppinsSemiBold,
                                              color: Theme.of(context).colorScheme.primary,
                                              fontSize: priceFontSize,
                                            ),
                                          ),
                                          SizedBox(width: context.widthPct(.02)),
                                          if (getCurrentOriginalPrice(product) != getCurrentPrice(product))
                                            Text(
                                              "${CurrencyIcon.currencyIcon}${getCurrentOriginalPrice(product).toStringAsFixed(2)}",
                                              style: TextStyle(
                                                fontFamily: FontFamily.fontsPoppinsLight,
                                                decoration: TextDecoration.lineThrough,
                                                color: Theme.of(context).colorScheme.onSecondary,
                                                fontSize: isTablet ? 14.0 : context.scaledFont(12),
                                              ),
                                            ),
                                        ],
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: context.heightPct(.02)),

                                  // Show parent variation selector only if variations exist
                                  // Replace your variation selection code with this improved version

                                  if (hasVariations) ...[
                                    // Parent variation selector with required indicator
                                    Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                              product.variations.first.parentOptionName,
                                              style: TextStyle(
                                                fontSize: isTablet ? 16 : 15,
                                                fontFamily: FontFamily.fontsPoppinsSemiBold,
                                                color: Theme.of(context).colorScheme.onSecondary,
                                                letterSpacing: 0.3,
                                              ),
                                            ),
                                            if (selectedParent == null)
                                              Container(
                                                padding: EdgeInsets.symmetric(
                                                  horizontal: isTablet ? 10 : 8,
                                                  vertical: isTablet ? 5 : 4,
                                                ),
                                                decoration: BoxDecoration(
                                                  color: Colors.red.withValues(alpha: 0.1),
                                                  borderRadius: BorderRadius.circular(12),
                                                  border: Border.all(
                                                    color: Colors.red.withValues(alpha: 0.3),
                                                  ),
                                                ),
                                                child: Row(
                                                  mainAxisSize: MainAxisSize.min,
                                                  children: [
                                                    Icon(
                                                      Icons.info_outline,
                                                      size: isTablet ? 14 : 12,
                                                      color: Colors.red,
                                                    ),
                                                    SizedBox(width: 4),
                                                    Text(
                                                      Labels.required,
                                                      style: TextStyle(
                                                        color: Colors.red,
                                                        fontSize: isTablet ? 11 : 10,
                                                        fontFamily: FontFamily.fontsPoppinsSemiBold,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                          ],
                                        ),
                                        SizedBox(height: isTablet ? 12 : 10),
                                        Wrap(
                                          spacing: isTablet ? 12 : 10,
                                          runSpacing: isTablet ? 12 : 10,
                                          children: parentNames.map((option) {
                                            final isSelected = selectedParent == option;

                                            return GestureDetector(
                                              onTap: () {
                                                setState(() {
                                                  selectedParent = option;
                                                  selectedChild = null;
                                                });
                                              },
                                              child: AnimatedContainer(
                                                duration: const Duration(milliseconds: 250),
                                                curve: Curves.easeInOutCubic,
                                                padding: EdgeInsets.symmetric(
                                                  horizontal: isTablet ? 18 : 14,
                                                  vertical: isTablet ? 10 : 8,
                                                ),
                                                decoration: BoxDecoration(
                                                  gradient: isSelected
                                                      ? LinearGradient(
                                                    colors: [
                                                      Theme.of(context).colorScheme.primary,
                                                      Theme.of(context).colorScheme.primary.withValues(alpha: 0.85),
                                                    ],
                                                    begin: Alignment.topLeft,
                                                    end: Alignment.bottomRight,
                                                  )
                                                      : null,
                                                  color: isSelected ? null : Theme.of(context).colorScheme.onPrimary,
                                                  borderRadius: BorderRadius.circular(isTablet ? 12 : 10),
                                                  border: Border.all(
                                                    color: isSelected
                                                        ? Theme.of(context).colorScheme.primary.withValues(alpha: 0.8)
                                                        : Theme.of(context).colorScheme.onSecondary.withValues(alpha: 0.2),
                                                    width: isSelected ? 2.0 : 1.5,
                                                  ),
                                                  boxShadow: [
                                                    if (isSelected)
                                                      BoxShadow(
                                                        color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.4),
                                                        blurRadius: isTablet ? 12 : 10,
                                                        offset: const Offset(0, 4),
                                                        spreadRadius: 0,
                                                      ),
                                                    if (!isSelected)
                                                      BoxShadow(
                                                        color: Colors.black.withValues(alpha: 0.05),
                                                        blurRadius: isTablet ? 6 : 4,
                                                        offset: const Offset(0, 2),
                                                        spreadRadius: 0,
                                                      ),
                                                  ],
                                                ),
                                                child: Row(
                                                  mainAxisSize: MainAxisSize.min,
                                                  children: [
                                                    if (isSelected) ...[
                                                      Icon(
                                                        Icons.check_circle,
                                                        size: isTablet ? 16 : 14,
                                                        color: Theme.of(context).colorScheme.onPrimary,
                                                      ),
                                                      SizedBox(width: isTablet ? 6 : 5),
                                                    ],
                                                    Text(
                                                      option,
                                                      style: TextStyle(
                                                        fontSize: isTablet ? 15 : 13,
                                                        fontFamily: isSelected
                                                            ? FontFamily.fontsPoppinsSemiBold
                                                            : FontFamily.fontsPoppinsRegular,
                                                        color: isSelected
                                                            ? Theme.of(context).colorScheme.onPrimary
                                                            : Theme.of(context).colorScheme.onSecondary.withValues(alpha: .7),
                                                        letterSpacing: 0.2,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            );
                                          }).toList(),
                                        ),
                                      ],
                                    ),
                                    SizedBox(height: context.heightPct(.015)),

                                    // Show child variation selector only if parent is selected and has children
                                    if (selectedParent != null && hasChildVariations) ...[
                                      Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text(
                                                selectedParentVariation.children.first.childOptionName,
                                                style: TextStyle(
                                                  fontSize: isTablet ? 16 : 15,
                                                  fontFamily: FontFamily.fontsPoppinsSemiBold,
                                                  color: Theme.of(context).colorScheme.onSecondary,
                                                  letterSpacing: 0.3,
                                                ),
                                              ),
                                              if (selectedChild == null)
                                                Container(
                                                  padding: EdgeInsets.symmetric(
                                                    horizontal: isTablet ? 10 : 8,
                                                    vertical: isTablet ? 5 : 4,
                                                  ),
                                                  decoration: BoxDecoration(
                                                    color: Colors.red.withValues(alpha: 0.1),
                                                    borderRadius: BorderRadius.circular(12),
                                                    border: Border.all(
                                                      color: Colors.red.withValues(alpha: 0.3),
                                                    ),
                                                  ),
                                                  child: Row(
                                                    mainAxisSize: MainAxisSize.min,
                                                    children: [
                                                      Icon(
                                                        Icons.info_outline,
                                                        size: isTablet ? 14 : 12,
                                                        color: Colors.red,
                                                      ),
                                                      SizedBox(width: 4),
                                                      Text(
                                                        Labels.required,
                                                        style: TextStyle(
                                                          color: Colors.red,
                                                          fontSize: isTablet ? 11 : 10,
                                                          fontFamily: FontFamily.fontsPoppinsSemiBold,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                            ],
                                          ),
                                          SizedBox(height: isTablet ? 12 : 10),
                                          Wrap(
                                            spacing: isTablet ? 12 : 10,
                                            runSpacing: isTablet ? 12 : 10,
                                            children: childOptions.map((childOption) {
                                              final isSelected = selectedChild == childOption.name;

                                              return GestureDetector(
                                                onTap: () {
                                                  setState(() {
                                                    selectedChild = childOption.name;
                                                  });
                                                },
                                                child: AnimatedContainer(
                                                  duration: const Duration(milliseconds: 250),
                                                  curve: Curves.easeInOutCubic,
                                                  padding: EdgeInsets.symmetric(
                                                    horizontal: isTablet ? 18 : 14,
                                                    vertical: isTablet ? 10 : 8,
                                                  ),
                                                  decoration: BoxDecoration(
                                                    gradient: isSelected
                                                        ? LinearGradient(
                                                      colors: [
                                                        Theme.of(context).colorScheme.primary,
                                                        Theme.of(context).colorScheme.primary.withValues(alpha: 0.85),
                                                      ],
                                                      begin: Alignment.topLeft,
                                                      end: Alignment.bottomRight,
                                                    )
                                                        : null,
                                                    color: isSelected ? null : Theme.of(context).colorScheme.onPrimary,
                                                    borderRadius: BorderRadius.circular(isTablet ? 12 : 10),
                                                    border: Border.all(
                                                      color: isSelected
                                                          ? Theme.of(context).colorScheme.primary.withValues(alpha: 0.8)
                                                          : Theme.of(context).colorScheme.onSecondary.withValues(alpha: 0.2),
                                                      width: isSelected ? 2.0 : 1.5,
                                                    ),
                                                    boxShadow: [
                                                      if (isSelected)
                                                        BoxShadow(
                                                          color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.4),
                                                          blurRadius: isTablet ? 12 : 10,
                                                          offset: const Offset(0, 4),
                                                          spreadRadius: 0,
                                                        ),
                                                      if (!isSelected)
                                                        BoxShadow(
                                                          color: Colors.black.withValues(alpha: 0.05),
                                                          blurRadius: isTablet ? 6 : 4,
                                                          offset: const Offset(0, 2),
                                                          spreadRadius: 0,
                                                        ),
                                                    ],
                                                  ),
                                                  child: Row(
                                                    mainAxisSize: MainAxisSize.min,
                                                    children: [
                                                      if (isSelected) ...[
                                                        Icon(
                                                          Icons.check_circle,
                                                          size: isTablet ? 16 : 14,
                                                          color: Theme.of(context).colorScheme.onPrimary,
                                                        ),
                                                        SizedBox(width: isTablet ? 6 : 5),
                                                      ],
                                                      Text(
                                                        childOption.name,
                                                        style: TextStyle(
                                                          fontSize: isTablet ? 15 : 13,
                                                          fontFamily: isSelected
                                                              ? FontFamily.fontsPoppinsSemiBold
                                                              : FontFamily.fontsPoppinsRegular,
                                                          color: isSelected
                                                              ? Theme.of(context).colorScheme.onPrimary
                                                              : Theme.of(context).colorScheme.onSecondary.withValues(alpha: .7),
                                                          letterSpacing: 0.2,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              );
                                            }).toList(),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ],

                                  SizedBox(height: isTablet ? 15 : 10),

                                  SizedBox(
                                    height: imageHeight,
                                    child: ListView.separated(
                                      scrollDirection: Axis.horizontal,
                                      padding: EdgeInsets.all(isTablet ? 15 : 12),
                                      itemCount: product.images.length,
                                      separatorBuilder: (_, __) => SizedBox(width: isTablet ? 15 : 10),
                                      itemBuilder: (context, index) {
                                        return CustomImageView(
                                          onTap: () {
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) => ImageGalleryViewer(
                                                  imageUrls: product.images,
                                                  initialIndex: index,
                                                ),
                                              ),
                                            );
                                          },
                                          radius: BorderRadius.circular(isTablet ? 12 : 10),
                                          imagePath: product.images[index],
                                          width: imageWidth,
                                          fit: BoxFit.cover,
                                        );
                                      },
                                    ),
                                  ),
                                  SizedBox(height: isTablet ? 15 : 10),
                                  Container(
                                    decoration: BoxDecoration(
                                      color: Theme.of(context).colorScheme.onPrimary,
                                      borderRadius: BorderRadius.circular(isTablet ? 16 : 12),
                                      border: Border.all(
                                        color: Theme.of(context).colorScheme.outline.withValues(alpha: .3),
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
                                        SizedBox(height: isTablet ? 12 : 10),
                                        Padding(
                                          padding: EdgeInsets.symmetric(horizontal: isTablet ? 15.0 : 10.0),
                                          child: Text(
                                            Labels.description,
                                            style: TextStyle(
                                              fontFamily: FontFamily.fontsPoppinsSemiBold,
                                              color: Theme.of(context).colorScheme.onSecondary,
                                              fontSize: isTablet ? 16 : 14,
                                            ),
                                          ),
                                        ),
                                        Divider(
                                          color: Theme.of(context).colorScheme.outline.withValues(alpha: .3),
                                        ),
                                        Padding(
                                          padding: EdgeInsets.symmetric(horizontal: isTablet ? 15.0 : 10.0),
                                          child: Text(
                                            product.description,
                                            style: TextStyle(
                                              fontFamily: FontFamily.fontsPoppinsLight,
                                              color: Theme.of(context).colorScheme.onSecondary,
                                              fontSize: isTablet ? 14 : context.scaledFont(12),
                                            ),
                                          ),
                                        ),
                                        SizedBox(height: isTablet ? 12 : 10),
                                      ],
                                    ),
                                  ),
                                  SizedBox(height: isTablet ? 15 : 10),
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
                                    },
                                  ),

                                  SizedBox(height: isTablet ? 20 : 15),

                                  Text(
                                    Labels.youMightAlsoLike,
                                    style: TextStyle(
                                      fontFamily: FontFamily.fontsPoppinsSemiBold,
                                      color: Theme.of(context).colorScheme.onSecondary,
                                      fontSize: isTablet ? 16 : 14,
                                    ),
                                  ),
                                  SizedBox(height: isTablet ? 20 : 15),
                                  LayoutBuilder(
                                    builder: (context, innerConstraints) {
                                      double availableWidth = innerConstraints.maxWidth;

                                      int crossAxisCount;
                                      if (availableWidth >= 1200) {
                                        crossAxisCount = 4;
                                      } else if (availableWidth >= 900) {
                                        crossAxisCount = 3;
                                      } else if (availableWidth >= 600) {
                                        crossAxisCount = 3;
                                      } else {
                                        crossAxisCount = 2;
                                      }

                                      final spacing = isTablet ? 12.0 : 10.0;

                                      return Padding(
                                        padding: EdgeInsets.all(isTablet ? 12 : 0),
                                        child: StaggeredGrid.count(
                                          crossAxisCount: crossAxisCount,
                                          mainAxisSpacing: spacing,
                                          crossAxisSpacing: spacing,
                                          children: List.generate(
                                            product.relatedProducts.length,
                                                (index) {
                                              final relatedProduct = product.relatedProducts[index];
                                              return StaggeredGridTile.fit(
                                                crossAxisCellCount: 1,
                                                child: ProductBox(
                                                  marginPadding: const Padding(
                                                    padding: EdgeInsets.all(0),
                                                  ),
                                                  productWidth: (availableWidth - (spacing * (crossAxisCount - 1))) / crossAxisCount - 20,
                                                  productPrice: relatedProduct.price,
                                                  productOriginalPrice: relatedProduct.originalPrice,
                                                  productCategory: relatedProduct.categoryName,
                                                  productRating: 4.0,
                                                  productId: relatedProduct.id,
                                                  onProductTap: () {
                                                    Navigator.pushReplacementNamed(
                                                      context,
                                                      RouteNames.productScreen,
                                                      arguments: relatedProduct.id,
                                                    );
                                                  },
                                                  productImageUrl: relatedProduct.imageUrl,
                                                  productTitle: relatedProduct.name,
                                                ),
                                              );
                                            },
                                          ),
                                        ),
                                      );
                                    },
                                  ),

                                  SizedBox(height: isTablet ? 20 : 15),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  BlocBuilder<ProductDetailBloc, ProductDetailState>(
                    builder: (context, state) => SafeArea(
                      child: Align(
                        alignment: Alignment.bottomCenter,
                        child: AnimatedSlide(
                          duration: const Duration(milliseconds: 400),
                          curve: Curves.easeInOut,
                          offset: state.isBottomSheetVisible ? Offset(0, 0) : Offset(0, 1),
                          child: AnimatedOpacity(
                            duration: const Duration(milliseconds: 300),
                            opacity: state.isBottomSheetVisible ? 1 : 0,
                            child: Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: isTablet ? 20.0 : 15.0,
                                vertical: isTablet ? 12.0 : 8.0,
                              ),
                              decoration: BoxDecoration(
                                color: Theme.of(context).colorScheme.onPrimary,
                                borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(isTablet ? 35 : 30),
                                  topRight: Radius.circular(isTablet ? 35 : 30),
                                ),
                                border: Border.all(
                                  color: Theme.of(context).colorScheme.primary.withValues(alpha: .3),
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
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        Labels.quantity,
                                        style: TextStyle(
                                          fontFamily: FontFamily.fontsPoppinsSemiBold,
                                          color: Theme.of(context).colorScheme.onSecondary,
                                          fontSize: isTablet ? 18 : 16,
                                        ),
                                      ),
                                      Row(
                                        children: [
                                          IconButton(
                                            onPressed: () {
                                              context.read<ProductDetailBloc>().add(DecrementQuantity());
                                            },
                                            icon: Icon(
                                              Icons.remove_circle_outline,
                                              color: Theme.of(context).colorScheme.primary,
                                              size: isTablet ? 28 : 24,
                                            ),
                                          ),
                                          SizedBox(width: isTablet ? 12 : 10),
                                          Text(
                                            "${state.quantity}",
                                            style: TextStyle(
                                              fontFamily: FontFamily.fontsPoppinsSemiBold,
                                              color: Theme.of(context).colorScheme.onSecondary,
                                              fontSize: isTablet ? 18 : 16,
                                            ),
                                          ),
                                          SizedBox(width: isTablet ? 12 : 10),
                                          IconButton(
                                            onPressed: () {
                                              context.read<ProductDetailBloc>().add(IncrementQuantity());
                                            },
                                            icon: Icon(
                                              Icons.add_circle_outline,
                                              color: Theme.of(context).colorScheme.primary,
                                              size: isTablet ? 28 : 24,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: isTablet ? 12 : 10),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      IconButton(
                                        style: ButtonStyle(
                                          backgroundColor: MaterialStateProperty.all(
                                            state.productDetail!.isFavourite
                                                ? Theme.of(context).colorScheme.primary
                                                : Theme.of(context).colorScheme.onSecondary.withValues(alpha: .3),
                                          ),
                                          minimumSize: MaterialStateProperty.all(
                                            Size(isTablet ? 70 : 60, isTablet ? 55 : 50),
                                          ),
                                          shape: MaterialStateProperty.all(
                                            RoundedRectangleBorder(
                                              borderRadius: BorderRadius.circular(50),
                                            ),
                                          ),
                                        ),
                                        onPressed: () async {
                                          final isLoggedIn = await UserRepository().isUserAuthenticated();

                                          if (!isLoggedIn) {
                                            await LoginRequiredBottomSheet.show(context);
                                            return;
                                          }
                                          final productDetailBloc = context.read<ProductDetailBloc>();
                                          final favouriteBloc = context.read<FavouriteBloc>();

                                          final currentFav = state.productDetail!.isFavourite;
                                          final productId = state.productDetail!.id ?? '';

                                          productDetailBloc.add(
                                            UpdateFavouriteStatusEvent(
                                              productId: productId,
                                              isFavourite: !currentFav,
                                            ),
                                          );

                                          favouriteBloc.add(
                                            ToggleFavouriteEvent(
                                              productId: productId,
                                            ),
                                          );
                                        },
                                        icon: Icon(
                                          Icons.favorite,
                                          color: Colors.white,
                                          size: isTablet ? 28 : 24,
                                        ),
                                      ),

                                      SizedBox(width: isTablet ? 12 : 10),
                                      Expanded(
                                        child: ElevatedButton(
                                          style: ButtonStyle(
                                            backgroundColor: MaterialStateProperty.all(
                                              _areVariationsValid(product)
                                                  ? Theme.of(context).colorScheme.primary
                                                  : Colors.grey.withValues(alpha: 0.6),
                                            ),
                                            minimumSize: MaterialStateProperty.all(
                                              Size(250, isTablet ? 55 : 50),
                                            ),
                                            shape: MaterialStateProperty.all(
                                              RoundedRectangleBorder(
                                                borderRadius: BorderRadius.circular(50),
                                              ),
                                            ),
                                          ),
                                          onPressed: _areVariationsValid(product)
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
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text(
                                                Labels.addToCart,
                                                style: TextStyle(
                                                  fontFamily: FontFamily.fontsPoppinsSemiBold,
                                                  color: Colors.white,
                                                  fontSize: isTablet ? 17 : 15,
                                                ),
                                              ),
                                              Text(
                                                '${calculateTotalPrice(product, state.quantity).toStringAsFixed(2)}\$',
                                                style: TextStyle(
                                                  fontFamily: FontFamily.fontsPoppinsSemiBold,
                                                  color: Colors.white,
                                                  fontSize: isTablet ? 18 : 16,
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
                    top: fabTopPosition,
                    right: fabRightPosition,
                    child: BlocBuilder<CartBloc, CartState>(
                      builder: (context, cartState) {
                        final cartCount = cartState.totalItems;
                        return Stack(
                          children: [
                            FloatingActionButton(
                              backgroundColor: Theme.of(context).colorScheme.primary,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(100),
                              ),
                              mini: !isTablet,
                              onPressed: () async {
                                final isLoggedIn = await UserRepository().isUserAuthenticated();
                                if (!isLoggedIn) {
                                  await LoginRequiredBottomSheet.show(context);
                                  return;
                                }
                                Navigator.pushNamed(context, RouteNames.cartScreen);
                              },
                              child: Icon(
                                Icons.shopping_cart_rounded,
                                color: Colors.white,
                                size: fabIconSize,
                              ),
                            ),
                            if (cartCount > 0)
                              Positioned(
                                right: 0,
                                top: 0,
                                child: Container(
                                  padding: EdgeInsets.all(isTablet ? 3 : 2),
                                  decoration: BoxDecoration(
                                    color: Colors.red,
                                    borderRadius: BorderRadius.circular(isTablet ? 12 : 10),
                                  ),
                                  constraints: BoxConstraints(
                                    minWidth: isTablet ? 24 : 20,
                                    minHeight: isTablet ? 24 : 20,
                                  ),
                                  child: Text(
                                    cartCount.toString(),
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: isTablet ? 13 : 12,
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
      },
    );
  }
}
