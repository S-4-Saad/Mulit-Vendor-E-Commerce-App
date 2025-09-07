import 'package:speezu/models/user_model.dart';

class FaqsModel {
  bool? success;
  List<Data>? data;
  String? message;

  FaqsModel({this.success, this.data, this.message});

  FaqsModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    if (json['data'] != null) {
      data = <Data>[];
      json['data'].forEach((v) {
        data!.add(new Data.fromJson(v));
      });
    }
    message = json['message'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['success'] = this.success;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    data['message'] = this.message;
    return data;
  }
}

class Data {
  int? id;
  String? question;
  String? answer;
  int? faqCategoryId;
  String? createdAt;
  String? updatedAt;
  List<CustomFields>? customFields;

  Data(
      {this.id,
        this.question,
        this.answer,
        this.faqCategoryId,
        this.createdAt,
        this.updatedAt,
        this.customFields});

  Data.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    question = json['question'];
    answer = json['answer'];
    faqCategoryId = json['faq_category_id'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    if (json['custom_fields'] != null) {
      customFields = <CustomFields>[];
      json['custom_fields'].forEach((v) {
        customFields!.add(new CustomFields.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['question'] = this.question;
    data['answer'] = this.answer;
    data['faq_category_id'] = this.faqCategoryId;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    if (this.customFields != null) {
      data['custom_fields'] =
          this.customFields!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}
