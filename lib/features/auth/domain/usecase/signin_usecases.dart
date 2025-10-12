// lib/features/auth/domain/usecase/signin_usecases.dart

import 'package:dartz/dartz.dart';
import 'package:gmedia_project/core/services/services_locator.dart';
import 'package:gmedia_project/core/usecase/usecase.dart';
import 'package:gmedia_project/features/auth/data/model/login_request_model.dart';
import 'package:gmedia_project/features/auth/domain/repository/auth_repository.dart';

class SigninUsecases implements Usecase<Either, LoginRequestModel> {
  SigninUsecases(AuthRepository authRepository);

  @override
  Future<Either> call({LoginRequestModel? param}) async {
    return sl<AuthRepository>().signIn(param!);
  }

}
