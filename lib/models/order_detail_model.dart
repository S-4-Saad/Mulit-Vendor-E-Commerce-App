class OrderDetailModel {
  final int id;
  final String placedOn;
  final double totalAmount;
  final List<OrderDetailProduct> products;
  final OrderDetailAddress shippingAddress;
  final OrderDetailSummary summary;
  final int currentStep;

  OrderDetailModel({
    required this.id,
    required this.placedOn,
    required this.totalAmount,
    required this.products,
    required this.shippingAddress,
    required this.summary,
    required this.currentStep,
  });

  factory OrderDetailModel.fromJson(Map<String, dynamic> json) {
    return OrderDetailModel(
      id: json['id'],
      placedOn: json['placedOn'],
      totalAmount: (json['totalAmount'] as num).toDouble(),
      products: (json['products'] as List)
          .map((p) => OrderDetailProduct.fromJson(p))
          .toList(),
      shippingAddress: OrderDetailAddress.fromJson(json['shippingAddress']),
      summary: OrderDetailSummary.fromJson(json['summary']),
      currentStep: json['currentStep'],
    );
  }
}

class OrderDetailProduct {
  final String shopName;
  final String imageUrl;
  final String productName;
  final String variationParentName;
  final String variationParentValue;
  final String variationChildName;
  final String variationChildValue;
  final String price;
  final String originalPrice;
  final bool isReviewTaken;

  OrderDetailProduct({
    required this.shopName,
    required this.imageUrl,
    required this.productName,
    required this.variationParentName,
    required this.variationParentValue,
    required this.variationChildName,
    required this.variationChildValue,
    required this.price,
    required this.originalPrice,
    required this.isReviewTaken,
  });

  factory OrderDetailProduct.fromJson(Map<String, dynamic> json) {
    return OrderDetailProduct(
      shopName: json['shopName'],
      imageUrl: json['imageUrl'],
      productName: json['productName'],
      variationParentName: json['variationParentName'],
      variationParentValue: json['variationParentValue'],
      variationChildName: json['variationChildName'],
      variationChildValue: json['variationChildValue'],
      price: json['price'],
      originalPrice: json['originalPrice'],
      isReviewTaken: json['isReviewTaken'] ?? false,
    );
  }
}

class OrderDetailAddress {
  final String title;
  final String customerName;
  final String primaryPhone;
  final String secondaryPhone;
  final String fullAddress;

  OrderDetailAddress({
    required this.title,
    required this.customerName,
    required this.primaryPhone,
    required this.secondaryPhone,
    required this.fullAddress,
  });

  factory OrderDetailAddress.fromJson(Map<String, dynamic> json) {
    return OrderDetailAddress(
      title: json['title'],
      customerName: json['customerName'],
      primaryPhone: json['primaryPhone'],
      secondaryPhone: json['secondaryPhone'],
      fullAddress: json['fullAddress'],
    );
  }
}

class OrderDetailSummary {
  final String itemTotal;
  final String deliveryFee;
  final String tax;
  final String total;
  final String itemQty;

  OrderDetailSummary({
    required this.itemTotal,
    required this.deliveryFee,
    required this.tax,
    required this.total,
    required this.itemQty,
  });

  factory OrderDetailSummary.fromJson(Map<String, dynamic> json) {
    return OrderDetailSummary(
      itemTotal: json['itemTotal'],
      deliveryFee: json['deliveryFee'],
      tax: json['tax'],
      total: json['total'],
      itemQty: json['itemQty'],
    );
  }
}
