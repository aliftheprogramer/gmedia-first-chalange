// lib/features/auth/presentation/widgets/login_background.dart
import 'package:flutter/material.dart';

class LoginBackground extends StatelessWidget {
  const LoginBackground({super.key});

  @override
  Widget build(BuildContext context) {
    // Ini adalah versi sederhana dari background di gambar
    // Anda bisa mengembangkannya lebih lanjut
    return Container(
      height: MediaQuery.of(context).size.height * 0.4,
      decoration: const BoxDecoration(
        color: Colors.blueAccent,
        image: DecorationImage(
          image: NetworkImage('https://www.transparenttextures.com/patterns/striped-light.png'),
          repeat: ImageRepeat.repeat,
          opacity: 0.1
        )
      ),
    );
  }
}