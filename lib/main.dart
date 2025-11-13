// lib/main.dart

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gmedia_project/common/bloc/auth/auth_cubit.dart';
import 'package:gmedia_project/common/bloc/auth/auth_state.dart';
import 'package:gmedia_project/core/services/services_locator.dart';
import 'package:gmedia_project/features/auth/presentation/pages/login_page.dart';
import 'package:gmedia_project/features/welcome/presentation/page/welcome_page.dart';
import 'package:gmedia_project/navigation/cubit/navigation_cubit.dart';
import 'package:gmedia_project/navigation/screen/main_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await setUpServiceLocator();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => sl<AuthStateCubit>()..appStarted()),
        BlocProvider(create: (context) => sl<NavigationCubit>()),
      ],
      child: MaterialApp(
        theme: ThemeData(
          primarySwatch: Colors.blue,
          scaffoldBackgroundColor: Color(0xFFEBF0FD),
          // scaffoldBackgroundColor: Colors.white,

        ),
        home: BlocBuilder<AuthStateCubit, AuthState>(
          builder: (context, state) {
            if (state is FirstRun) {
              return const WelcomePage();
            } else if (state is Authenticated) {
              return MainScreen();
            } else if (state is UnAuthenticated) {
              return const LoginPage();
            } else {
              return const Scaffold(
                body: Center(child: CircularProgressIndicator()),
              );
            }
          },
        ),
      ),
    );
  }
}
