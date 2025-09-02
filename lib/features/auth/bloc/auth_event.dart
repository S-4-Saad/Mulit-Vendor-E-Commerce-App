import 'package:equatable/equatable.dart';

abstract class AuthEvents extends Equatable {
  @override
  List<Object?> get props => [];
}

class LoginEvent extends AuthEvents {
  final String email;
  final String password;
  LoginEvent({required this.email, required this.password});
  @override
  List<Object?> get props => [email, password];
}

class ResetPasswordEvent extends AuthEvents {
  final String email;
  ResetPasswordEvent({required this.email});
  @override
  List<Object?> get props => [email];
}

class LoadUserDataEvent extends AuthEvents {}
class SignUpEvent extends AuthEvents {
  final String email;
  final String password;
  final String username;
  SignUpEvent({required this.email, required this.password, required this.username});
  @override
  List<Object?> get props => [email, password, username];
}

class LogOutUserEvent extends AuthEvents {}
