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
  final String shopName;
  final String categoryName;
  final String storeId;

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
    required this.shopName,
    required this.categoryName,
    required this.storeId,
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
    String? shopName,
    String? categoryName,
    String? storeId,
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
      shopName: shopName ?? this.shopName,
      categoryName: categoryName ?? this.categoryName,
      storeId: storeId ?? this.storeId,
    );
  }

  // Convert from ProductDetail
  factory CartItem.fromProductDetail(
    ProductDetail product,
    int quantity, {
    String? variationParentName,
    String? variationParentValue,
    String? variationChildName,
    String? variationChildValue,
    String? storeId,
  }) {
    // Create unique item ID using real server IDs
    final itemId = '${product.id}_${variationParentValue ?? ''}_${variationChildValue ?? ''}';
    
    return CartItem(
      id: itemId,
      productId: product.id, // Real server product ID
      name: product.name,
      imageUrl: product.thumbnail,
      price: product.price,
      originalPrice: product.originalPrice,
      quantity: quantity,
      variationParentName: variationParentName,
      variationParentValue: variationParentValue,
      variationChildName: variationChildName,
      variationChildValue: variationChildValue,
      shopName: product.shopName,
      categoryName: product.categoryName,
      storeId: storeId ?? product.shop.id.toString(), // Real server store ID
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
    return Object.hash(id, productId, variationParentValue, variationChildValue);
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

  const Cart({
    this.items = const [],
    this.deliveryFee = 0.0,
    this.taxRate = 0.0,
  });

  // Get total items count
  int get totalItems => items.fold(0, (sum, item) => sum + item.quantity);

  // Get subtotal (items total without tax and delivery)
  double get subtotal => items.fold(0.0, (sum, item) => sum + item.totalPrice);

  // Get tax amount
  double get taxAmount => subtotal * (taxRate / 100);

  // Get total amount including tax and delivery
  double get totalAmount => subtotal + taxAmount + deliveryFee;

  // Check if cart is empty
  bool get isEmpty => items.isEmpty;

  // Check if cart is not empty
  bool get isNotEmpty => items.isNotEmpty;

  // Get unique shops count
  int get uniqueShopsCount {
    final shops = items.map((item) => item.shopName).toSet();
    return shops.length;
  }

  // Get current store ID (from first item if cart is not empty)
  String? get currentStoreId {
    if (items.isEmpty) return null;
    return items.first.storeId;
  }

  // Check if cart has items from a specific store
  bool hasItemsFromStore(String storeId) {
    return items.any((item) => item.storeId == storeId);
  }

  // Get items count for a specific store
  int getItemCountForStore(String storeId) {
    return items.where((item) => item.storeId == storeId).length;
  }

  // Create a copy with updated items
  Cart copyWith({
    List<CartItem>? items,
    double? deliveryFee,
    double? taxRate,
  }) {
    return Cart(
      items: items ?? this.items,
      deliveryFee: deliveryFee ?? this.deliveryFee,
      taxRate: taxRate ?? this.taxRate,
    );
  }

  @override
  String toString() {
    return 'Cart(items: ${items.length}, totalItems: $totalItems, totalAmount: $totalAmount)';
  }
}
