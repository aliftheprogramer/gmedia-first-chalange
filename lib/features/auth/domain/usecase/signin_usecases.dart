
import 'package:dartz/dartz.dart';
import 'package:gmedia_project/core/services/services_locator.dart';
import 'package:gmedia_project/core/usecase/usecase.dart';
import 'package:gmedia_project/features/auth/domain/entities/login_request_entity.dart';
import 'package:gmedia_project/features/auth/domain/repository/auth_repository.dart';

class SigninUsecases implements Usecase<Either, LoginRequestEntity> {
  @override
  Future<Either> call({LoginRequestEntity? param}) async {
    return sl<AuthRepository>().signIn(param!);
  }
}
