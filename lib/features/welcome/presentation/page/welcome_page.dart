// lib/pages/welcome_page.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gmedia_project/common/bloc/auth/auth_cubit.dart'; // Sesuaikan path ini

class WelcomePage extends StatelessWidget {
  const WelcomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Selamat Datang di Aplikasi MASPOS!',
              style: TextStyle(fontSize: 24),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                context.read<AuthStateCubit>().finishWelcomeScreen();
              },
              child: const Text('Mulai Sekarang'),
            )
          ],
        ),
      ),
    );
  }
}