import 'package:get_it/get_it.dart';
import 'package:gmedia_project/common/bloc/auth/auth_cubit.dart';
import 'package:gmedia_project/core/network/dio_client.dart';
import 'package:gmedia_project/features/auth/data/repository_impl/auth_repository_impl.dart';
import 'package:gmedia_project/features/auth/data/source/auth_api_service.dart';
import 'package:gmedia_project/features/auth/data/source/auth_local_service.dart';
import 'package:gmedia_project/features/auth/domain/repository/auth_repository.dart';
import 'package:gmedia_project/features/auth/domain/usecase/is_logged_in.dart';
import 'package:gmedia_project/features/auth/domain/usecase/signin_usecases.dart';
import 'package:gmedia_project/features/auth/presentation/cubit/login/login_cubit.dart';
import 'package:gmedia_project/features/auth/presentation/cubit/visible/password_visible_state.dart';
import 'package:gmedia_project/features/category/data/repository_impl/category_repository_impl.dart';
import 'package:gmedia_project/features/category/data/source/category_api_service.dart';
import 'package:gmedia_project/features/category/domain/repository/category_repository.dart';
import 'package:gmedia_project/features/category/domain/usecase/create_new_category_usecase.dart';
import 'package:gmedia_project/features/category/domain/usecase/get_all_category_usecase.dart';
import 'package:gmedia_project/features/category/presentation/cubit/add_category_cubit.dart';
import 'package:gmedia_project/features/home/data/repository_impl/home_repository_impl.dart';
import 'package:gmedia_project/features/home/data/source/home_local_data_source.dart';
import 'package:gmedia_project/features/home/domain/repository/home_repository.dart';
import 'package:gmedia_project/features/home/domain/usecase/banner_usecase.dart';
import 'package:gmedia_project/features/home/presentation/provider/home_provider.dart';
import 'package:gmedia_project/features/product/data/repository_impl/product_repository_impl.dart';
import 'package:gmedia_project/features/product/data/source/product_api_service.dart';
import 'package:gmedia_project/features/product/domain/repository/product_repository.dart';
import 'package:gmedia_project/features/product/domain/usecase/add_product_usecase.dart';
import 'package:gmedia_project/features/product/domain/usecase/delete_product_usecase.dart';
import 'package:gmedia_project/features/product/domain/usecase/edit_product_usecase.dart';
import 'package:gmedia_project/features/product/domain/usecase/get_list_product_usecase.dart';
import 'package:gmedia_project/features/product/domain/usecase/get_product_detail.dart';
import 'package:gmedia_project/features/welcome/data/repository_impl/welcome_repository_impl.dart';
import 'package:gmedia_project/features/welcome/data/source/welcome_local_data_source.dart';
import 'package:gmedia_project/features/welcome/domain/repository/welcome_repository.dart';
import 'package:gmedia_project/features/welcome/domain/usecase/is_first_run_usecase.dart';
import 'package:gmedia_project/features/welcome/domain/usecase/set_first_run_complete_usecase.dart';
import 'package:gmedia_project/navigation/cubit/navigation_cubit.dart';
import 'package:logger/logger.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:gmedia_project/features/product/presentation/cubit/add_product_cubit.dart';

final sl = GetIt.instance;

Future<void> setUpServiceLocator() async {
  // External
  final sharedPreferences = await SharedPreferences.getInstance();
  sl.registerLazySingleton(() => sharedPreferences);
  sl.registerLazySingleton(() => DioClient());
  sl.registerLazySingleton(() => Logger());

  // Data Sources
  sl.registerLazySingleton<AuthLocalService>(() => AuthLocalServiceImpl(sl()));
  sl.registerLazySingleton<AuthApiService>(() => AuthApiServiceImpl());
  sl.registerLazySingleton<WelcomeLocalDataSource>(
    () => WelcomeLocalDataSourceImpl(sl()),
  );
  sl.registerLazySingleton<ProductApiService>(() => ProductApiServiceImpl());
  sl.registerLazySingleton<HomeLocalDataSource>(
    () => HomeLocalDataSourceImpl(),
  );
  sl.registerLazySingleton<CategoryApiService>(() => CategoryApiServiceImpl());

  // Repositories
  sl.registerLazySingleton<AuthRepository>(() => AuthRepositoryImpl());
  sl.registerLazySingleton<WelcomeRepository>(
    () => WelcomeRepositoryImpl(localDataSource: sl()),
  );
  sl.registerLazySingleton<ProductRepository>(() => ProductRepositoryImpl());
  sl.registerLazySingleton<HomeRepository>(() => HomeRepositoryImpl(sl()));
  sl.registerLazySingleton<CategoryRepository>(() => CategoryRepositoryImpl());

  // Use Cases
  sl.registerLazySingleton(() => IsLoggedInUseCase(sl()));
  sl.registerLazySingleton(() => SigninUsecases(sl()));
  sl.registerLazySingleton(() => IsFirstRunUsecase(sl()));
  sl.registerLazySingleton(() => SetFirstRunCompleteUsecase(sl()));
  sl.registerLazySingleton(() => DeleteProductUsecase(sl()));
  sl.registerLazySingleton(() => AddProductUsecase(sl()));
  sl.registerLazySingleton(() => GetProductDetail(sl()));
  sl.registerLazySingleton(() => GetListProductUsecase(sl()));
  sl.registerLazySingleton(() => GetHeroBannersUseCase(sl()));
  sl.registerLazySingleton(() => EditProductUsecase(sl()));
  sl.registerLazySingleton(() => CreateNewCategoryUsecase(sl()));
  sl.registerLazySingleton(() => GetAllCategoryUsecase(sl()));



  // Cubits & Providers
  sl.registerFactory(() => PasswordVisibleCubit());
  sl.registerFactory(() => LoginCubit());
  sl.registerFactory(() => NavigationCubit());
  sl.registerFactory(() => AuthStateCubit());
  sl.registerFactory(() => HomeProvider(sl()));
  sl.registerFactory(() => AddProductCubit(sl()));
  sl.registerFactory(() => AddCategoryCubit(sl()));
}