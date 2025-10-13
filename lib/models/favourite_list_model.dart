class FavouriteListModel {
  String? status;
  List<Data>? data;

  FavouriteListModel({this.status, this.data});

  FavouriteListModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    if (json['data'] != null) {
      data = <Data>[];
      json['data'].forEach((v) {
        data!.add(Data.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> result = {};
    result['status'] = status;
    if (data != null) {
      result['data'] = data!.map((v) => v.toJson()).toList();
    }
    return result;
  }

  /// ✅ copyWith
  FavouriteListModel copyWith({
    String? status,
    List<Data>? data,
  }) {
    return FavouriteListModel(
      status: status ?? this.status,
      data: data ?? List<Data>.from(this.data ?? []),
    );
  }
}

class Data {
  int? id;
  int? userId;
  int? productId;
  dynamic storeId;
  String? createdAt;
  String? updatedAt;
  Product? product;

  Data({
    this.id,
    this.userId,
    this.productId,
    this.storeId,
    this.createdAt,
    this.updatedAt,
    this.product,
  });

  Data.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId = json['user_id'];
    productId = json['product_id'];
    storeId = json['store_id'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    product = json['product'] != null ? Product.fromJson(json['product']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> result = {};
    result['id'] = id;
    result['user_id'] = userId;
    result['product_id'] = productId;
    result['store_id'] = storeId;
    result['created_at'] = createdAt;
    result['updated_at'] = updatedAt;
    if (product != null) {
      result['product'] = product!.toJson();
    }
    return result;
  }

  /// ✅ copyWith
  Data copyWith({
    int? id,
    int? userId,
    int? productId,
    dynamic storeId,
    String? createdAt,
    String? updatedAt,
    Product? product,
  }) {
    return Data(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      productId: productId ?? this.productId,
      storeId: storeId ?? this.storeId,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      product: product ?? this.product,
    );
  }
}

class Product {
  int? id;
  int? categoryId;
  int? storeId;
  String? productName;
  String? productPrice;
  String? productDiscount;
  String? productDiscountedPrice;
  String? productImage;
  String? productMoreImages;
  String? productRating;
  String? productDescription;
  int? status;
  String? createdAt;
  String? updatedAt;

  Product({
    this.id,
    this.categoryId,
    this.storeId,
    this.productName,
    this.productPrice,
    this.productDiscount,
    this.productDiscountedPrice,
    this.productImage,
    this.productMoreImages,
    this.productRating,
    this.productDescription,
    this.status,
    this.createdAt,
    this.updatedAt,
  });

  Product.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    categoryId = json['category_id'];
    storeId = json['store_id'];
    productName = json['product_name'];
    productPrice = json['product_price'];
    productDiscount = json['product_discount'];
    productDiscountedPrice = json['product_discounted_price'];
    productImage = json['product_image'];
    productMoreImages = json['product_more_images'];
    productRating = json['product_rating'];
    productDescription = json['product_description'];
    status = json['status'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> result = {};
    result['id'] = id;
    result['category_id'] = categoryId;
    result['store_id'] = storeId;
    result['product_name'] = productName;
    result['product_price'] = productPrice;
    result['product_discount'] = productDiscount;
    result['product_discounted_price'] = productDiscountedPrice;
    result['product_image'] = productImage;
    result['product_more_images'] = productMoreImages;
    result['product_rating'] = productRating;
    result['product_description'] = productDescription;
    result['status'] = status;
    result['created_at'] = createdAt;
    result['updated_at'] = updatedAt;
    return result;
  }

  /// ✅ copyWith
  Product copyWith({
    int? id,
    int? categoryId,
    int? storeId,
    String? productName,
    String? productPrice,
    String? productDiscount,
    String? productDiscountedPrice,
    String? productImage,
    String? productMoreImages,
    String? productRating,
    String? productDescription,
    int? status,
    String? createdAt,
    String? updatedAt,
  }) {
    return Product(
      id: id ?? this.id,
      categoryId: categoryId ?? this.categoryId,
      storeId: storeId ?? this.storeId,
      productName: productName ?? this.productName,
      productPrice: productPrice ?? this.productPrice,
      productDiscount: productDiscount ?? this.productDiscount,
      productDiscountedPrice:
      productDiscountedPrice ?? this.productDiscountedPrice,
      productImage: productImage ?? this.productImage,
      productMoreImages: productMoreImages ?? this.productMoreImages,
      productRating: productRating ?? this.productRating,
      productDescription: productDescription ?? this.productDescription,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
