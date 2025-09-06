import 'package:equatable/equatable.dart';

import '../../../models/user_model.dart';

enum LoginStatus { initial, loading, success, error }

enum ForgotPasswordStatus { initial, loading, success, error }

enum SignUpStatus { initial, loading, success, error }

enum LogoutStatus { initial, loading, success, error }

class AuthState extends Equatable {
  final String message;
  final LoginStatus loginStatus;
  final ForgotPasswordStatus forgotPasswordStatus;
  final LogoutStatus logoutStatus;
  final SignUpStatus signUpStatus;
  final UserModel? userModel; // Store the full response here

  const AuthState({
    this.message = '',
    this.loginStatus = LoginStatus.initial,
    this.logoutStatus = LogoutStatus.initial,
    this.forgotPasswordStatus = ForgotPasswordStatus.initial,
    this.signUpStatus = SignUpStatus.initial,
    this.userModel,
  });

  AuthState copyWith({
    String? message,
    LoginStatus? loginStatus,
    ForgotPasswordStatus? forgotPasswordStatus,
    LogoutStatus? logoutStatus,
    SignUpStatus? signUpStatus,
    UserModel? userModel,
  }) {
    return AuthState(
      message: message ?? this.message,
      loginStatus: loginStatus ?? this.loginStatus,
      forgotPasswordStatus: forgotPasswordStatus ?? this.forgotPasswordStatus,
      logoutStatus: logoutStatus ?? this.logoutStatus,
      signUpStatus: signUpStatus ?? this.signUpStatus,
      userModel: userModel ?? this.userModel,
    );
  }

  @override
  String toString() {
    return 'LoginState(message: $message, loginStatus: $loginStatus, forgotPasswordStatus: $forgotPasswordStatus, logoutStatus: $logoutStatus, userModel: $userModel, signUpStatus: $signUpStatus)';
  }

  @override
  // TODO: implement props
  List<Object?> get props => [
    message,
    loginStatus,
    userModel,
    forgotPasswordStatus,
    signUpStatus,
    logoutStatus,
  ];
}
