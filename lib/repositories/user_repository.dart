import 'dart:convert';
import 'dart:developer';
import 'dart:ui';
import 'package:speezu/models/user_model.dart';
import '../core/services/localStorage/my-local-controller.dart';
import '../core/utils/constants.dart';

class UserRepository {
  static final UserRepository _instance = UserRepository._internal();
  factory UserRepository() => _instance;

  UserRepository._internal();

  Future<void> init() async {
    await loadInitialData();
  }

  UserModel? _currentUser;

  UserModel? get currentUser => _currentUser;

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
  }

  Future<void> clearUser() async {
    _currentUser = null;
    await LocalStorage.removeData(key: AppKeys.userData);
  }
}
