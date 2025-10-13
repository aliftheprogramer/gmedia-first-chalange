// lib/widget/custom_navbar.dart

import 'package:flutter/material.dart';
import 'bottom_nav_painter.dart'; // Import painter yang sudah benar

class CustomBottomNavBar extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;

  const CustomBottomNavBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 85, // Tinggi total widget navbar
      child: Stack(
        children: [
          // 1. Gambar latar belakang kustom kita menggunakan CustomPaint
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: CustomPaint(
              size: const Size(double.infinity, 85),
              painter: BottomNavPainter(),
            ),
          ),
          // 2. Letakkan tombol-tombol di dalam sebuah Row
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: SizedBox(
              height: 85,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.center, // Sejajarkan semua item di tengah
                children: [
                  // Tombol Home
                  _buildNavItem(
                    icon: Icons.home_filled,
                    index: 0,
                    isSelected: currentIndex == 0,
                    onTap: () => onTap(0),
                  ),
                  
                  // Tombol Tengah (+ biru)
                  SizedBox(
                    width: 95,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: () => onTap(1),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF2C59E5),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        elevation: 0, // Tidak perlu shadow, sudah ada di painter
                      ),
                      child: const Icon(Icons.add, color: Colors.white, size: 32),
                    ),
                  ),
                  
                  // Tombol Profile
                  _buildNavItem(
                    icon: Icons.person_outline,
                    index: 2,
                    isSelected: currentIndex == 2,
                    onTap: () => onTap(2),
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget _buildNavItem({required IconData icon, required int index, required bool isSelected, required VoidCallback onTap}) {
    final color = isSelected ? const Color(0xFF2C59E5) : Colors.grey[800];
    return IconButton(
      icon: Icon(icon, color: color, size: 30),
      onPressed: onTap,
    );
  }
}