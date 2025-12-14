import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
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
  final Map<String, Map<String, String?>> selectedVariationsByType = {};
  final ScrollController _scrollController = ScrollController();
  StreamSubscription<CartState>? _cartSubscription;
  String? _currentProductId; // Track current product to detect changes
  bool _isShowingConflictDialog =
      false; // Track if conflict dialog is currently showing
  String?
  _lastConflictMessage; // Track last conflict message to prevent duplicates

  Map<String, String?> get selectedVariations {
    final Map<String, String?> flatMap = {};
    for (final typeMap in selectedVariationsByType.values) {
      flatMap.addAll(typeMap);
    }
    return flatMap;
  }

  @override
  void initState() {
    super.initState();

    // CRITICAL: Clear any previous product's variation data
    selectedVariationsByType.clear();
    _currentProductId = null;

    // Reset conflict dialog flags
    _isShowingConflictDialog = false;
    _lastConflictMessage = null;

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

  // Auto-select first variation options when product loads
  void _autoSelectFirstVariations(ProductDetail product) {
    if (product.variations.isEmpty) return;

    // CRITICAL: Always clear to prevent contamination from previous products
    selectedVariationsByType.clear();

    // Group variations by parent type
    final Map<String, List<ProductVariation>> variationsByParentType = {};
    for (final variation in product.variations) {
      final parentType = variation.parentOptionName;
      if (!variationsByParentType.containsKey(parentType)) {
        variationsByParentType[parentType] = [];
      }
      variationsByParentType[parentType]!.add(variation);
    }

    // Auto-select first option for each parent type that has children
    for (final parentTypeEntry in variationsByParentType.entries) {
      final parentType = parentTypeEntry.key;
      final variations = parentTypeEntry.value;

      // Check if any variation in this type has children
      final hasChildren = variations.any((v) => v.children.isNotEmpty);

      if (!hasChildren) {
        // Skip optional variations (no children)
        continue;
      }

      // Find the first variation with children
      final firstVariation = variations.firstWhere(
        (v) => v.children.isNotEmpty,
      );

      // Auto-select the first child if available
      if (firstVariation.children.isNotEmpty) {
        final firstChild = firstVariation.children.first;

        // Initialize map for this parent type if needed
        if (!selectedVariationsByType.containsKey(parentType)) {
          selectedVariationsByType[parentType] = {};
        }

        // Auto-select: parent name → first child name
        selectedVariationsByType[parentType]![firstVariation.parentName] =
            firstChild.name;
      }
    }
  }

  @override
  void dispose() {
    _cartSubscription?.cancel();
    _scrollController.dispose();
    selectedVariationsByType.clear(); // Ensure clean disposal
    _currentProductId = null;
    super.dispose();
  }

  // Calculate the current price based on selected variations
  // NEW LOGIC: Sum all selected variation prices and add to product discounted price
  double getCurrentPrice(ProductDetail product) {
    // Start with product's discounted price
    double finalPrice = product.price;

    // If no variations, return product discounted price
    if (product.variations.isEmpty || selectedVariationsByType.isEmpty) {
      return finalPrice;
    }

    // Sum all selected variation prices (ignore variation discounts)
    double variationTotal = 0.0;

    for (final parentTypeEntry in selectedVariationsByType.entries) {
      final parentType = parentTypeEntry.key;
      final typeMap = parentTypeEntry.value;

      for (final selectedEntry in typeMap.entries) {
        final parentName = selectedEntry.key;
        final childName = selectedEntry.value;

        if (childName == null) continue;

        // Find the parent variation
        final parentVariation = product.variations.firstWhere(
          (v) => v.parentName == parentName && v.parentOptionName == parentType,
          orElse: () => product.variations.first,
        );

        // Find the selected child and add its price (NOT discounted price)
        if (parentVariation.children.isNotEmpty) {
          final childVariation = parentVariation.children.firstWhere(
            (child) => child.name == childName,
            orElse: () => parentVariation.children.first,
          );
          variationTotal += childVariation.price;
        }
      }
    }

    // Final price = product discounted price + sum of all variation prices
    return finalPrice + variationTotal;
  }

  // Calculate the current original price based on selected variations
  // NEW LOGIC: Sum all selected variation prices and add to product original price
  double getCurrentOriginalPrice(ProductDetail product) {
    // Start with product's original price
    double finalOriginalPrice = product.originalPrice;

    // If no variations, return product original price
    if (product.variations.isEmpty || selectedVariationsByType.isEmpty) {
      return finalOriginalPrice;
    }

    // Sum all selected variation prices (ignore variation discounts)
    double variationTotal = 0.0;

    for (final parentTypeEntry in selectedVariationsByType.entries) {
      final parentType = parentTypeEntry.key;
      final typeMap = parentTypeEntry.value;

      for (final selectedEntry in typeMap.entries) {
        final parentName = selectedEntry.key;
        final childName = selectedEntry.value;

        if (childName == null) continue;

        // Find the parent variation
        final parentVariation = product.variations.firstWhere(
          (v) => v.parentName == parentName && v.parentOptionName == parentType,
          orElse: () => product.variations.first,
        );

        // Find the selected child and add its price (NOT discounted price)
        if (parentVariation.children.isNotEmpty) {
          final childVariation = parentVariation.children.firstWhere(
            (child) => child.name == childName,
            orElse: () => parentVariation.children.first,
          );
          variationTotal += childVariation.price;
        }
      }
    }

    // Final original price = product original price + sum of all variation prices
    return finalOriginalPrice + variationTotal;
  }

  // Calculate the current discount percentage based on selected variations
  // NEW LOGIC: Calculate based on difference between final price and final original price
  double getCurrentDiscountPercentage(ProductDetail product) {
    final finalPrice = getCurrentPrice(product);
    final finalOriginalPrice = getCurrentOriginalPrice(product);

    // If no discount, return 0
    if (finalOriginalPrice <= 0 || finalPrice >= finalOriginalPrice) {
      return 0;
    }

    // Calculate discount percentage
    return ((finalOriginalPrice - finalPrice) / finalOriginalPrice) * 100;
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

    // Group variations by parent type to understand the structure
    final Map<String, List<ProductVariation>> variationsByParentType = {};
    for (final variation in product.variations) {
      final parentType = variation.parentOptionName;
      if (!variationsByParentType.containsKey(parentType)) {
        variationsByParentType[parentType] = [];
      }
      variationsByParentType[parentType]!.add(variation);
    }

    // Check each parent type (e.g., "Size", "Crust", etc.)
    for (final parentTypeEntry in variationsByParentType.entries) {
      final parentType = parentTypeEntry.key;
      final variations = parentTypeEntry.value;

      // Check if any variation in this parent type has children
      final hasChildren = variations.any((v) => v.children.isNotEmpty);

      if (!hasChildren) {
        // If this parent type has no children anywhere, it's optional - skip validation
        continue;
      }

      // This parent type has children, so a selection is REQUIRED
      if (!selectedVariationsByType.containsKey(parentType)) {
        // No selection made for this required parent type - INVALID
        return false;
      }

      final typeMap = selectedVariationsByType[parentType]!;
      if (typeMap.isEmpty) {
        // No selection made for this required parent type - INVALID
        return false;
      }

      // Check if a child is actually selected (not just a parent)
      bool hasChildSelection = false;
      for (final entry in typeMap.entries) {
        final selectedChild = entry.value;
        if (selectedChild != null && selectedChild.isNotEmpty) {
          hasChildSelection = true;
          break;
        }
      }

      if (!hasChildSelection) {
        // Parent type has children but no child selected - INVALID
        return false;
      }
    }

    // All required variations are selected
    return true;
  }

  // Get the missing variation message
  String _getMissingVariationMessage(ProductDetail product) {
    if (product.variations.isEmpty) {
      return '';
    }

    // Group variations by parent type
    final Map<String, List<ProductVariation>> variationsByParentType = {};
    for (final variation in product.variations) {
      final parentType = variation.parentOptionName;
      if (!variationsByParentType.containsKey(parentType)) {
        variationsByParentType[parentType] = [];
      }
      variationsByParentType[parentType]!.add(variation);
    }

    // Find the first parent type with children that has no selection
    for (final parentTypeEntry in variationsByParentType.entries) {
      final parentType = parentTypeEntry.key;
      final variations = parentTypeEntry.value;

      // Check if any variation in this type has children
      final hasChildren = variations.any((v) => v.children.isNotEmpty);

      if (!hasChildren) {
        // Skip optional variations
        continue;
      }

      // Check if this parent type has a valid selection
      if (!selectedVariationsByType.containsKey(parentType) ||
          selectedVariationsByType[parentType]!.isEmpty) {
        // Get the child option name from the first variation with children
        final variationWithChildren = variations.firstWhere(
          (v) => v.children.isNotEmpty,
        );
        final childOptionName =
            variationWithChildren.children.first.childOptionName;
        return '${Labels.pleaseSelectA} $childOptionName';
      }

      // Check if a child is selected
      final typeMap = selectedVariationsByType[parentType]!;
      bool hasChildSelection = false;
      for (final selectedChild in typeMap.values) {
        if (selectedChild != null && selectedChild.isNotEmpty) {
          hasChildSelection = true;
          break;
        }
      }

      if (!hasChildSelection) {
        // Get the child option name
        final variationWithChildren = variations.firstWhere(
          (v) => v.children.isNotEmpty,
        );
        final childOptionName =
            variationWithChildren.children.first.childOptionName;
        return '${Labels.pleaseSelectA} $childOptionName';
      }
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

    // Set up stream listener for store and delivery conflicts BEFORE adding to cart
    _cartSubscription?.cancel(); // Cancel any existing subscription
    _cartSubscription = context.read<CartBloc>().stream.listen((cartState) {
      print(
        'Cart state changed: ${cartState.status}, error: ${cartState.errorMessage}',
      );
      if (mounted &&
          cartState.status == CartStatus.error &&
          cartState.errorMessage != null &&
          !_isShowingConflictDialog && // Don't show if already showing a dialog
          _lastConflictMessage != cartState.errorMessage) {
        // Don't show same error twice
        if (cartState.errorMessage!.startsWith('STORE_CONFLICT:')) {
          print('Showing store conflict dialog for product: ${product.name}');
          _lastConflictMessage = cartState.errorMessage;
          _isShowingConflictDialog = true;
          _showConflictDialog(
            context,
            cartState.errorMessage!,
            product,
            isStoreConflict: true,
          );
        } else if (cartState.errorMessage!.startsWith('DELIVERY_CONFLICT:')) {
          print(
            'Showing delivery conflict dialog for product: ${product.name}',
          );
          _lastConflictMessage = cartState.errorMessage;
          _isShowingConflictDialog = true;
          _showConflictDialog(
            context,
            cartState.errorMessage!,
            product,
            isStoreConflict: false,
          );
        }
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
          calculatedPrice: getCurrentPrice(product),
          calculatedOriginalPrice: getCurrentOriginalPrice(product),
        ),
      );
      return;
    }

    // Safety check: validation should have ensured at least one variation is selected
    if (selectedVariationsByType.isEmpty) {
      // This shouldn't happen if validation is correct, but add safety check
      _showVariationRequiredSnackBar(context, product);
      return;
    }

    // Get all selected parent types
    final parentTypes = selectedVariationsByType.keys.toList();

    // First parent type: use variationParentName and variationParentValue
    final firstParentType = parentTypes.first;
    final firstTypeMap = selectedVariationsByType[firstParentType]!;

    if (firstTypeMap.isEmpty) {
      _showVariationRequiredSnackBar(context, product);
      return;
    }

    final firstSelectedParentName = firstTypeMap.keys.first;
    final firstSelectedChild = firstTypeMap[firstSelectedParentName];

    // Find the first parent variation for IDs
    final firstParentVariation = product.variations.firstWhere(
      (v) =>
          v.parentName == firstSelectedParentName &&
          v.parentOptionName == firstParentType,
      orElse:
          () => product.variations.firstWhere(
            (v) => v.parentOptionName == firstParentType,
            orElse: () => product.variations.first,
          ),
    );

    // Find FIRST child variation ID (selected option ID) - FIXED
    String? firstChildVariationId;
    if (firstSelectedChild != null &&
        firstParentVariation.children.isNotEmpty) {
      final firstChildVariation = firstParentVariation.children.firstWhere(
        (child) => child.name == firstSelectedChild,
        orElse: () => firstParentVariation.children.first,
      );
      firstChildVariationId = firstChildVariation.id;
    }

    // Second parent type (if exists): use variationChildName and variationChildValue
    String? secondParentType;
    String? secondSelectedChild;
    String? secondChildVariationId;

    if (parentTypes.length > 1) {
      secondParentType = parentTypes[1];
      final secondTypeMap = selectedVariationsByType[secondParentType]!;
      if (secondTypeMap.isNotEmpty) {
        final secondSelectedParentName = secondTypeMap.keys.first;
        secondSelectedChild = secondTypeMap[secondSelectedParentName];

        // Find the second parent variation for IDs
        final secondParentVariation = product.variations.firstWhere(
          (v) =>
              v.parentName == secondSelectedParentName &&
              v.parentOptionName == secondParentType,
          orElse:
              () => product.variations.firstWhere(
                (v) => v.parentOptionName == secondParentType,
                orElse: () => product.variations.first,
              ),
        );

        // Find child variation ID if child is selected
        if (secondSelectedChild != null &&
            secondParentVariation.children.isNotEmpty) {
          final secondChildVariation = secondParentVariation.children
              .firstWhere(
                (child) => child.name == secondSelectedChild,
                orElse: () => secondParentVariation.children.first,
              );
          secondChildVariationId = secondChildVariation.id;
        }
      }
    }

    // Add product to cart with selected variations
    // For display: "Parent Type: Selected Child"
    // variationParentName = first parent type (e.g., "Size")
    // variationParentValue = selected child of first parent (e.g., "Small")
    // variationChildName = second parent type (e.g., "Crust") if exists
    // variationChildValue = selected child of second parent (e.g., "Thin Crust") if exists
    context.read<CartBloc>().add(
      AddToCart(
        product: product,
        quantity: quantity,
        variationParentName: firstParentType, // Label like "Size"
        variationParentValue:
            firstSelectedChild ??
            firstSelectedParentName, // Selected child like "Small"
        variationChildName: secondParentType, // Second parent type like "Crust"
        variationChildValue:
            secondSelectedChild, // Selected child of second parent like "Thin Crust"
        variationParentId:
            firstChildVariationId, // FIXED: Now stores selected option ID
        variationChildId: secondChildVariationId,
        calculatedPrice: getCurrentPrice(product),
        calculatedOriginalPrice: getCurrentOriginalPrice(product),
      ),
    );
  }

  void _showConflictDialog(
    BuildContext context,
    String errorMessage,
    ProductDetail product, {
    required bool isStoreConflict,
  }) {
    if (!mounted) return;

    final parts = errorMessage.split(':');
    final currentQuantity = context.read<ProductDetailBloc>().state.quantity;

    // Determine dialog content based on conflict type
    String dialogTitle;
    String dialogMessage;
    String newStoreId;

    if (isStoreConflict) {
      newStoreId = parts.length > 1 ? parts[1] : product.shopName;
      final newStoreName = product.shopName;
      dialogTitle = Labels.differentStore;
      dialogMessage =
          '${Labels.youHaveItemsInYourCartFromAnotherStore} $newStoreName?';
    } else {
      // Delivery conflict
      newStoreId = product.shop.id.toString();
      final newDeliveryStatus = parts.length > 1 && parts[1] == 'true';
      dialogTitle = Labels.deliveryConflict;

      if (newDeliveryStatus) {
        // Trying to add deliverable product, cart has non-deliverable
        dialogMessage = Labels.cartContainsNonDeliverable;
      } else {
        // Trying to add non-deliverable product, cart has deliverable
        dialogMessage = Labels.cartContainsDeliverable;
      }
    }

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
                  dialogTitle,
                  style: TextStyle(
                    fontFamily: FontFamily.fontsPoppinsSemiBold,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                SizedBox(height: 12),

                // Message
                Text(
                  dialogMessage,
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
                        onPressed: () {
                          Navigator.of(context).pop();
                          // Reset dialog state and cart error
                          _isShowingConflictDialog = false;
                          _lastConflictMessage = null;
                          context.read<CartBloc>().add(ResetCartStatus());
                        },
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
                          // Reset dialog state and cart error
                          _isShowingConflictDialog = false;
                          _lastConflictMessage = null;
                          context.read<CartBloc>().add(ResetCartStatus());
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
                      // Reset dialog state
                      _isShowingConflictDialog = false;
                      _lastConflictMessage = null;
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
                              calculatedPrice: getCurrentPrice(product),
                              calculatedOriginalPrice: getCurrentOriginalPrice(
                                product,
                              ),
                            ),
                          );
                          return;
                        }

                        // Safety check
                        if (selectedVariationsByType.isEmpty) {
                          return;
                        }

                        // Get all selected parent types
                        final parentTypes =
                            selectedVariationsByType.keys.toList();

                        // First parent type: use variationParentName and variationParentValue
                        final firstParentType = parentTypes.first;
                        final firstTypeMap =
                            selectedVariationsByType[firstParentType]!;

                        if (firstTypeMap.isEmpty) {
                          return;
                        }

                        final firstSelectedParentName = firstTypeMap.keys.first;
                        final firstSelectedChild =
                            firstTypeMap[firstSelectedParentName];

                        // Find the first parent variation for IDs
                        final firstParentVariation = product.variations
                            .firstWhere(
                              (v) =>
                                  v.parentName == firstSelectedParentName &&
                                  v.parentOptionName == firstParentType,
                              orElse:
                                  () => product.variations.firstWhere(
                                    (v) =>
                                        v.parentOptionName == firstParentType,
                                    orElse: () => product.variations.first,
                                  ),
                            );

                        // Find FIRST child variation ID (selected option ID) - FIXED
                        String? firstChildVariationId;
                        if (firstSelectedChild != null &&
                            firstParentVariation.children.isNotEmpty) {
                          final firstChildVariation = firstParentVariation
                              .children
                              .firstWhere(
                                (child) => child.name == firstSelectedChild,
                                orElse:
                                    () => firstParentVariation.children.first,
                              );
                          firstChildVariationId = firstChildVariation.id;
                        }

                        // Second parent type (if exists): use variationChildName and variationChildValue
                        String? secondParentType;
                        String? secondSelectedChild;
                        String? secondChildVariationId;

                        if (parentTypes.length > 1) {
                          secondParentType = parentTypes[1];
                          final secondTypeMap =
                              selectedVariationsByType[secondParentType]!;
                          if (secondTypeMap.isNotEmpty) {
                            final secondSelectedParentName =
                                secondTypeMap.keys.first;
                            secondSelectedChild =
                                secondTypeMap[secondSelectedParentName];

                            // Find the second parent variation for IDs
                            final secondParentVariation = product.variations
                                .firstWhere(
                                  (v) =>
                                      v.parentName ==
                                          secondSelectedParentName &&
                                      v.parentOptionName == secondParentType,
                                  orElse:
                                      () => product.variations.firstWhere(
                                        (v) =>
                                            v.parentOptionName ==
                                            secondParentType,
                                        orElse: () => product.variations.first,
                                      ),
                                );

                            // Find child variation ID if child is selected
                            if (secondSelectedChild != null &&
                                secondParentVariation.children.isNotEmpty) {
                              final secondChildVariation = secondParentVariation
                                  .children
                                  .firstWhere(
                                    (child) =>
                                        child.name == secondSelectedChild,
                                    orElse:
                                        () =>
                                            secondParentVariation
                                                .children
                                                .first,
                                  );
                              secondChildVariationId = secondChildVariation.id;
                            }
                          }
                        }

                        context.read<CartBloc>().add(
                          AddToCart(
                            product: product,
                            quantity: currentQuantity,
                            variationParentName: firstParentType,
                            variationParentValue:
                                firstSelectedChild ?? firstSelectedParentName,
                            variationChildName: secondParentType,
                            variationChildValue: secondSelectedChild,
                            variationParentId:
                                firstChildVariationId, // FIXED: Now stores selected option ID
                            variationChildId: secondChildVariationId,
                            calculatedPrice: getCurrentPrice(product),
                            calculatedOriginalPrice: getCurrentOriginalPrice(
                              product,
                            ),
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

        // CRITICAL: Reset variations when product changes
        if (_currentProductId != product.id) {
          _currentProductId = product.id;
          selectedVariationsByType.clear();

          // Auto-select first variations for this new product
          if (product.variations.isNotEmpty) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              if (mounted) {
                setState(() {
                  _autoSelectFirstVariations(product);
                });
              }
            });
          }
        }

        // Handle different variation scenarios
        final hasVariations = product.variations.isNotEmpty;

        // Group variations by parentOptionName to show each parent type separately
        final Map<String, List<ProductVariation>> variationsByParentType = {};
        if (hasVariations) {
          for (final variation in product.variations) {
            final parentType = variation.parentOptionName;
            if (!variationsByParentType.containsKey(parentType)) {
              variationsByParentType[parentType] = [];
            }
            variationsByParentType[parentType]!.add(variation);
          }
        }

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
            final productNameFontSize =
                isTablet ? 22.0 : context.scaledFont(18);
            final priceFontSize = isTablet ? 26.0 : 22.0;
            final discountFontSize = isTablet ? 15.0 : 13.0;
            final imageHeight = isTablet ? 250.0 : 200.0;
            final imageWidth =
                isTablet ? context.widthPct(.45) : context.widthPct(.55);
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
                              Theme.of(
                                context,
                              ).colorScheme.primary.withValues(alpha: 0.5),
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
                              padding: EdgeInsets.symmetric(
                                horizontal: horizontalPadding,
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  // Name + Rating
                                  SizedBox(height: context.heightPct(.01)),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        product.shopName,
                                        style: TextStyle(
                                          fontFamily:
                                              FontFamily.fontsPoppinsRegular,
                                          color:
                                              Theme.of(
                                                context,
                                              ).colorScheme.onSecondary,
                                          fontSize: shopNameFontSize,
                                        ),
                                      ),
                                      Container(
                                        padding: EdgeInsets.symmetric(
                                          horizontal: 5,
                                          vertical: 2,
                                        ),
                                        decoration: BoxDecoration(
                                          color:
                                              state
                                                          .productDetail
                                                          ?.isDeliveryAvailable ==
                                                      true
                                                  ? Colors.blue
                                                  : Colors.red,
                                          borderRadius: BorderRadius.circular(
                                            5,
                                          ),
                                        ),
                                        child: Row(
                                          children: [
                                            Icon(
                                              state
                                                          .productDetail
                                                          ?.isDeliveryAvailable ==
                                                      true
                                                  ? Icons
                                                      .delivery_dining_rounded
                                                  : Icons.not_interested,
                                              size: 12,
                                              color: Colors.white,
                                            ),
                                            SizedBox(width: 5),
                                            Text(
                                              state
                                                          .productDetail
                                                          ?.isDeliveryAvailable ==
                                                      true
                                                  ? Labels.deliverable
                                                  : Labels.notDeliverable,
                                              style: TextStyle(
                                                letterSpacing: .5,
                                                color: Colors.white,
                                                fontWeight: FontWeight.w600,
                                                fontSize: 12,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: context.heightPct(.01)),
                                  Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
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
                                            fontSize: productNameFontSize,
                                          ),
                                        ),
                                      ),
                                      SizedBox(width: isTablet ? 15 : 10),
                                      if (getCurrentDiscountPercentage(
                                            product,
                                          ) >
                                          0)
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
                                              fontFamily:
                                                  FontFamily
                                                      .fontsPoppinsSemiBold,
                                              fontSize: discountFontSize,
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
                                            "${CurrencyIcon.currencyIcon}${getCurrentPrice(product).toStringAsFixed(1)}",
                                            style: TextStyle(
                                              fontFamily:
                                                  FontFamily
                                                      .fontsPoppinsSemiBold,
                                              color:
                                                  Theme.of(
                                                    context,
                                                  ).colorScheme.primary,
                                              fontSize: priceFontSize,
                                            ),
                                          ),
                                          SizedBox(
                                            width: context.widthPct(.02),
                                          ),
                                          if (getCurrentOriginalPrice(
                                                product,
                                              ) !=
                                              getCurrentPrice(product))
                                            Text(
                                              "${CurrencyIcon.currencyIcon}${getCurrentOriginalPrice(product).toStringAsFixed(2)}",
                                              style: TextStyle(
                                                fontFamily:
                                                    FontFamily
                                                        .fontsPoppinsLight,
                                                decoration:
                                                    TextDecoration.lineThrough,
                                                color:
                                                    Theme.of(
                                                      context,
                                                    ).colorScheme.onSecondary,
                                                fontSize:
                                                    isTablet
                                                        ? 14.0
                                                        : context.scaledFont(
                                                          12,
                                                        ),
                                              ),
                                            ),
                                        ],
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: context.heightPct(.02)),

                                  if (hasVariations) ...[
                                    ...variationsByParentType.entries.map((
                                      entry,
                                    ) {
                                      final parentType = entry.key;
                                      final variations = entry.value;

                                      // Collect all children from all variations in this parent type
                                      final List<String> allChildNames = [];
                                      final Map<String, String>
                                      childToParentMap =
                                          {}; // childName -> parentName

                                      for (final variation in variations) {
                                        for (final child
                                            in variation.children) {
                                          if (!allChildNames.contains(
                                            child.name,
                                          )) {
                                            allChildNames.add(child.name);
                                            childToParentMap[child.name] =
                                                variation.parentName;
                                          }
                                        }
                                      }

                                      // Find currently selected child for this parent type
                                      String? selectedChildForThisType;
                                      if (selectedVariationsByType.containsKey(
                                        parentType,
                                      )) {
                                        final typeMap =
                                            selectedVariationsByType[parentType]!;
                                        if (typeMap.isNotEmpty) {
                                          selectedChildForThisType =
                                              typeMap.values.first;
                                        }
                                      }

                                      // If no children, skip this parent type
                                      if (allChildNames.isEmpty) {
                                        return const SizedBox.shrink();
                                      }

                                      return Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          SizedBox(
                                            height: context.heightPct(.01),
                                          ),

                                          // Show child selector directly with parent type (parentOptionName) as label
                                          OptionSelectorWidget(
                                            name: parentType,
                                            options: allChildNames,
                                            selectedOption:
                                                selectedChildForThisType,
                                            onSelect: (value) {
                                              setState(() {
                                                // Initialize map for this parent type if it doesn't exist
                                                if (!selectedVariationsByType
                                                    .containsKey(parentType)) {
                                                  selectedVariationsByType[parentType] =
                                                      {};
                                                }

                                                // Clear previous selection for this parent type
                                                selectedVariationsByType[parentType]!
                                                    .clear();

                                                // Add new selection if value is not null
                                                if (value != null &&
                                                    childToParentMap
                                                        .containsKey(value)) {
                                                  final parentName =
                                                      childToParentMap[value]!;
                                                  selectedVariationsByType[parentType]![parentName] =
                                                      value;
                                                }
                                              });
                                            },
                                          ),
                                        ],
                                      );
                                    }).toList(),

                                    SizedBox(height: context.heightPct(.01)),
                                  ],

                                  SizedBox(
                                    height: imageHeight,
                                    child: ListView.separated(
                                      scrollDirection: Axis.horizontal,
                                      padding: EdgeInsets.all(
                                        isTablet ? 15 : 12,
                                      ),
                                      itemCount: product.images.length,
                                      separatorBuilder:
                                          (_, __) => SizedBox(
                                            width: isTablet ? 15 : 10,
                                          ),
                                      itemBuilder: (context, index) {
                                        return CustomImageView(
                                          onTap: () {
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder:
                                                    (context) =>
                                                        ImageGalleryViewer(
                                                          imageUrls:
                                                              product.images,
                                                          initialIndex: index,
                                                        ),
                                              ),
                                            );
                                          },
                                          radius: BorderRadius.circular(
                                            isTablet ? 12 : 10,
                                          ),
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
                                      color:
                                          Theme.of(
                                            context,
                                          ).colorScheme.onPrimary,
                                      borderRadius: BorderRadius.circular(
                                        isTablet ? 16 : 12,
                                      ),
                                      border: Border.all(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .outline
                                            .withValues(alpha: .3),
                                      ),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.grey.withValues(
                                            alpha: 0.1,
                                          ),
                                          spreadRadius: 1,
                                          blurRadius: 4,
                                          offset: const Offset(0, 2),
                                        ),
                                      ],
                                    ),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        SizedBox(height: isTablet ? 12 : 10),
                                        Padding(
                                          padding: EdgeInsets.symmetric(
                                            horizontal: isTablet ? 15.0 : 10.0,
                                          ),
                                          child: Text(
                                            Labels.description,
                                            style: TextStyle(
                                              fontFamily:
                                                  FontFamily
                                                      .fontsPoppinsSemiBold,
                                              color:
                                                  Theme.of(
                                                    context,
                                                  ).colorScheme.onSecondary,
                                              fontSize: isTablet ? 16 : 14,
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
                                          padding: EdgeInsets.symmetric(
                                            horizontal: isTablet ? 15.0 : 10.0,
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
                                              fontSize:
                                                  isTablet
                                                      ? 14
                                                      : context.scaledFont(12),
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
                                      fontFamily:
                                          FontFamily.fontsPoppinsSemiBold,
                                      color:
                                          Theme.of(
                                            context,
                                          ).colorScheme.onSecondary,
                                      fontSize: isTablet ? 16 : 14,
                                    ),
                                  ),
                                  SizedBox(height: isTablet ? 20 : 15),
                                  LayoutBuilder(
                                    builder: (context, innerConstraints) {
                                      double availableWidth =
                                          innerConstraints.maxWidth;

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
                                        padding: EdgeInsets.all(
                                          isTablet ? 12 : 0,
                                        ),
                                        child: StaggeredGrid.count(
                                          crossAxisCount: crossAxisCount,
                                          mainAxisSpacing: spacing,
                                          crossAxisSpacing: spacing,
                                          children: List.generate(
                                            product.relatedProducts.length,
                                            (index) {
                                              final relatedProduct =
                                                  product
                                                      .relatedProducts[index];
                                              return StaggeredGridTile.fit(
                                                crossAxisCellCount: 1,
                                                child: ProductBox(
                                                  isDeliverable: false,
                                                  marginPadding: const Padding(
                                                    padding: EdgeInsets.all(0),
                                                  ),
                                                  productWidth:
                                                      (availableWidth -
                                                              (spacing *
                                                                  (crossAxisCount -
                                                                      1))) /
                                                          crossAxisCount -
                                                      20,
                                                  productPrice:
                                                      relatedProduct.price,
                                                  productOriginalPrice:
                                                      relatedProduct
                                                          .originalPrice,
                                                  productCategory:
                                                      relatedProduct
                                                          .categoryName,
                                                  productRating: 4.0,
                                                  productId: relatedProduct.id,
                                                  onProductTap: () {
                                                    Navigator.pushReplacementNamed(
                                                      context,
                                                      RouteNames.productScreen,
                                                      arguments:
                                                          relatedProduct.id,
                                                    );
                                                  },
                                                  productImageUrl:
                                                      relatedProduct.imageUrl,
                                                  productTitle:
                                                      relatedProduct.name,
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
                                  padding: EdgeInsets.symmetric(
                                    horizontal: isTablet ? 20.0 : 15.0,
                                    vertical: isTablet ? 12.0 : 8.0,
                                  ),
                                  decoration: BoxDecoration(
                                    color:
                                        Theme.of(context).colorScheme.onPrimary,
                                    borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(
                                        isTablet ? 35 : 30,
                                      ),
                                      topRight: Radius.circular(
                                        isTablet ? 35 : 30,
                                      ),
                                    ),
                                    border: Border.all(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .primary
                                          .withValues(alpha: .3),
                                    ),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black.withValues(
                                          alpha: 0.1,
                                        ),
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
                                                  FontFamily
                                                      .fontsPoppinsSemiBold,
                                              color:
                                                  Theme.of(
                                                    context,
                                                  ).colorScheme.onSecondary,
                                              fontSize: isTablet ? 18 : 16,
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
                                                  size: isTablet ? 28 : 24,
                                                ),
                                              ),
                                              SizedBox(
                                                width: isTablet ? 12 : 10,
                                              ),
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
                                                  fontSize: isTablet ? 18 : 16,
                                                ),
                                              ),
                                              SizedBox(
                                                width: isTablet ? 12 : 10,
                                              ),
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
                                                  size: isTablet ? 28 : 24,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                      SizedBox(height: isTablet ? 12 : 10),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          IconButton(
                                            style: ButtonStyle(
                                              backgroundColor:
                                                  MaterialStateProperty.all(
                                                    state
                                                            .productDetail!
                                                            .isFavourite
                                                        ? Theme.of(
                                                          context,
                                                        ).colorScheme.primary
                                                        : Theme.of(context)
                                                            .colorScheme
                                                            .onSecondary
                                                            .withValues(
                                                              alpha: .3,
                                                            ),
                                                  ),
                                              minimumSize:
                                                  MaterialStateProperty.all(
                                                    Size(
                                                      isTablet ? 70 : 60,
                                                      isTablet ? 55 : 50,
                                                    ),
                                                  ),
                                              shape: MaterialStateProperty.all(
                                                RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(50),
                                                ),
                                              ),
                                            ),
                                            onPressed: () async {
                                              final isLoggedIn =
                                                  await UserRepository()
                                                      .isUserAuthenticated();

                                              if (!isLoggedIn) {
                                                await LoginRequiredBottomSheet.show(
                                                  context,
                                                );
                                                return;
                                              }
                                              final productDetailBloc =
                                                  context
                                                      .read<
                                                        ProductDetailBloc
                                                      >();
                                              final favouriteBloc =
                                                  context.read<FavouriteBloc>();

                                              final currentFav =
                                                  state
                                                      .productDetail!
                                                      .isFavourite;
                                              final productId =
                                                  state.productDetail!.id ?? '';

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
                                                backgroundColor:
                                                    MaterialStateProperty.all(
                                                      _areVariationsValid(
                                                            product,
                                                          )
                                                          ? Theme.of(
                                                            context,
                                                          ).colorScheme.primary
                                                          : Colors.grey
                                                              .withValues(
                                                                alpha: 0.6,
                                                              ),
                                                    ),
                                                minimumSize:
                                                    MaterialStateProperty.all(
                                                      Size(
                                                        250,
                                                        isTablet ? 55 : 50,
                                                      ),
                                                    ),
                                                shape: MaterialStateProperty.all(
                                                  RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                          50,
                                                        ),
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
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  Text(
                                                    Labels.addToCart,
                                                    style: TextStyle(
                                                      fontFamily:
                                                          FontFamily
                                                              .fontsPoppinsSemiBold,
                                                      color: Colors.white,
                                                      fontSize:
                                                          isTablet ? 17 : 15,
                                                    ),
                                                  ),
                                                  Text(
                                                    '${calculateTotalPrice(product, state.quantity).toStringAsFixed(1)} ${CurrencyIcon.currencyIcon}',
                                                    style: TextStyle(
                                                      fontFamily:
                                                          FontFamily
                                                              .fontsPoppinsSemiBold,
                                                      color: Colors.white,
                                                      fontSize:
                                                          isTablet ? 18 : 16,
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
                              backgroundColor:
                                  Theme.of(context).colorScheme.primary,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(100),
                              ),
                              mini: !isTablet,
                              onPressed: () async {
                                final isLoggedIn =
                                    await UserRepository()
                                        .isUserAuthenticated();
                                if (!isLoggedIn) {
                                  await LoginRequiredBottomSheet.show(context);
                                  return;
                                }
                                Navigator.pushNamed(
                                  context,
                                  RouteNames.cartScreen,
                                );
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
                                    borderRadius: BorderRadius.circular(
                                      isTablet ? 12 : 10,
                                    ),
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
