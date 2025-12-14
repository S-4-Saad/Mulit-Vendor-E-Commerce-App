import 'dart:developer';
import 'package:bloc/bloc.dart';
import 'package:speezu/core/services/urls.dart';
import '../../../../models/user_model.dart';
import '../../../core/services/api_services.dart';
import '../../../core/services/localStorage/my-local-controller.dart';
import '../../../core/utils/constants.dart';
import '../../../core/services/notification_service.dart';
import '../../../repositories/user_repository.dart';
import 'auth_event.dart';
import 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvents, AuthState> {
  AuthBloc() : super(AuthState()) {
    on<LoginEvent>(_loginEvent);
    on<ResetPasswordEvent>(_resetPasswordEvent);
    // on<LoadUserDataEvent>(_loadInitialData);
    on<LogOutUserEvent>(_logOutUser);
    on<RegisterUserEvent>(_registerUserEvent);
    on<VerifyOtpEvent>(_verifyOtpEvent);
    on<CreateNewPasswordEvent>(_createNewPasswordEvent);
  }
  void _loginEvent(LoginEvent event, Emitter<AuthState> emit) async {
    emit(state.copyWith(loginStatus: LoginStatus.loading));

    try {
      await ApiService.postMethod(
        apiUrl: loginUserUrl,
        postData: {
          'email': event.email,
          'password': event.password,
          'user_role': "customer",
        },
        executionMethod: (bool success, dynamic responseData) async {
          if (success) {
            try {
              // Parse into UserModel only when success is true
              UserModel userModel = UserModel.fromJson(responseData);
              emit(
                state.copyWith(
                  loginStatus: LoginStatus.success,
                  message: responseData['message'],
                  userModel: userModel,
                ),
              );
              await UserRepository().setUser(userModel);

              await LocalStorage.saveData(
                key: AppKeys.authToken,
                value: responseData['token'],
              );

              log(
                'Stored token: ${await LocalStorage.getData(key: AppKeys.authToken)}',
              );

              log('User name: ${userModel.userData?.name ?? "No name"}');

              // Save FCM token to server after successful login
              try {
                final notificationService = NotificationService();
                final fcmToken = await notificationService.getDeviceToken();
                if (fcmToken.isNotEmpty) {
                  await UserRepository().saveFcmTokenToServer(fcmToken);
                  log('FCM token saved to server after login');
                }
              } catch (e) {
                log('Error saving FCM token after login: $e');
              }
            } catch (e) {
              print('Error: $e');
              emit(
                state.copyWith(
                  loginStatus: LoginStatus.error,
                  message: 'Parsing failed',
                ),
              );
            }
          } else {
            // Only handle error case here
            emit(
              state.copyWith(
                loginStatus: LoginStatus.error,
                message: responseData['message'] ?? 'Login failed',
              ),
            );
          }
        },
      );
    } catch (e) {
      emit(
        state.copyWith(
          loginStatus: LoginStatus.error,
          message: 'Login failed: $e',
        ),
      );
    }
  }

  void _registerUserEvent(
    RegisterUserEvent event,
    Emitter<AuthState> emit,
  ) async {
    emit(state.copyWith(signUpStatus: SignUpStatus.loading));

    try {
      await ApiService.postMethod(
        apiUrl: registerUserUrl,
        postData: {
          'email': event.email,
          'password': event.password,
          'name': event.username,
          'phone_no': event.phone,
          'user_role': "customer",
        },
        executionMethod: (bool success, dynamic responseData) async {
          if (success) {
            try {
              emit(
                state.copyWith(
                  signUpStatus: SignUpStatus.success,
                  message:
                      responseData['message'] ??
                      'Registration successful! Please login to continue.',
                ),
              );
              log('Registration successful: ${responseData['message']}');
            } catch (e) {
              log('Registration parsing error: $e');
              emit(
                state.copyWith(
                  signUpStatus: SignUpStatus.error,
                  message:
                      'Registration successful but failed to process response',
                ),
              );
            }
          } else {
            // Handle error case with proper error message
            final errorMessage =
                responseData['message'] ??
                'Registration failed. Please try again.';
            log('Registration failed: $errorMessage');
            emit(
              state.copyWith(
                signUpStatus: SignUpStatus.error,
                message: errorMessage,
              ),
            );
          }
        },
      );
    } catch (e) {
      log('Registration exception: $e');
      emit(
        state.copyWith(
          signUpStatus: SignUpStatus.error,
          message: 'Registration failed: ${e.toString()}',
        ),
      );
    }
  }

  void _resetPasswordEvent(
    ResetPasswordEvent event,
    Emitter<AuthState> emit,
  ) async {
    emit(state.copyWith(forgotPasswordStatus: ForgotPasswordStatus.loading));

    try {
      await ApiService.postMethod(
        apiUrl: resetPasswordUrl,
        postData: {'email': event.email},
        executionMethod: (bool success, dynamic responseData) async {
          if (success) {
            emit(
              state.copyWith(
                forgotPasswordStatus: ForgotPasswordStatus.success,
                message:
                    responseData['message'] ??
                    'Reset password email sent successfully',
              ),
            );
            print('State updated to success');
          } else {
            final errorMessage = _extractErrorMessage(responseData);
            emit(
              state.copyWith(
                forgotPasswordStatus: ForgotPasswordStatus.error,
                message: errorMessage,
              ),
            );
            log('Forgot password failed: $errorMessage');
          }
        },
      );
    } catch (e, stackTrace) {
      print('Exception caught during login: $e');
      print(stackTrace);
      emit(
        state.copyWith(
          forgotPasswordStatus: ForgotPasswordStatus.error,
          message: 'Reset password failed: $e',
        ),
      );
    }
  }
  // void _loadInitialData(
  //     LoadUserDataEvent event,
  //     Emitter<AuthState> emit,
  //     ) async {
  //   print("🔄 Loading initial data...");
  //   emit(state.copyWith(loginStatus: LoginStatus.loading));
  //
  //   try {
  //     final savedUserData = await LocalStorage.getData(key: AppKeys.userData);
  //     print("📦 Saved user data from storage: $savedUserData");
  //
  //     if (savedUserData != null) {
  //       UserModel userModel = UserModel.fromJson(jsonDecode(savedUserData));
  //       print("✅ UserModel successfully decoded: ${userModel.toJson()}");
  //
  //       emit(
  //         state.copyWith(
  //           loginStatus: LoginStatus.success,
  //           message: 'Loaded from storage',
  //           userModel: userModel,
  //         ),
  //       );
  //       print("🚀 Emitted success state with userModel.");
  //     } else {
  //       emit(
  //         state.copyWith(
  //           loginStatus: LoginStatus.initial,
  //           message: 'No user data found',
  //         ),
  //       );
  //       print("⚠️ No user data found, emitted initial state.");
  //     }
  //   } catch (e) {
  //     emit(
  //       state.copyWith(
  //         loginStatus: LoginStatus.error,
  //         message: 'Failed to load initial data: $e',
  //       ),
  //     );
  //     print("❌ Error loading data: $e");
  //   }
  // }

  void _logOutUser(LogOutUserEvent event, Emitter<AuthState> emit) async {
    emit(state.copyWith(logoutStatus: LogoutStatus.loading));
    try {
      UserRepository()
          .clearFcmTokenFromServer()
          .timeout(
            const Duration(seconds: 3),
            onTimeout: () {
              log('FCM token clear timed out, proceeding with logout');
              return false;
            },
          )
          .catchError((e) {
            log('Error clearing FCM token on logout: $e');
            return false;
          });

      await LocalStorage.removeData(key: AppKeys.authToken);
      await UserRepository()
          .clearUser(); // This will clear both user and cart data

      emit(
        state.copyWith(
          logoutStatus: LogoutStatus.success,
          message: 'User logged out',
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          logoutStatus: LogoutStatus.error,
          message: 'Failed to log out: $e',
        ),
      );
    }
  }

  void _verifyOtpEvent(VerifyOtpEvent event, Emitter<AuthState> emit) async {
    emit(state.copyWith(otpVerificationStatus: OtpVerificationStatus.loading));

    try {
      await ApiService.postMethod(
        apiUrl: verifyOtpUrl,
        postData: {'email': event.email, 'otp': event.otp},
        executionMethod: (bool success, dynamic responseData) async {
          if (success) {
            emit(
              state.copyWith(
                otpVerificationStatus: OtpVerificationStatus.success,
                message: responseData['message'] ?? 'OTP verified successfully',
              ),
            );
            log('OTP verified successfully');
          } else {
            final errorMessage = _extractErrorMessage(responseData);
            emit(
              state.copyWith(
                otpVerificationStatus: OtpVerificationStatus.error,
                message: errorMessage,
              ),
            );
            log('OTP verification failed: $errorMessage');
          }
        },
      );
    } catch (e, stackTrace) {
      log('Exception during OTP verification: $e');
      log(stackTrace.toString());
      emit(
        state.copyWith(
          otpVerificationStatus: OtpVerificationStatus.error,
          message: 'OTP verification failed: $e',
        ),
      );
    }
  }

  void _createNewPasswordEvent(
    CreateNewPasswordEvent event,
    Emitter<AuthState> emit,
  ) async {
    emit(state.copyWith(createPasswordStatus: CreatePasswordStatus.loading));

    try {
      await ApiService.postMethod(
        apiUrl: createNewPasswordUrl,
        postData: {
          'email': event.email,
          'otp': event.otp,
          'password': event.newPassword,
          'password_confirmation': event.newPassword,
        },
        executionMethod: (bool success, dynamic responseData) async {
          if (success) {
            emit(
              state.copyWith(
                createPasswordStatus: CreatePasswordStatus.success,
                message:
                    responseData['message'] ??
                    'Password reset successful! Please login.',
              ),
            );
            log('Password created successfully');
          } else {
            final errorMessage = _extractErrorMessage(responseData);
            emit(
              state.copyWith(
                createPasswordStatus: CreatePasswordStatus.error,
                message: errorMessage,
              ),
            );
            log('Password creation failed: $errorMessage');
          }
        },
      );
    } catch (e, stackTrace) {
      log('Exception during password creation: $e');
      log(stackTrace.toString());
      emit(
        state.copyWith(
          createPasswordStatus: CreatePasswordStatus.error,
          message: 'Failed to create new password: $e',
        ),
      );
    }
  }

  // Helper method to extract error messages from server response
  String _extractErrorMessage(dynamic responseData) {
    log('Extracting error from response: $responseData');

    // Check for direct message (handles your format: {"success":false,"message":"..."})
    if (responseData is Map && responseData.containsKey('message')) {
      final message = responseData['message'];
      // Handle both String and other types that can be converted to String
      if (message != null) {
        final messageStr = message.toString();
        if (messageStr.isNotEmpty && messageStr != 'null') {
          log('Extracted message: $messageStr');
          return messageStr;
        }
      }
    }

    // Check for errors object (validation errors)
    if (responseData is Map && responseData.containsKey('errors')) {
      final errors = responseData['errors'];

      // If errors is a Map, extract first error message
      if (errors is Map) {
        for (var errorList in errors.values) {
          if (errorList is List && errorList.isNotEmpty) {
            final errorMsg = errorList.first.toString();
            log('Extracted from errors map: $errorMsg');
            return errorMsg;
          }
        }
        // If Map but not in list format, convert to string
        final errorMsg = errors.toString();
        if (errorMsg.isNotEmpty) {
          log('Extracted errors map as string: $errorMsg');
          return errorMsg;
        }
      }

      // If errors is a string or list
      if (errors is String && errors.isNotEmpty) {
        log('Extracted errors string: $errors');
        return errors;
      }
      if (errors is List && errors.isNotEmpty) {
        final errorMsg = errors.first.toString();
        log('Extracted from errors list: $errorMsg');
        return errorMsg;
      }
    }

    // Check for error key
    if (responseData is Map && responseData.containsKey('error')) {
      final error = responseData['error'];
      if (error != null) {
        final errorStr = error.toString();
        if (errorStr.isNotEmpty && errorStr != 'null') {
          log('Extracted error: $errorStr');
          return errorStr;
        }
      }
    }

    // Default error message
    log('No specific error found, using default message');
    return 'An error occurred. Please try again.';
  }
}
