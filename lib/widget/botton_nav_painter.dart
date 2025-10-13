// lib/widget/bottom_nav_painter.dart

import 'package:flutter/material.dart';

class BottomNavPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    // Definisikan kuas untuk menggambar
    Paint paint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;
    
    // Definisikan path (jalur) untuk menggambar
    Path path = Path();
    path.moveTo(0, 20); // Mulai dari sedikit ke bawah di kiri

    // Kurva landai di sisi kiri
    path.quadraticBezierTo(size.width * 0.20, 0, size.width * 0.35, 0);
    
    // Kurva "bukit" di tengah untuk tombol
    path.quadraticBezierTo(size.width * 0.40, 0, size.width * 0.40, 20);
    path.arcToPoint(Offset(size.width * 0.60, 20), radius: const Radius.circular(20.0), clockwise: false);
    
    // Kurva landai di sisi kanan
    path.quadraticBezierTo(size.width * 0.60, 0, size.width * 0.65, 0);
    path.quadraticBezierTo(size.width * 0.80, 0, size.width, 20);

    // Garis lurus ke bawah dan tutup path
    path.lineTo(size.width, size.height);
    path.lineTo(0, size.height);
    path.close();

    // Gambar shadow
    canvas.drawShadow(path, Colors.black.withOpacity(0.15), 10, true);
    // Gambar path putih di atasnya
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }
}