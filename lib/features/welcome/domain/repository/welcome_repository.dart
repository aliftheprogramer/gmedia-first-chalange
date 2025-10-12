//lib/features/welcome/domain/repository/welcome_repository.dart

abstract class WelcomeRepository {
  Future<bool> isFirstRun();
  Future<void> setFirstRunComplete();
}