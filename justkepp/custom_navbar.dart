// lib/widget/custom_navbar.dart

import 'package:flutter/material.dart';


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
      height: 90, // Tinggi total termasuk bump
      child: Stack(
        children: [
          // Background navbar dengan bump di tengah
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: CustomPaint(
              size: const Size(double.infinity, 90),
              painter: NavBarBumpPainter(),
            ),
          ),
          
          // Item navbar
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            height: 70,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Tombol Home
                _buildNavItem(
                  icon: Icons.home,
                  index: 0,
                  isSelected: currentIndex == 0,
                  onTap: () => onTap(0),
                ),
                
                // Tombol Tengah (+ biru)
                Container(
                  width: 100,
                  height: 50,
                  decoration: BoxDecoration(
                    color: const Color(0xFF2C59E5),
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: IconButton(
                    onPressed: () => onTap(1),
                    icon: const Icon(Icons.add, color: Colors.white, size: 28),
                    padding: EdgeInsets.zero,
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
        ],
      ),
    );
  }

  Widget _buildNavItem({
    required IconData icon,
    required int index,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    final color = isSelected ? const Color(0xFF2C59E5) : Colors.grey[600];
    return IconButton(
      icon: Icon(icon, color: color, size: 28),
      onPressed: onTap,
      padding: EdgeInsets.zero,
    );
  }
}

// Painter untuk background navbar dengan bump berbentuk /---\
class NavBarBumpPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;

    final path = Path();
    
    final double centerX = size.width / 2;
    final double bumpWidth = 120.0; // Lebar bagian datar atas
    final double slopeWidth = 25.0; // Lebar bagian miring kiri & kanan
    final double bumpHeight = 20.0; // Tinggi bump ke atas
    final double navBarHeight = 70.0; // Tinggi navbar normal
    
    // Mulai dari kiri bawah
    path.moveTo(0, size.height);
    
    // Garis kiri (datar)
    path.lineTo(0, size.height - navBarHeight);
    
    // Garis horizontal kiri menuju bump
    path.lineTo(centerX - bumpWidth / 2 - slopeWidth, size.height - navBarHeight);
    
    // Garis miring naik / (diagonal ke atas kanan)
    path.lineTo(centerX - bumpWidth / 2, size.height - navBarHeight - bumpHeight);
    
    // Garis horizontal di atas --- (bagian datar)
    path.lineTo(centerX + bumpWidth / 2, size.height - navBarHeight - bumpHeight);
    
    // Garis miring turun \ (diagonal ke bawah kanan)
    path.lineTo(centerX + bumpWidth / 2 + slopeWidth, size.height - navBarHeight);
    
    // Garis horizontal kanan
    path.lineTo(size.width, size.height - navBarHeight);
    
    // Garis kanan (datar)
    path.lineTo(size.width, size.height);
    
    // Tutup path
    path.close();
    
    // Shadow
    canvas.drawShadow(path, Colors.black.withOpacity(0.1), 10, false);
    
    // Draw background
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}