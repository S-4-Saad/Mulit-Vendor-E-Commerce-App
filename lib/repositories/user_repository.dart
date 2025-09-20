import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'package:speezu/models/user_model.dart';
import '../core/services/localStorage/my-local-controller.dart';
import '../core/utils/constants.dart';
import '../core/services/urls.dart';
import '../core/services/api_services.dart';
import '../models/address_model.dart';
import '../models/card_details_model.dart';
import '../models/user_details_model.dart';

class UserRepository {
  static final UserRepository _instance = UserRepository._internal();
  factory UserRepository() => _instance;

  UserRepository._internal();

  Future<void> init() async {
    await loadInitialData();
  }

  UserModel? _currentUser;
  final StreamController<UserModel?> _userController = StreamController<UserModel?>.broadcast();

  UserModel? get currentUser => _currentUser;
  
  Stream<UserModel?> get userStream => _userController.stream;

  Future<UserModel?> loadInitialData() async {
    try {
      final savedUserData = await LocalStorage.getData(key: AppKeys.userData);

      if (savedUserData != null) {
        _currentUser = UserModel.fromJson(jsonDecode(savedUserData));
        log("UserModel successfully decoded: ${_currentUser!.toJson()}");
        return _currentUser;
      } else {
        log("No user data found, returning null.");
        return null;
      }
    } catch (e) {
      log("Error loading data: $e");
      return null;
    }
  }

  Future<void> setUser(UserModel user) async {
    _currentUser = user;
    await LocalStorage.saveData(
      key: AppKeys.userData,
      value: jsonEncode(user.toJson()),
    );
    _userController.add(_currentUser); // Notify listeners
  }

  Future<void> clearUser() async {
    _currentUser = null;
    await LocalStorage.removeData(key: AppKeys.userData);
    _userController.add(null); // Notify listeners
  }

  void dispose() {
    _userController.close();
  }

  // User Details Management Methods
  Future<bool> updateBasicProfile({
    String? name,
    String? phoneNo,
    String? profilePicture,
  }) async {
    if (_currentUser?.userData == null) return false;
    
    // Prepare the request data
    Map<String, dynamic> requestData = {
      'user_id': _currentUser!.userData!.id,
    };
    
    // Add fields only if they are provided
    if (name != null) requestData['name'] = name;
    if (phoneNo != null) requestData['phone_no'] = phoneNo;
    if (profilePicture != null) requestData['profile_picture'] = profilePicture;
    
    // Always include user_details JSON (even if empty)
    requestData['user_details'] = _currentUser!.userData!.userDetails?.toJson() ?? {};
    
    // Use Completer to wait for the callback
    final completer = Completer<bool>();
    
    await ApiService.postMethod(
      apiUrl: updateUserDetailsUrl,
      postData: requestData,
      authHeader: true,
      executionMethod: (success, responseData) async {
        if (success && responseData['success'] == true) {
          log("Basic profile update API success: ${responseData['message']}");
          
          // Parse the updated user data from response
          final updatedUser = UserModel.fromJson(responseData);
          
          // Update the current user with the response data
          _currentUser = updatedUser;
          
          // Save the updated user data locally
          await setUser(_currentUser!);
          
          log("Basic profile updated successfully on server and locally");
          completer.complete(true);
        } else {
          log("API returned success: false - ${responseData['message']}");
          completer.complete(false);
        }
      },
    );
    
    return await completer.future;
  }

  Future<bool> updateUserDetailsOnServer() async {
    if (_currentUser?.userData == null) return false;
    
    // Prepare the request data
    final requestData = {
      'user_id': _currentUser!.userData!.id,
      'user_details': _currentUser!.userData!.userDetails?.toJson(),
    };

    log("Updating user details on server: ${jsonEncode(requestData)}");
    
    bool apiSuccess = false;
    
    // Make API call using consistent ApiService pattern
    await ApiService.postMethod(
      apiUrl: updateUserDetailsUrl,
      postData: requestData,
      authHeader: true, // This will automatically add Bearer token
      executionMethod: (bool success, dynamic responseData) {
        if (success && responseData['success'] == true) {
          // Store current user details before updating
          final currentUserDetails = _currentUser?.userData?.userDetails;
          
          // Parse the updated user data from response
          final updatedUser = UserModel.fromJson(responseData);
          
          // If the server returned null user_details, preserve our local data
          if (updatedUser.userData?.userDetails == null && currentUserDetails != null) {
            updatedUser.userData!.userDetails = currentUserDetails;
          }
          
          // Update the current user with the response data
          _currentUser = updatedUser;
          
          // Save the updated user data locally
          setUser(_currentUser!);
          
          log("User details updated successfully on server and locally");
          apiSuccess = true;
        } else {
          log("API returned success: false - ${responseData['message']}");
          apiSuccess = false;
        }
      },
    );
    
    return apiSuccess;
  }

  // Address management methods
  Future<bool> addAddress(AddressModel address) async {
    if (_currentUser?.userData == null) return false;
    
    _currentUser!.userData!.addAddress(address);
    await setUser(_currentUser!);
    return await updateUserDetailsOnServer();
  }

  Future<bool> updateAddress(AddressModel updatedAddress) async {
    if (_currentUser?.userData == null) return false;
    
    _currentUser!.userData!.userDetails?.updateAddress(updatedAddress);
    await setUser(_currentUser!);
    return await updateUserDetailsOnServer();
  }

  Future<bool> removeAddress(String addressId) async {
    if (_currentUser?.userData == null) return false;
    
    _currentUser!.userData!.userDetails?.removeAddress(addressId);
    await setUser(_currentUser!);
    return await updateUserDetailsOnServer();
  }

  Future<bool> setDefaultAddress(String addressId) async {
    if (_currentUser?.userData == null) return false;
    
    _currentUser!.userData!.setDefaultAddress(addressId);
    await setUser(_currentUser!);
    return await updateUserDetailsOnServer();
  }

  // Card management methods (single card)
  Future<bool> setCard(CardDetailsModel card) async {
    if (_currentUser?.userData == null) return false;
    
    _currentUser!.userData!.setCard(card);
    await setUser(_currentUser!);
    return await updateUserDetailsOnServer();
  }

  Future<bool> updateCard(CardDetailsModel updatedCard) async {
    if (_currentUser?.userData == null) return false;
    
    _currentUser!.userData!.userDetails?.updateCard(updatedCard);
    await setUser(_currentUser!);
    return await updateUserDetailsOnServer();
  }

  Future<bool> removeCard() async {
    if (_currentUser?.userData == null) return false;
    
    _currentUser!.userData!.userDetails?.removeCard();
    await setUser(_currentUser!);
    return await updateUserDetailsOnServer();
  }

  // Method to ensure complete user_details replacement while preserving all data
  Future<bool> updateUserDetailsWithCompleteData() async {
    if (_currentUser?.userData == null) return false;
    
    // Ensure userDetails is initialized
    _currentUser!.userData!.userDetails ??= UserDetailsModel();
    
    // The complete user_details JSON will be sent to server
    // This includes all existing addresses, cards, and custom data
    return await updateUserDetailsOnServer();
  }

  // Method to add address and immediately sync with server
  Future<bool> addAddressAndSync(AddressModel address) async {
    if (_currentUser?.userData == null) return false;
    
    // Ensure userDetails is initialized
    _currentUser!.userData!.userDetails ??= UserDetailsModel();
    
    // Add the address to the complete user_details
    _currentUser!.userData!.addAddress(address);
    
    // Save locally first
    await setUser(_currentUser!);
    
    // Sync with server (sends complete user_details JSON)
    return await updateUserDetailsOnServer();
  }

  // Method to set card and immediately sync with server
  Future<bool> setCardAndSync(CardDetailsModel card) async {
    if (_currentUser?.userData == null) return false;
    
    // Ensure userDetails is initialized
    _currentUser!.userData!.userDetails ??= UserDetailsModel();
    
    // Set the card in the complete user_details
    _currentUser!.userData!.setCard(card);
    
    // Save locally first
    await setUser(_currentUser!);
    
    // Sync with server (sends complete user_details JSON)
    return await updateUserDetailsOnServer();
  }

  // Getter methods for easy access
  List<AddressModel>? get deliveryAddresses => _currentUser?.userData?.deliveryAddresses;
  CardDetailsModel? get cardDetails => _currentUser?.userData?.cardDetails;
  AddressModel? get defaultAddress => _currentUser?.userData?.userDetails?.getDefaultAddress();
  CardDetailsModel? get card => _currentUser?.userData?.userDetails?.getCard();
}
