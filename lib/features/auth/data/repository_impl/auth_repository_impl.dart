// lib/features/auth/data/repository_impl/auth_repository_impl.dart

import 'package:dartz/dartz.dart';
import 'package:gmedia_project/core/services/services_locator.dart';
import 'package:gmedia_project/features/auth/data/model/login_request_model.dart';
import 'package:gmedia_project/features/auth/data/source/auth_api_service.dart';
import 'package:gmedia_project/features/auth/data/source/auth_local_service.dart';
import 'package:gmedia_project/features/auth/domain/repository/auth_repository.dart';
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthRepositoryImpl extends AuthRepository {
  @override
  Future<bool> isLoggedIn() async {
    return await sl<AuthLocalService>().isLoggedIn();
  }

  @override
  Future<Either> signIn(LoginRequestModel loginRequestModel) async {
    Either result = await sl<AuthApiService>().login(loginRequestModel);
    return result.fold(
      (error) {
        return Left(error);
      },
      (data) async {
        Response response = data;
        SharedPreferences sharedPreferences =
            await SharedPreferences.getInstance();
        sharedPreferences.setString(
          "token",
          response.data['data']['token'],
        );
        return Right(response);
      },
    );
  }
}
