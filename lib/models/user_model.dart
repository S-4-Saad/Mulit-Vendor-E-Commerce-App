import 'dart:convert';
import 'dart:developer';
import 'user_details_model.dart';
import 'address_model.dart';
import 'card_details_model.dart';

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
  UserDetailsModel? userDetails;
  String? profileImage;

  UserData({
    this.id,
    this.name,
    this.email,
    this.phoneNo,
    this.userDetails,
    this.profileImage,
  });
  UserData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    email = json['email'];
    phoneNo = json['phone_no'];

    // Parse user_details - it can be a Map, String (JSON), or UserDetailsModel
    if (json['user_details'] != null) {
      if (json['user_details'] is Map<String, dynamic>) {
        userDetails = UserDetailsModel.fromJson(json['user_details']);
      } else if (json['user_details'] is String) {
        // If it's a JSON string, parse it
        final String userDetailsString = json['user_details'];
        if (userDetailsString.trim().isEmpty || userDetailsString == 'null') {
          userDetails = UserDetailsModel();
        } else {
          try {
            final Map<String, dynamic> parsedJson = jsonDecode(
              userDetailsString,
            );
            userDetails = UserDetailsModel.fromJson(parsedJson);
          } catch (e) {
            log("Error parsing user_details JSON string: $e");
            userDetails =
                UserDetailsModel(); // Fallback to empty UserDetailsModel
          }
        }
      } else {
        // If it's already a UserDetailsModel instance, assign directly
        userDetails = json['user_details'];
      }
    } else {
      userDetails = UserDetailsModel();
    }

    profileImage = json['profile_picture'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['email'] = email;
    data['phone_no'] = phoneNo;
    data['user_details'] = userDetails?.toJson();
    data['profile_picture'] = profileImage;
    return data;
  }

  // Helper methods for easier access to user details
  List<AddressModel>? get deliveryAddresses => userDetails?.deliveryAddresses;
  CardDetailsModel? get cardDetails => userDetails?.cardDetails;

  void addAddress(AddressModel address) => userDetails?.addAddress(address);
  void setCard(CardDetailsModel card) => userDetails?.setCard(card);
  void setDefaultAddress(String addressId) =>
      userDetails?.setDefaultAddress(addressId);
}
