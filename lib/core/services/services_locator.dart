// lib/core/services/services_locator.dart

import 'package:get_it/get_it.dart';
import 'package:gmedia_project/features/welcome/data/repository_impl/welcome_repository_impl.dart';
import 'package:gmedia_project/features/welcome/data/source/welcome_local_data_source.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:gmedia_project/core/network/dio_client.dart';

// Auth Imports
import 'package:gmedia_project/features/auth/domain/usecase/is_logged_in.dart';
import 'package:gmedia_project/features/auth/domain/usecase/signin_usecases.dart';

// Welcome Imports
import 'package:gmedia_project/features/welcome/domain/repository/welcome_repository.dart';
import 'package:gmedia_project/features/welcome/domain/usecase/is_first_run_usecase.dart';
import 'package:gmedia_project/features/welcome/domain/usecase/set_first_run_complete_usecase.dart';


final sl = GetIt.instance;

Future<void> setUpServiceLocator() async {

  // External
  final sharedPreferences = await SharedPreferences.getInstance();
  sl.registerLazySingleton(() => sharedPreferences);
  sl.registerLazySingleton(() => DioClient());

  // Data Sources
  sl.registerLazySingleton<WelcomeLocalDataSource>(() => WelcomeLocalDataSourceImpl(sl()));

  // Repositories
  sl.registerLazySingleton<WelcomeRepository>(() => WelcomeRepositoryImpl(localDataSource: sl<WelcomeLocalDataSource>()));
  // sl.registerSingleton<AuthRepository>(AuthRepository()); // Anda bisa melengkapi ini nanti

  // Use Cases
  sl.registerLazySingleton<IsLoggedInUseCase>(() => IsLoggedInUseCase(/* sl<AuthRepository>() */)); // Lengkapi dependency-nya nanti
  sl.registerLazySingleton<SigninUsecases>(() => SigninUsecases(/* sl<AuthRepository>() */)); // Lengkapi dependency-nya nanti
  sl.registerLazySingleton<IsFirstRunUsecase>(() => IsFirstRunUsecase(sl<WelcomeRepository>()));
  sl.registerLazySingleton<SetFirstRunCompleteUsecase>(() => SetFirstRunCompleteUsecase(sl<WelcomeRepository>()));


}