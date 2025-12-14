import 'product_detail_model.dart';

class CartItem {
  final String id;
  final String productId;
  final String name;
  final String imageUrl;
  final double price;
  final double originalPrice;
  final int quantity;
  final String? variationParentName;
  final String? variationParentValue;
  final String? variationChildName;
  final String? variationChildValue;
  final String? variationParentId;
  final String? variationChildId;
  final String shopName;
  final String categoryName;
  final String storeId;
  final bool isDeliveryAvailable;

  CartItem({
    required this.id,
    required this.productId,
    required this.name,
    required this.imageUrl,
    required this.price,
    required this.originalPrice,
    required this.quantity,
    this.variationParentName,
    this.variationParentValue,
    this.variationChildName,
    this.variationChildValue,
    this.variationParentId,
    this.variationChildId,
    required this.shopName,
    required this.categoryName,
    required this.storeId,
    required this.isDeliveryAvailable,
  });

  // Calculate total price for this item
  double get totalPrice => price * quantity;

  // Calculate discount percentage
  double get discountPercentage {
    if (originalPrice <= 0) return 0;
    return ((originalPrice - price) / originalPrice) * 100;
  }

  // Create a copy with updated quantity
  CartItem copyWith({
    String? id,
    String? productId,
    String? name,
    String? imageUrl,
    double? price,
    double? originalPrice,
    int? quantity,
    String? variationParentName,
    String? variationParentValue,
    String? variationChildName,
    String? variationChildValue,
    String? variationParentId,
    String? variationChildId,
    String? shopName,
    String? categoryName,
    String? storeId,
    bool? isDeliveryAvailable,
  }) {
    return CartItem(
      id: id ?? this.id,
      productId: productId ?? this.productId,
      name: name ?? this.name,
      imageUrl: imageUrl ?? this.imageUrl,
      price: price ?? this.price,
      originalPrice: originalPrice ?? this.originalPrice,
      quantity: quantity ?? this.quantity,
      variationParentName: variationParentName ?? this.variationParentName,
      variationParentValue: variationParentValue ?? this.variationParentValue,
      variationChildName: variationChildName ?? this.variationChildName,
      variationChildValue: variationChildValue ?? this.variationChildValue,
      variationParentId: variationParentId ?? this.variationParentId,
      variationChildId: variationChildId ?? this.variationChildId,
      shopName: shopName ?? this.shopName,
      categoryName: categoryName ?? this.categoryName,
      storeId: storeId ?? this.storeId,
      isDeliveryAvailable: isDeliveryAvailable ?? this.isDeliveryAvailable,
    );
  }

  // Calculate the current price based on selected variations
  static double _getCurrentPrice(
    ProductDetail product, {
    String? variationParentValue,
    String? variationChildValue,
  }) {
    // If no variations, return base price
    if (product.variations.isEmpty) {
      return product.price;
    }

    // If no parent selected, return base price
    if (variationParentValue == null) {
      return product.price;
    }

    // Find the selected parent variation
    final selectedParentVariation = product.variations.firstWhere(
      (v) => v.parentName == variationParentValue,
      orElse: () => product.variations.first,
    );

    // If parent has children and child is selected, use child price
    if (selectedParentVariation.children.isNotEmpty &&
        variationChildValue != null) {
      final selectedChildVariation = selectedParentVariation.children
          .firstWhere(
            (child) => child.name == variationChildValue,
            orElse: () => selectedParentVariation.children.first,
          );
      return selectedChildVariation.price;
    }

    // If parent has no children or child not selected, use parent price
    return selectedParentVariation.parentPrice;
  }

  // Calculate the current original price based on selected variations
  static double _getCurrentOriginalPrice(
    ProductDetail product, {
    String? variationParentValue,
    String? variationChildValue,
  }) {
    // If no variations, return base original price
    if (product.variations.isEmpty) {
      return product.originalPrice;
    }

    // If no parent selected, return base original price
    if (variationParentValue == null) {
      return product.originalPrice;
    }

    // Find the selected parent variation
    final selectedParentVariation = product.variations.firstWhere(
      (v) => v.parentName == variationParentValue,
      orElse: () => product.variations.first,
    );

    // If parent has children and child is selected, use child original price
    if (selectedParentVariation.children.isNotEmpty &&
        variationChildValue != null) {
      final selectedChildVariation = selectedParentVariation.children
          .firstWhere(
            (child) => child.name == variationChildValue,
            orElse: () => selectedParentVariation.children.first,
          );
      return selectedChildVariation.originalPrice;
    }

    // If parent has no children or child not selected, use parent original price
    return selectedParentVariation.parentOriginalPrice;
  }

  // Convert from ProductDetail
  factory CartItem.fromProductDetail(
    ProductDetail product,
    int quantity, {
    String? variationParentName,
    String? variationParentValue,
    String? variationChildName,
    String? variationChildValue,
    String? variationParentId,
    String? variationChildId,
    String? storeId,
    double? calculatedPrice, // NEW: Pre-calculated price from product detail
    double?
    calculatedOriginalPrice, // NEW: Pre-calculated original price from product detail
    bool? isDeliveryAvailable, // NEW: Delivery status from product detail
  }) {
    // Create unique item ID using real server IDs
    final itemId =
        '${product.id}_${variationParentValue ?? ''}_${variationChildValue ?? ''}';

    // Use pre-calculated prices if provided, otherwise fall back to old logic
    final variationPrice =
        calculatedPrice ??
        _getCurrentPrice(
          product,
          variationParentValue: variationParentValue,
          variationChildValue: variationChildValue,
        );

    final variationOriginalPrice =
        calculatedOriginalPrice ??
        _getCurrentOriginalPrice(
          product,
          variationParentValue: variationParentValue,
          variationChildValue: variationChildValue,
        );

    return CartItem(
      id: itemId,
      productId: product.id, // Real server product ID
      name: product.name,
      imageUrl: product.thumbnail,
      price: variationPrice,
      originalPrice: variationOriginalPrice,
      quantity: quantity,
      variationParentName: variationParentName,
      variationParentValue: variationParentValue,
      variationChildName: variationChildName,
      variationChildValue: variationChildValue,
      variationParentId: variationParentId,
      variationChildId: variationChildId,
      shopName: product.shopName,
      categoryName: product.categoryName,
      storeId: storeId ?? product.shop.id.toString(), // Real server store ID
      isDeliveryAvailable: isDeliveryAvailable ?? product.isDeliveryAvailable,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is CartItem &&
        other.id == id &&
        other.productId == productId &&
        other.variationParentValue == variationParentValue &&
        other.variationChildValue == variationChildValue;
  }

  @override
  int get hashCode {
    return Object.hash(
      id,
      productId,
      variationParentValue,
      variationChildValue,
    );
  }

  // Convert to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'productId': productId,
      'name': name,
      'imageUrl': imageUrl,
      'price': price,
      'originalPrice': originalPrice,
      'quantity': quantity,
      'variationParentName': variationParentName,
      'variationParentValue': variationParentValue,
      'variationChildName': variationChildName,
      'variationChildValue': variationChildValue,
      'variationParentId': variationParentId,
      'variationChildId': variationChildId,
      'shopName': shopName,
      'categoryName': categoryName,
      'storeId': storeId,
      'isDeliveryAvailable': isDeliveryAvailable,
    };
  }

  // Create from JSON
  factory CartItem.fromJson(Map<String, dynamic> json) {
    return CartItem(
      id: json['id'] ?? '',
      productId: json['productId'] ?? '',
      name: json['name'] ?? '',
      imageUrl: json['imageUrl'] ?? '',
      price: (json['price'] ?? 0.0).toDouble(),
      originalPrice: (json['originalPrice'] ?? 0.0).toDouble(),
      quantity: json['quantity'] ?? 0,
      variationParentName: json['variationParentName'],
      variationParentValue: json['variationParentValue'],
      variationChildName: json['variationChildName'],
      variationChildValue: json['variationChildValue'],
      variationParentId: json['variationParentId'],
      variationChildId: json['variationChildId'],
      shopName: json['shopName'] ?? '',
      categoryName: json['categoryName'] ?? '',
      storeId: json['storeId'] ?? '',
      isDeliveryAvailable: json['isDeliveryAvailable'] ?? true,
    );
  }

  @override
  String toString() {
    return 'CartItem(id: $id, name: $name, quantity: $quantity, price: $price)';
  }
}

class Cart {
  final List<CartItem> items;
  final double deliveryFee;
  final double taxRate; // Tax rate as percentage (e.g., 10.0 for 10%)
  final double? couponDiscount;

  const Cart({
    this.items = const [],
    this.deliveryFee = 0.0,
    this.taxRate = 0.0,
    this.couponDiscount,
  });

  // 🧮 Get total items count
  int get totalItems => items.fold(0, (sum, item) => sum + item.quantity);

  // 🧾 Get subtotal (items total without tax and delivery)
  double get subtotal => items.fold(0.0, (sum, item) => sum + item.totalPrice);

  // 💸 Get tax amount
  double get taxAmount => subtotal * (taxRate / 100);

  // ✅ Get total amount (already includes discount)
  double get totalAmount {
    final discount = couponDiscount ?? 0.0;
    final total = subtotal + taxAmount + deliveryFee - discount;
    return total < 0 ? 0 : total; // Never go below zero
  }

  // 🛒 Check if cart is empty
  bool get isEmpty => items.isEmpty;
  bool get isNotEmpty => items.isNotEmpty;

  // 🏪 Get unique shops count
  int get uniqueShopsCount => items.map((item) => item.shopName).toSet().length;

  // 🏬 Get current store ID (from first item)
  String? get currentStoreId => items.isEmpty ? null : items.first.storeId;

  // 🚚 Get current delivery status (from first item)
  bool? get currentDeliveryStatus =>
      items.isEmpty ? null : items.first.isDeliveryAvailable;

  // 🏷️ Check if cart has items from a specific store
  bool hasItemsFromStore(String storeId) =>
      items.any((item) => item.storeId == storeId);

  // 🔢 Get items count for a specific store
  int getItemCountForStore(String storeId) =>
      items.where((item) => item.storeId == storeId).length;

  // 🧩 Copy with updates
  Cart copyWith({
    List<CartItem>? items,
    double? deliveryFee,
    double? taxRate,
    double? couponDiscount,
  }) {
    return Cart(
      items: items ?? this.items,
      deliveryFee: deliveryFee ?? this.deliveryFee,
      taxRate: taxRate ?? this.taxRate,
      couponDiscount: couponDiscount ?? this.couponDiscount,
    );
  }

  // 🔄 Convert to JSON
  Map<String, dynamic> toJson() {
    return {
      'items': items.map((item) => item.toJson()).toList(),
      'deliveryFee': deliveryFee,
      'taxRate': taxRate,
      'couponDiscount': couponDiscount,
    };
  }

  // 🏗️ Create from JSON
  factory Cart.fromJson(Map<String, dynamic> json) {
    return Cart(
      items:
          (json['items'] as List<dynamic>?)
              ?.map((item) => CartItem.fromJson(item as Map<String, dynamic>))
              .toList() ??
          [],
      deliveryFee: (json['deliveryFee'] ?? 0.0).toDouble(),
      taxRate: (json['taxRate'] ?? 0.0).toDouble(),
      couponDiscount: (json['couponDiscount'] ?? 0.0).toDouble(),
    );
  }

  @override
  String toString() {
    return 'Cart(items: ${items.length}, totalItems: $totalItems, totalAmount: $totalAmount, couponDiscount: $couponDiscount)';
  }
}
