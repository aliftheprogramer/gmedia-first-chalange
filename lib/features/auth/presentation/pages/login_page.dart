// lib/features/auth/presentation/pages/login_page.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gmedia_project/common/bloc/auth/auth_cubit.dart';
import 'package:gmedia_project/core/services/services_locator.dart';
import 'package:gmedia_project/features/auth/presentation/cubit/login/login_cubit.dart';
import 'package:gmedia_project/features/auth/presentation/cubit/login/login_state.dart';
import 'package:gmedia_project/features/auth/presentation/cubit/visible/password_visible_state.dart';

import 'package:gmedia_project/features/auth/presentation/widget/login_background.dart';
import 'package:gmedia_project/features/auth/presentation/widget/login_form_card.dart';


class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    final bgHeight = MediaQuery.of(context).size.height * 0.4;

    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => sl<LoginCubit>()),
        BlocProvider(create: (context) => sl<PasswordVisibleCubit>()),
      ],
      child: Scaffold(
        body: BlocListener<LoginCubit, LoginState>(
          listener: (context, state) {
            if (state is LoginSuccess) {
              context.read<AuthStateCubit>().checkAuthStatus();
            } else if (state is LoginFailure) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                    content: Text(state.error), backgroundColor: Colors.red),
              );
            }
          },
          child: SingleChildScrollView(
            child: SizedBox(
              height: MediaQuery.of(context).size.height,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  // Background stays at the top
                  const Positioned(
                    top: 0,
                    left: 0,
                    right: 0,
                    child: LoginBackground(),
                  ),

                  // Position the form card to occupy the bottom area and
                  // ensure the lower portion is white. We set `top` to
                  // slightly overlap the background so the rounded top
                  // corners look natural.
                  Positioned(
                    top: bgHeight - 30,
                    left: 0,
                    right: 0,
                    bottom: 0,
                    child: LoginFormCard(),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}