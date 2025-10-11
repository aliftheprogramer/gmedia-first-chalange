import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gmedia_project/common/bloc/auth/auth_cubit.dart';
import 'package:gmedia_project/common/bloc/auth/auth_state.dart';
import 'package:gmedia_project/core/services/services_locator.dart';

void main() {
  setUpServiceLocator();
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
            if (state is Authenticated) {
              return const Scaffold(
                body: Center(
                  child: Text('Authenticated'),
                ),
              );
            } else if (state is UnAuthenticated) {
              return const Scaffold(
                body: Center(
                  child: Text('UnAuthenticated'),
                ),
              );
            } else {
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
