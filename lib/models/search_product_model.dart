class SearchModel {
  bool? success;
  String? message;
  Data? data;

  SearchModel({this.success, this.message, this.data});

  SearchModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    message = json['message'];
    data = json['data'] != null ? new Data.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['success'] = this.success;
    data['message'] = this.message;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    return data;
  }
}

class Data {
  List<Products>? products;
  List<Stores>? stores;

  Data({this.products, this.stores});

  Data.fromJson(Map<String, dynamic> json) {
    if (json['products'] != null) {
      products = <Products>[];
      json['products'].forEach((v) {
        products!.add(new Products.fromJson(v));
      });
    }
    if (json['stores'] != null) {
      stores = <Stores>[];
      json['stores'].forEach((v) {
        stores!.add(new Stores.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.products != null) {
      data['products'] = this.products!.map((v) => v.toJson()).toList();
    }
    if (this.stores != null) {
      data['stores'] = this.stores!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Products {
  int? id;
  int? categoryId;
  int? storeId;
  String? productName;
  String? productPrice;
  String? productDiscount;
  String? productDiscountedPrice;
  String? productImage;
  String? productRating;
  String? productDescription;
  bool?  isDeliverable;
  Store? store;
  Store? category;

  Products(
      {this.id,
        this.categoryId,
        this.storeId,
        this.productName,
        this.productPrice,
        this.productDiscount,
        this.productDiscountedPrice,
        this.productImage,
        this.productRating,
        this.productDescription,
        this.isDeliverable,
        this.store,
        this.category});

  Products.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    categoryId = json['category_id'];
    storeId = json['store_id'];
    productName = json['product_name'];
    productPrice = json['product_price'];
    productDiscount = json['product_discount'];
    productDiscountedPrice = json['product_discounted_price'];
    productImage = json['product_image'];
    productRating = json['product_rating'];
    productDescription = json['product_description'];
    isDeliverable = json['is_deliverable'] == 1;
    store = json['store'] != null ? new Store.fromJson(json['store']) : null;
    category =
    json['category'] != null ? new Store.fromJson(json['category']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['category_id'] = this.categoryId;
    data['store_id'] = this.storeId;
    data['product_name'] = this.productName;
    data['product_price'] = this.productPrice;
    data['product_discount'] = this.productDiscount;
    data['product_discounted_price'] = this.productDiscountedPrice;
    data['product_image'] = this.productImage;
    data['product_rating'] = this.productRating;
    data['product_description'] = this.productDescription;
    data['is_deliverable'] = this.isDeliverable;
    if (this.store != null) {
      data['store'] = this.store!.toJson();
    }
    if (this.category != null) {
      data['category'] = this.category!.toJson();
    }
    return data;
  }
}

class Store {
  int? id;
  String? name;
  String? image;

  Store({this.id, this.name, this.image});

  Store.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    image = json['image'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['image'] = this.image;
    return data;
  }
}

class Stores {
  int? id;
  String? name;
  String? image;
  bool? isDelivery; // ✅ changed to bool
  bool? isOpen; // ✅ changed to bool
  String? latitude;
  String? longitude;
  String? description;
  String? rating;
  String? openingTime;
  String? closingTime;

  Stores({
    this.id,
    this.name,
    this.image,
    this.isDelivery,
    this.isOpen,
    this.latitude,
    this.longitude,
    this.description,
    this.rating,
    this.openingTime,
    this.closingTime,
  });

  /// ✅ Safely convert int (1/0) from API to bool
  Stores.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    image = json['image'];
    isDelivery = (json['is_delivery'] == 1 || json['is_delivery'] == true);
    isOpen = (json['is_open'] == 1 || json['is_open'] == true);
    latitude = json['latitude'];
    longitude = json['longitude'];
    description = json['description'];
    rating = json['rating'];
    openingTime = json['opening_time'];
    closingTime = json['closing_time'];
  }

  /// ✅ Convert bool back to int (1 = true, 0 = false)
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['id'] = id;
    data['name'] = name;
    data['image'] = image;
    data['is_delivery'] = (isDelivery == true ? 1 : 0);
    data['is_open'] = (isOpen == true ? 1 : 0);
    data['latitude'] = latitude;
    data['longitude'] = longitude;
    data['description'] = description;
    data['rating'] = rating;
    data['opening_time'] = openingTime;
    data['closing_time'] = closingTime;
    return data;
  }
}

