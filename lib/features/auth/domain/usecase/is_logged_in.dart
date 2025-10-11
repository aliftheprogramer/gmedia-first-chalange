
import 'package:gmedia_project/core/services/services_locator.dart';
import 'package:gmedia_project/core/usecase/usecase.dart';
import 'package:gmedia_project/features/auth/domain/repository/auth_repository.dart';

class IsLoggedInUseCase implements Usecase<bool, dynamic> {
  @override
  Future<bool> call({dynamic param}) async {
    return await sl<AuthRepository>().isLoggedIn();
  }
}
