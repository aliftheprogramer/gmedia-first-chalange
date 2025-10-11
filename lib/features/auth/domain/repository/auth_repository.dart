import 'package:dartz/dartz.dart';
import 'package:gmedia_project/features/auth/domain/entities/login_request_entity.dart';

abstract class AuthRepository {
  Future<Either> signIn(LoginRequestEntity loginRequestEntity);
  Future<bool> isLoggedIn();
}
