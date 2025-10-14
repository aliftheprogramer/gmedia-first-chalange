// lib/pages/welcome_page.dart

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gmedia_project/common/bloc/auth/auth_cubit.dart';

class WelcomePage extends StatefulWidget {
  const WelcomePage({super.key});

  @override
  State<WelcomePage> createState() => _WelcomePageState();
}

class _WelcomePageState extends State<WelcomePage> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Full-screen background gradient (back-most layer)
          Positioned.fill(
            child: Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Color(0xFFFFFFFF), // top solid white
                    Color(0xFFAABCF4), // bottom solid AABCF4
                  ],
                ),
              ),
            ),
          ),
          // Tiga gambar berdampingan (tanpa scroll)
          Positioned.fill(
            child: _buildImageRow(
              'assets/variant1.png',
              'assets/variant4.png',
              'assets/variant2.png',
            ),
          ),
          // Rectangle gradient di belakang text, dibuat invisible (opacity 0)
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: Opacity(
              opacity: 0,
              child: Container(
                height: MediaQuery.of(context).size.height * 0.5,
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Color(0xFFFFFFFF), // putih 100%
                      Color(0xFFFFFFFF), // tahan putih di area atas
                      Color(0x00AABCF4), // AABCF4 transparan 0%
                    ],
                    stops: [0.0, 0.4, 1.0], // atur 40% bagian atas tetap putih
                  ),
                ),
              ),
            ),
          ),

          SafeArea(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start, 
              crossAxisAlignment: CrossAxisAlignment.stretch, 
              children: [
                // Container sekarang akan benar-benar full lebar dan full ke atas tanpa margin
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.fromLTRB(24, 56, 24, 16), // Top padding lebih besar untuk kompensasi status bar
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
                          style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xff1843C3)),
                        ),
                      ],
                    ),
                    textAlign: TextAlign.center,
                    softWrap: true,
                  ),
                ),
                // 4. Kembalikan Spacer tunggal untuk mendorong tombol ke bawah
                const Spacer(), 
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 40.0),
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF2C59E5),
                      foregroundColor: Colors.white,
                      minimumSize: const Size(double.infinity, 56),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    onPressed: () {
                      context.read<AuthStateCubit>().finishWelcomeScreen();
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Yuk mulai cobain', style: TextStyle(fontSize: 16)),
                        SizedBox(width: 34),
                        Row(children: [
                          Icon(Icons.arrow_forward_ios, size: 14, color: Colors.white.withOpacity(0.3)),
                          Icon(Icons.arrow_forward_ios, size: 14, color: Colors.white.withOpacity(0.6)),
                          Icon(Icons.arrow_forward_ios, size: 14, color: Colors.white.withOpacity(1)),
                        ]),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
  Widget _buildImageRow(String path1, String path2, String path3) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Expanded(
          child: Image.asset(
            path1,
            fit: BoxFit.cover,
          ),
        ),
        Expanded(
          child: Image.asset(
            path2,
            fit: BoxFit.cover,
          ),
        ),
        Expanded(
          child: Image.asset(
            path3,
            fit: BoxFit.cover,
          ),
        ),
      ],
    );
  }
}