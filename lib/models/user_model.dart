import 'package:speezu/models/media_model.dart';

class UserModel {
  bool? success;
  UserData? userData;
  String? message;

  UserModel({this.success, this.userData, this.message});

  UserModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    userData = json['data'] != null ? new UserData.fromJson(json['data']) : null;
    message = json['message'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['success'] = this.success;
    if (this.userData != null) {
      data['data'] = this.userData!.toJson();
    }
    data['message'] = this.message;
    return data;
  }
}

class UserData {
  int? id;
  String? name;
  String? email;
  String? apiToken;
  String? deviceToken;
  Null? stripeId;
  Null? cardBrand;
  Null? cardLastFour;
  Null? trialEndsAt;
  Null? braintreeId;
  Null? paypalEmail;
  String? createdAt;
  String? updatedAt;
  CustomFields? customFields;
  bool? hasMedia;
  List<MediaModel>? media;

  UserData(
      {this.id,
        this.name,
        this.email,
        this.apiToken,
        this.deviceToken,
        this.stripeId,
        this.cardBrand,
        this.cardLastFour,
        this.trialEndsAt,
        this.braintreeId,
        this.paypalEmail,
        this.createdAt,
        this.updatedAt,
        this.customFields,
        this.hasMedia,
        this.media});
  UserData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    email = json['email'];
    apiToken = json['api_token'];
    deviceToken = json['device_token'];
    stripeId = json['stripe_id'];
    cardBrand = json['card_brand'];
    cardLastFour = json['card_last_four'];
    trialEndsAt = json['trial_ends_at'];
    braintreeId = json['braintree_id'];
    paypalEmail = json['paypal_email'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];

    // ✅ Fix custom_fields parsing
    if (json['custom_fields'] != null && json['custom_fields'] is Map<String, dynamic>) {
      customFields = CustomFields.fromJson(json['custom_fields']);
    } else {
      customFields = null;
    }

    hasMedia = json['has_media'];

    // ✅ media is safe, you already parse as List
    if (json['media'] != null) {
      media = <MediaModel>[];
      json['media'].forEach((v) {
        media!.add(MediaModel.fromJSON(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['email'] = this.email;
    data['api_token'] = this.apiToken;
    data['device_token'] = this.deviceToken;
    data['stripe_id'] = this.stripeId;
    data['card_brand'] = this.cardBrand;
    data['card_last_four'] = this.cardLastFour;
    data['trial_ends_at'] = this.trialEndsAt;
    data['braintree_id'] = this.braintreeId;
    data['paypal_email'] = this.paypalEmail;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    if (this.customFields != null) {
      data['custom_fields'] = this.customFields!.toJson();
    }
    data['has_media'] = this.hasMedia;
    if (this.media != null) {
      data['media'] = this.media!.map((v) => v.toMap()).toList();
    }
    return data;
  }
}

class CustomFields {
  Phone? phone;
  Phone? bio;
  Phone? address;
  Phone? verifiedPhone;
  Latitude? latitude;
  Latitude? longitude;

  CustomFields(
      {this.phone,
        this.bio,
        this.address,
        this.verifiedPhone,
        this.latitude,
        this.longitude});

  CustomFields.fromJson(Map<String, dynamic> json) {
    phone = json['phone'] != null ? new Phone.fromJson(json['phone']) : null;
    bio = json['bio'] != null ? new Phone.fromJson(json['bio']) : null;
    address =
    json['address'] != null ? new Phone.fromJson(json['address']) : null;
    verifiedPhone = json['verifiedPhone'] != null
        ? new Phone.fromJson(json['verifiedPhone'])
        : null;
    latitude = json['latitude'] != null
        ? new Latitude.fromJson(json['latitude'])
        : null;
    longitude = json['longitude'] != null
        ? new Latitude.fromJson(json['longitude'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.phone != null) {
      data['phone'] = this.phone!.toJson();
    }
    if (this.bio != null) {
      data['bio'] = this.bio!.toJson();
    }
    if (this.address != null) {
      data['address'] = this.address!.toJson();
    }
    if (this.verifiedPhone != null) {
      data['verifiedPhone'] = this.verifiedPhone!.toJson();
    }
    if (this.latitude != null) {
      data['latitude'] = this.latitude!.toJson();
    }
    if (this.longitude != null) {
      data['longitude'] = this.longitude!.toJson();
    }
    return data;
  }
}

class Phone {
  String? value;
  String? view;
  String? name;

  Phone({this.value, this.view, this.name});

  Phone.fromJson(Map<String, dynamic> json) {
    value = json['value'];
    view = json['view'];
    name = json['name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['value'] = this.value;
    data['view'] = this.view;
    data['name'] = this.name;
    return data;
  }
}

class Latitude {
  Null? value;
  Null? view;
  String? name;

  Latitude({this.value, this.view, this.name});

  Latitude.fromJson(Map<String, dynamic> json) {
    value = json['value'];
    view = json['view'];
    name = json['name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['value'] = this.value;
    data['view'] = this.view;
    data['name'] = this.name;
    return data;
  }
}
