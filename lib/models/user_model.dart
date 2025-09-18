
class UserModel {
  bool? success;
  UserData? userData;
  String? message;

  UserModel({this.success, this.userData, this.message});

  UserModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    userData = json['user'] != null ? UserData.fromJson(json['user']) : null;
    message = json['message'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['success'] = success;
    if (userData != null) {
      data['user'] = userData!.toJson();
    }
    data['message'] = message;
    return data;
  }
}

class UserData {
  int? id;
  String? name;
  String? email;
  String? phoneNo;
  dynamic userDetails;

  UserData({
    this.id,
    this.name,
    this.email,
    this.phoneNo,
    this.userDetails,
  });
  UserData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    email = json['email'];
    phoneNo = json['phone_no'];
    userDetails = json['user_details'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['email'] = email;
    data['phone_no'] = phoneNo;
    data['user_details'] = userDetails;
    return data;
  }
}

