import 'package:gmedia_project/features/welcome/data/source/welcome_local_data_source.dart';
import 'package:gmedia_project/features/welcome/domain/repository/welcome_repository.dart';

class WelcomeRepositoryImpl implements WelcomeRepository{
  final WelcomeLocalDataSource localDataSource;
  WelcomeRepositoryImpl({required this.localDataSource});

  @override
  Future<bool> isFirstRun() async{
    return await localDataSource.isFirstRun();
  }

  @override
  Future<void> setFirstRunComplete() async {
    return await localDataSource.setFirstRunComplete();
  }
}