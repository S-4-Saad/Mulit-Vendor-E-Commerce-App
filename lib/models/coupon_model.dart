class CouponModel {
  bool? status;
  String? message;
  Data? data;

  CouponModel({this.status, this.message, this.data});

  CouponModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    data = json['data'] != null ? new Data.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['message'] = this.message;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    return data;
  }
}

class Data {
  int? id;
  String? code;
  String? type;
  int? value;
  int? minOrderAmount;
  int? maxDiscount;
  Null? storeId;
  String? startDate;
  String? endDate;
  int? maxUses;
  Null? usedCount;

  Data(
      {this.id,
        this.code,
        this.type,
        this.value,
        this.minOrderAmount,
        this.maxDiscount,
        this.storeId,
        this.startDate,
        this.endDate,
        this.maxUses,
        this.usedCount});

  Data.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    code = json['code'];
    type = json['type'];
    value = json['value'];
    minOrderAmount = json['min_order_amount'];
    maxDiscount = json['max_discount'];
    storeId = json['store_id'];
    startDate = json['start_date'];
    endDate = json['end_date'];
    maxUses = json['max_uses'];
    usedCount = json['used_count'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['code'] = this.code;
    data['type'] = this.type;
    data['value'] = this.value;
    data['min_order_amount'] = this.minOrderAmount;
    data['max_discount'] = this.maxDiscount;
    data['store_id'] = this.storeId;
    data['start_date'] = this.startDate;
    data['end_date'] = this.endDate;
    data['max_uses'] = this.maxUses;
    data['used_count'] = this.usedCount;
    return data;
  }
}
