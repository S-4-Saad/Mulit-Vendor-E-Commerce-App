class OrderDetailModel {
  bool? success;
  String? message;
  Order? order;

  OrderDetailModel({this.success, this.message, this.order});

  OrderDetailModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    message = json['message'];
    order = json['order'] != null ? new Order.fromJson(json['order']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['success'] = this.success;
    data['message'] = this.message;
    if (this.order != null) {
      data['order'] = this.order!.toJson();
    }
    return data;
  }
}

class Order {
  int? id;
  String? placedOn;
  int? totalAmount;
  int? currentStep;
  List<Products>? products;
  ShippingAddress? shippingAddress;
  Summary? summary;

  Order(
      {this.id,
        this.placedOn,
        this.totalAmount,
        this.currentStep,
        this.products,
        this.shippingAddress,
        this.summary});

  Order.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    placedOn = json['placedOn'];
    totalAmount = json['totalAmount'];
    currentStep = json['currentStep'];
    if (json['products'] != null) {
      products = <Products>[];
      json['products'].forEach((v) {
        products!.add(new Products.fromJson(v));
      });
    }
    shippingAddress = json['shippingAddress'] != null
        ? new ShippingAddress.fromJson(json['shippingAddress'])
        : null;
    summary =
    json['summary'] != null ? new Summary.fromJson(json['summary']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['placedOn'] = this.placedOn;
    data['totalAmount'] = this.totalAmount;
    data['currentStep'] = this.currentStep;
    if (this.products != null) {
      data['products'] = this.products!.map((v) => v.toJson()).toList();
    }
    if (this.shippingAddress != null) {
      data['shippingAddress'] = this.shippingAddress!.toJson();
    }
    if (this.summary != null) {
      data['summary'] = this.summary!.toJson();
    }
    return data;
  }
}

class Products {
  bool? isReviewTaken;
  String? shopName;
  String? imageUrl;
  String? productName;
  String? variationParentName;
  String? variationChildName;
  String? price;
  String? originalPrice;

  Products(
      {this.isReviewTaken,
        this.shopName,
        this.imageUrl,
        this.productName,
        this.variationParentName,
        this.variationChildName,
        this.price,
        this.originalPrice});

  Products.fromJson(Map<String, dynamic> json) {
    isReviewTaken = json['isReviewTaken'];
    shopName = json['shopName'];
    imageUrl = json['imageUrl'];
    productName = json['productName'];
    variationParentName = json['variationParentName'];
    variationChildName = json['variationChildName'];
    price = json['price'];
    originalPrice = json['originalPrice'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['isReviewTaken'] = this.isReviewTaken;
    data['shopName'] = this.shopName;
    data['imageUrl'] = this.imageUrl;
    data['productName'] = this.productName;
    data['variationParentName'] = this.variationParentName;
    data['variationChildName'] = this.variationChildName;
    data['price'] = this.price;
    data['originalPrice'] = this.originalPrice;
    return data;
  }
}

class ShippingAddress {
  String? title;
  String? customerName;
  String? primaryPhone;
  String? secondaryPhone;
  String? fullAddress;

  ShippingAddress(
      {this.title,
        this.customerName,
        this.primaryPhone,
        this.secondaryPhone,
        this.fullAddress});

  ShippingAddress.fromJson(Map<String, dynamic> json) {
    title = json['title'];
    customerName = json['customerName'];
    primaryPhone = json['primaryPhone'];
    secondaryPhone = json['secondaryPhone'];
    fullAddress = json['fullAddress'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['title'] = this.title;
    data['customerName'] = this.customerName;
    data['primaryPhone'] = this.primaryPhone;
    data['secondaryPhone'] = this.secondaryPhone;
    data['fullAddress'] = this.fullAddress;
    return data;
  }
}

class Summary {
  String? itemTotal;
  String? deliveryFee;
  String? tax;
  String? total;
  String? itemQty;

  Summary(
      {this.itemTotal, this.deliveryFee, this.tax, this.total, this.itemQty});

  Summary.fromJson(Map<String, dynamic> json) {
    itemTotal = json['itemTotal'];
    deliveryFee = json['deliveryFee'];
    tax = json['tax'];
    total = json['total'];
    itemQty = json['itemQty'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['itemTotal'] = this.itemTotal;
    data['deliveryFee'] = this.deliveryFee;
    data['tax'] = this.tax;
    data['total'] = this.total;
    data['itemQty'] = this.itemQty;
    return data;
  }
}
