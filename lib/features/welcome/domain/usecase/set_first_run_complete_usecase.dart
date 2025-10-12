// lib/features/welcome/domain/usecase/set_first_run_complete_usecase.dart

import 'package:gmedia_project/core/usecase/usecase.dart';
import 'package:gmedia_project/features/welcome/domain/repository/welcome_repository.dart';

class SetFirstRunCompleteUsecase implements Usecase<void, NoParams> {
  final WelcomeRepository repository;

  SetFirstRunCompleteUsecase(this.repository);


  @override
  Future<void> call({NoParams? param}) async { 
    return await repository.setFirstRunComplete();
  }
}