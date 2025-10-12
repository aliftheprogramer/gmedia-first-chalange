//  lib/features/welcome/domain/usecase/is_first_run_usecase.dart


import 'package:gmedia_project/core/usecase/usecase.dart';
import 'package:gmedia_project/features/welcome/domain/repository/welcome_repository.dart';


class IsFirstRunUsecase implements Usecase<bool, NoParams> {
  final WelcomeRepository repository;

  IsFirstRunUsecase(this.repository);
  @override
  Future<bool> call({NoParams? param}) async {
    return await repository.isFirstRun();
  }
}