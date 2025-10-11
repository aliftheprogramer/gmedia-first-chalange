import 'package:get_it/get_it.dart';
import 'package:gmedia_project/core/network/dio_client.dart';
import 'package:gmedia_project/features/auth/domain/usecase/is_logged_in.dart';
import 'package:gmedia_project/features/auth/domain/usecase/signin_usecases.dart';

final sl = GetIt.instance;

void setUpServiceLocator(){
  sl.registerSingleton<DioClient>(DioClient());
  sl.registerSingleton<IsLoggedInUseCase>(IsLoggedInUseCase());
  sl.registerSingleton<SigninUsecases>(SigninUsecases());
  // sl.registerSingleton<AuthRepository>(AuthRepository());
}