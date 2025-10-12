// lib/features/auth/presentation/cubit/login/login_cubit.dart
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gmedia_project/core/services/services_locator.dart';
import 'package:gmedia_project/features/auth/data/model/login_request_model.dart';
import 'package:gmedia_project/features/auth/domain/usecase/signin_usecases.dart';
import 'package:gmedia_project/features/auth/presentation/cubit/login/login_state.dart';

class LoginCubit extends Cubit<LoginState> {
  LoginCubit() : super(LoginInitial());

  void login(String email, String password) async {
    emit(LoginLoading());
    final usecase = sl<SigninUsecases>();
    final result = await usecase.call(
      param: LoginRequestModel(email: email, password: password),
    );

    result.fold(
      (failure) => emit(LoginFailure(failure)),
      (data) => emit(LoginSuccess(data)),
    );
  }
}