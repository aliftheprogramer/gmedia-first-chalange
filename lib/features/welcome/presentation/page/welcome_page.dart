// lib/pages/welcome_page.dart

import 'package:flutter/material.dart';
// Ganti dengan path cubit Anda yang benar jika diperlukan
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:gmedia_project/common/bloc/auth/auth_cubit.dart';

class WelcomePage extends StatelessWidget {
  const WelcomePage({super.key});

  // DIHAPUS: List gambar dan fungsi _buildImageCircle tidak lagi digunakan.

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // DIUBAH: Urutan layer di dalam Stack diatur ulang.

          // LAPISAN 1 (PALING BELAKANG): Wallpaper gambar.
          Positioned.fill(
            child: _buildWallpaper(),
          ),

          // LAPISAN 2: Gradient overlay (semi-transparan) di atas wallpaper.
          // Ini memberi efek warna pada wallpaper di belakangnya.
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  // Diberi sedikit opacity agar gambar wallpaper tetap terlihat
                  Colors.white.withOpacity(0.1),
                  const Color(0xFFAABCF4).withOpacity(0.8),
                ],
              ),
            ),
          ),

          // LAPISAN 3: Gradient Putih di Atas untuk Keterbacaan Teks (tetap ada)
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
                        borderRadius: BorderRadius.circular(16),
                      ),
                      elevation: 5,
                    ),
                    onPressed: () {
                      // context.read<AuthStateCubit>().finishWelcomeScreen();
                      print('Tombol "Yuk mulai cobain" ditekan!');
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
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
              ],
            ),
          ),
        ],
      ),
    );
  }

  // BARU: Fungsi untuk membuat wallpaper layar penuh dari tiga gambar.
  Widget _buildWallpaper() {
    return Row(
      // crossAxisAlignment.stretch membuat anak-anak Row meregang secara vertikal.
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Expanded memastikan setiap gambar mengambil sepertiga dari lebar layar.
        Expanded(
          child: Image.asset(
            'assets/variant1.png',
            // BoxFit.cover membuat gambar memenuhi ruang tanpa merusak rasio aspeknya.
            fit: BoxFit.cover,
          ),
        ),
        Expanded(
          child: Image.asset(
            'assets/variant2.png',
            fit: BoxFit.cover,
          ),
        ),
        Expanded(
          child: Image.asset(
            'assets/variant3.png',
            fit: BoxFit.cover,
          ),
        ),
      ],
    );
  }
}