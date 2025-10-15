// lib/pages/welcome_page.dart

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gmedia_project/common/bloc/auth/auth_cubit.dart';

class WelcomePage extends StatelessWidget {
  const WelcomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // LAPISAN 1 (PALING BELAKANG): Wallpaper gambar.
          Positioned.fill(
            child: _buildWallpaper(),
          ),

          // LAPISAN 2: Gradient overlay (semi-transparan) di atas wallpaper.
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  // Bagian atas tetap sama
                  Colors.white.withOpacity(0.8),
                  // DIPERBAIKI: Opacity warna biru dikurangi agar lebih cerah
                  const Color(0xFFAABCF4).withOpacity(0.6),
                ],
                // Menyesuaikan titik henti gradien agar transisi lebih halus
                stops: const [0.0, 1.0],
              ),
            ),
          ),

          // LAPISAN 3: Gradient Putih di Atas untuk Keterbacaan Teks
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: Container(
              height: MediaQuery.of(context).size.height * 0.4,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.white.withOpacity(1.0),
                    Colors.white.withOpacity(0.8),
                    Colors.white.withOpacity(0.0),
                  ],
                  stops: const [0.0, 0.5, 1.0],
                ),
              ),
            ),
          ),

          // LAPISAN 4: UI Utama (Teks dan Tombol)
          SafeArea(
            child: Column(
              children: [
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.fromLTRB(24, 56, 24, 16),
                  child: Text.rich(
                    TextSpan(
                      style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                            color: Colors.black87,
                            fontWeight: FontWeight.w300,
                            height: 1.2,
                          ),
                      children: const [
                        TextSpan(text: 'Kasir Pintar, Bisnis Lancar!\nYuk, Coba'),
                        TextSpan(
                          text: ' MASPOS',
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Color(0xff1843C3)),
                        ),
                      ],
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                const Spacer(),
                Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 24.0, vertical: 40.0),
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF2C59E5),
                      foregroundColor: Colors.white,
                      minimumSize: const Size(double.infinity, 56),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      elevation: 5,
                    ),
                    onPressed: () {
                      context.read<AuthStateCubit>().finishWelcomeScreen();
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        const Text('Yuk mulai cobain',
                            style: TextStyle(fontSize: 16)),
                        const SizedBox(width: 8),
                        Row(
                          children: [
                            Icon(Icons.arrow_forward_ios,
                                size: 14, color: Colors.white.withOpacity(0.3)),
                            Icon(Icons.arrow_forward_ios,
                                size: 14, color: Colors.white.withOpacity(0.6)),
                            const Icon(Icons.arrow_forward_ios,
                                size: 14, color: Colors.white),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 40),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWallpaper() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Expanded(
          child: Padding(
            padding: const EdgeInsets.only(right: 5.0),
            child: Image.asset(
              'assets/variant1.png',
              fit: BoxFit.cover,
            ),
          ),
        ),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 5.0),
            child: Image.asset(
              'assets/variant2.png',
              fit: BoxFit.cover,
            ),
          ),
        ),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.only(left: 5.0),
            child: Image.asset(
              'assets/variant3.png',
              fit: BoxFit.cover,
            ),
          ),
        ),
      ],
    );
  }
}