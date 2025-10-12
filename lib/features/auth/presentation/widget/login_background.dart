// lib/features/auth/presentation/widgets/login_background.dart
import 'package:flutter/material.dart';

class LoginBackground extends StatelessWidget {
  const LoginBackground({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      // Tinggi background diset sekitar 40% dari tinggi layar
      height: MediaQuery.of(context).size.height * 0.4,
      decoration: const BoxDecoration(
        color: Color(0xFF4A80F0), // Warna biru solid sebagai pengganti
      ),
    );
  }
}