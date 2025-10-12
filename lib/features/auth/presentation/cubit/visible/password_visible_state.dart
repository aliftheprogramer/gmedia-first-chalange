// lib/features/auth/presentation/cubit/visible/visible_cubit.dart
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gmedia_project/features/auth/presentation/cubit/visible/password_visible_cubit.dart';

class PasswordVisibleCubit extends Cubit<PasswordVisibleState> {
  PasswordVisibleCubit() : super(PasswordIsHidden());

  void toggleVisibility() {
    if (state is PasswordIsHidden) {
      emit(PasswordIsVisible());
    } else {
      emit(PasswordIsHidden());
    }
  }
}