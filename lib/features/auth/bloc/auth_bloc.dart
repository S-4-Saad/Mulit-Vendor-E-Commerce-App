import 'dart:convert';
import 'dart:developer';
import 'package:bloc/bloc.dart';
import 'package:speezu/core/services/urls.dart';
import '../../../../models/user_model.dart';
import '../../../core/services/api_services.dart';
import '../../../core/services/localStorage/my-local-controller.dart';
import '../../../core/utils/constants.dart';
import 'auth_event.dart';
import 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvents, AuthState> {
  AuthBloc() : super(AuthState()) {
    on<LoginEvent>(_loginEvent);
    on<ResetPasswordEvent>(_resetPasswordEvent);
    on<LoadUserDataEvent>(_loadInitialData);
    on<LogOutUserEvent>(_logOutUser);
  }
  void _loginEvent(LoginEvent event, Emitter<AuthState> emit) async {


    emit(state.copyWith(loginStatus: LoginStatus.loading));


    try {
      await ApiService.postMethod(
        apiUrl: loginUserUrl,
        postData: {'email': event.email, 'password': event.password},
        executionMethod: (bool success, dynamic responseData) async {
          if (success) {
            try {
              // Parse into UserModel only when success is true
              UserModel userModel = UserModel.fromJson(responseData);
              print('UserModel parsed successfully: ${userModel.userData?.name}');
              emit(
                state.copyWith(
                  loginStatus: LoginStatus.success,
                  message: responseData['message'] ?? 'Login successful',
                  userModel: userModel,
                ),
              );
              print('State updated to success');

              await LocalStorage.saveData(
                key: AppKeys.userData,
                value: jsonEncode(userModel.toJson()),
              );
              print('User data saved to local storage');

              await LocalStorage.saveData(
                key: AppKeys.authToken,
                value: responseData['data']['api_token'],
              );
              print('Auth token saved to local storage');


              log('Stored token: ${await LocalStorage.getData(key: AppKeys.authToken)}');

              log('User name: ${userModel.userData?.name ?? "No name"}');

            } catch (e, stack) {
              print('Error parsing UserModel: $e');
              print(stack);
              emit(
                state.copyWith(
                  loginStatus: LoginStatus.error,
                  message: 'Parsing failed',
                ),
              );
            }
          } else {
            // Only handle error case here
            print('Login failed with message: ${responseData['message'] ?? "Unknown error"}');
            emit(
              state.copyWith(
                loginStatus: LoginStatus.error,
                message: responseData['message'] ?? 'Login failed',
              ),
            );
          }
        },
      );
    } catch (e, stackTrace) {
      print('Exception caught during login: $e');
      print(stackTrace);
      emit(
        state.copyWith(
          loginStatus: LoginStatus.error,
          message: 'Login failed: $e',
        ),
      );
    }

    print('--- Login Event Completed ---');
  }
  void _resetPasswordEvent(ResetPasswordEvent event, Emitter<AuthState> emit) async {
    print('--- Login Event Triggered ---');
    print('Email: ${event.email}');
    print('Sending login POST data: ${event.email}');

    emit(state.copyWith(forgotPasswordStatus: ForgotPasswordStatus.loading));
    print('Login status set to loading');
    print('Login URL: $loginUserUrl');

    try {
      await ApiService.postMethod(
        apiUrl: resetPasswordUrl,
        postData: {'email': event.email},
        executionMethod: (bool success, dynamic responseData) async {
          if (success) {
              emit(
                state.copyWith(
                  forgotPasswordStatus: ForgotPasswordStatus.success,
                  message: responseData['message'] ?? 'Reset password email sent successfully',
                ),
              );
              print('State updated to success');


          } else {
            // Only handle error case here
            print('Login failed with message: ${responseData['message'] ?? "Unknown error"}');
            emit(
              state.copyWith(
                forgotPasswordStatus: ForgotPasswordStatus.error,
                message: responseData['message'] ?? 'Login failed',
              ),
            );
          }
        },
      );
    } catch (e, stackTrace) {
      print('Exception caught during login: $e');
      print(stackTrace);
      emit(
        state.copyWith(
          forgotPasswordStatus: ForgotPasswordStatus.error,
          message: 'Login failed: $e',
        ),
      );
    }

  }

  void _loadInitialData(LoadUserDataEvent event, Emitter<AuthState> emit) async {
    emit(state.copyWith(loginStatus: LoginStatus.loading));
    try {
      final savedUserData = await LocalStorage.getData(key: AppKeys.userData);
      if (savedUserData != null) {
        UserModel userModel = UserModel.fromJson(jsonDecode(savedUserData));
        emit(state.copyWith(
          loginStatus: LoginStatus.success,
          message: 'Loaded from storage',
          userModel: userModel,
        ));
      } else {
        emit(state.copyWith(
          loginStatus: LoginStatus.initial,
          message: 'No user data found',
        ));
      }
    } catch (e) {
      emit(state.copyWith(
        loginStatus: LoginStatus.error,
        message: 'Failed to load initial data: $e',
      ));
    }
  }

  void _logOutUser(LogOutUserEvent event, Emitter<AuthState> emit) async {
    emit(state.copyWith(loginStatus: LoginStatus.loading));
    try {
      await LocalStorage.removeData(key: AppKeys.userData);
      await LocalStorage.removeData(key: AppKeys.authToken);
      await LocalStorage.removeData(key: AppKeys.uRole);
      emit(state.copyWith(
        loginStatus: LoginStatus.initial,
        message: 'User logged out',
      ));
    } catch (e) {
      emit(state.copyWith(
        loginStatus: LoginStatus.error,
        message: 'Failed to log out: $e',
      ));
    }
  }
}
