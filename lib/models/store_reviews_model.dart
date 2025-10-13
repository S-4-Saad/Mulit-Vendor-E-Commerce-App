class ShopReviewsModel {
  bool? success;
  String? message;
  List<Reviews>? reviews;

  ShopReviewsModel({this.success, this.message, this.reviews});

  ShopReviewsModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    message = json['message'];
    if (json['reviews'] != null) {
      reviews = <Reviews>[];
      json['reviews'].forEach((v) {
        reviews!.add(new Reviews.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['success'] = this.success;
    data['message'] = this.message;
    if (this.reviews != null) {
      data['reviews'] = this.reviews!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Reviews {
  int? reviewId;
  String? userName;
  String? rating;
  String? reviewText;
  String? orderAmount;
  String? createdAt;

  Reviews(
      {this.reviewId,
        this.userName,
        this.rating,
        this.reviewText,
        this.orderAmount,
        this.createdAt});

  Reviews.fromJson(Map<String, dynamic> json) {
    reviewId = json['reviewId'];
    userName = json['userName'];
    rating = json['rating'];
    reviewText = json['reviewText'];
    orderAmount = json['orderAmount'];
    createdAt = json['createdAt'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['reviewId'] = this.reviewId;
    data['userName'] = this.userName;
    data['rating'] = this.rating;
    data['reviewText'] = this.reviewText;
    data['orderAmount'] = this.orderAmount;
    data['createdAt'] = this.createdAt;
    return data;
  }
}
