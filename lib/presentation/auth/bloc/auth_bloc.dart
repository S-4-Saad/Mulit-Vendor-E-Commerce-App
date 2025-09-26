import 'dart:developer';
import 'package:bloc/bloc.dart';
import 'package:speezu/core/services/urls.dart';
import '../../../../models/user_model.dart';
import '../../../core/services/api_services.dart';
import '../../../core/services/localStorage/my-local-controller.dart';
import '../../../core/utils/constants.dart';
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
  }
  void _loginEvent(LoginEvent event, Emitter<AuthState> emit) async {
    emit(state.copyWith(loginStatus: LoginStatus.loading));

    try {
      await ApiService.postMethod(
        apiUrl: loginUserUrl,
        postData: {
          'email': event.email,
          'password': event.password,
          'user_role': "customer"
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
                  message: responseData['message'] ?? 'Registration successful! Please login to continue.',
                ),
              );
              log('Registration successful: ${responseData['message']}');
            } catch (e) {
              log('Registration parsing error: $e');
              emit(
                state.copyWith(
                  signUpStatus: SignUpStatus.error,
                  message: 'Registration successful but failed to process response',
                ),
              );
            }
          } else {
            // Handle error case with proper error message
            final errorMessage = responseData['message'] ?? 'Registration failed. Please try again.';
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

  void _resetPasswordEvent(ResetPasswordEvent event, Emitter<AuthState> emit,) async {


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
            emit(
              state.copyWith(
                forgotPasswordStatus: ForgotPasswordStatus.error,
                message: responseData['message'] ?? 'Reset password failed',
              ),
            );
            // Only handle error case here
            print(
              'Login failed with message: ${responseData['message'] ?? "Unknown error"}',
            );
            emit(
              state.copyWith(
                forgotPasswordStatus: ForgotPasswordStatus.error,
                message: responseData['message'] ?? 'Reset password failed',
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
      await LocalStorage.removeData(key: AppKeys.authToken);
      await UserRepository().clearUser(); // This will clear both user and cart data

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
}
