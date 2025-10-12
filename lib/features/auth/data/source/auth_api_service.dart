// lib/features/auth/data/source/auth_api_service.dart

import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:gmedia_project/core/constant/api_urls.dart';
import 'package:gmedia_project/core/network/dio_client.dart';
import 'package:gmedia_project/core/services/services_locator.dart';
import 'package:gmedia_project/features/auth/data/model/login_request_model.dart';

abstract class AuthApiService {
  Future<Either> login(LoginRequestModel loginRequestModel);
}

class AuthApiServiceImpl implements AuthApiService {
  @override
  Future<Either> login(LoginRequestModel loginRequestModel) async {
    try {
      var response = await sl<DioClient>().post(
        ApiUrls.login,
        data: loginRequestModel.toMap(),
      );
      return Right(response.data);
    }on DioException catch (e) {
      return Left(e.response!.data['message'] ?? 'Login failed');
    }
  }
}