// lib/common/bloc/auth/auth_cubit.dart
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gmedia_project/common/bloc/auth/auth_state.dart';
import 'package:gmedia_project/core/services/services_locator.dart';
import 'package:gmedia_project/features/auth/domain/usecase/is_logged_in.dart';
import 'package:gmedia_project/features/welcome/domain/usecase/is_first_run_usecase.dart';
import 'package:gmedia_project/features/welcome/domain/usecase/set_first_run_complete_usecase.dart';

class AuthStateCubit extends Cubit<AuthState> {
  AuthStateCubit() : super(AppInitialState());

  Future<void> _checkAuthStatus() async {
    final bool isLoggedIn = await sl<IsLoggedInUseCase>().call();
    if (isLoggedIn) {
      emit(Authenticated());
    } else {
      emit(UnAuthenticated());
    }
  }

  void appStarted() async {
    final bool isFirstRun = await sl<IsFirstRunUsecase>().call();
    
    if (isFirstRun) {
      emit(FirstRun());
    } else {
      await _checkAuthStatus();
    }
  }

  void finishWelcomeScreen() async {
    await sl<SetFirstRunCompleteUsecase>().call();
    await _checkAuthStatus();
  }
}