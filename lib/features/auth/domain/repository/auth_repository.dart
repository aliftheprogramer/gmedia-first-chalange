// lib/features/auth/domain/repository/auth_repository.dart

import 'package:dartz/dartz.dart';
import 'package:gmedia_project/features/auth/data/model/login_request_model.dart';
import 'package:dio/dio.dart';  

abstract class AuthRepository {
  Future<Either<String, Response>> signIn(LoginRequestModel loginRequestModel);
  Future<bool> isLoggedIn();
}