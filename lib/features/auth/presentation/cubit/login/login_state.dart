// lib/features/auth/presentation/cubit/login/login_state.dart
import 'package:dio/dio.dart';

abstract class LoginState {}
class LoginInitial extends LoginState {}
class LoginLoading extends LoginState {}
class LoginSuccess extends LoginState {
  final Response response;
  LoginSuccess(this.response);
}
class LoginFailure extends LoginState {
  final String error;
  LoginFailure(this.error);
}