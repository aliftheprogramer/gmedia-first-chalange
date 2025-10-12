import 'package:shared_preferences/shared_preferences.dart';

const String IS_FIRST_RUN_KEY = 'isFirstRunCompleted';

abstract class WelcomeLocalDataSource {
  Future<bool> isFirstRun();
  Future<void> setFirstRunComplete();
}

class WelcomeLocalDataSourceImpl implements WelcomeLocalDataSource{

  final SharedPreferences sharedPreferences;
  WelcomeLocalDataSourceImpl(this.sharedPreferences);

  @override
  Future<bool> isFirstRun() async {
    final bool completed = sharedPreferences.getBool(IS_FIRST_RUN_KEY) ?? false;
    return !completed; 
  }

  @override
  Future<void> setFirstRunComplete() async {
    await sharedPreferences.setBool(IS_FIRST_RUN_KEY, true);
  }
}