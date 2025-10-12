// lib/main.dart

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gmedia_project/common/bloc/auth/auth_cubit.dart';
import 'package:gmedia_project/common/bloc/auth/auth_state.dart';
import 'package:gmedia_project/core/services/services_locator.dart';
import 'package:gmedia_project/features/auth/presentation/pages/login_page.dart';
import 'package:gmedia_project/features/welcome/presentation/page/welcome_page.dart';
import 'package:gmedia_project/navigation/screen/main_screen.dart';


// 1. Jadikan main() sebagai async
void main() async {
  // 2. Wajib ada untuk memastikan binding siap sebelum await
  WidgetsFlutterBinding.ensureInitialized();
  // 3. Tambahkan await karena setUpServiceLocator sekarang async
  await setUpServiceLocator();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AuthStateCubit()..appStarted(),
      child: MaterialApp(
        title: 'MASPOS',
        theme: ThemeData(
          primarySwatch: Colors.blue,
          scaffoldBackgroundColor: Colors.white,
        ),
        home: BlocBuilder<AuthStateCubit, AuthState>(
          builder: ( context, state) {
            // 5. Tambahkan kondisi untuk menangani state FirstRun
            if (state is FirstRun) {
              return const WelcomePage();
            } else if (state is Authenticated) {
              // Ganti placeholder dengan halaman sebenarnya
              return const MainScreen();
            } else if (state is UnAuthenticated) {
              // Ganti placeholder dengan halaman sebenarnya
              return const LoginPage();
            } else {
              // Ini adalah state awal (AppInitialState) saat app loading
              return const Scaffold(
                body: Center(
                  child: CircularProgressIndicator(),
                ),
              );
            }
          },
        ),
      ),
    );
  }
}