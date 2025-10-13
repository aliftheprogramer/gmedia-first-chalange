// lib/widget/bottom_nav_painter.dart

import 'package:flutter/material.dart';

class BottomNavPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;

    Path path = Path();

    const double topY = 15.0;
    double center = size.width / 2;
    double bumpWidth = 110.0;
    double bumpHeight = 15.0;

    path.moveTo(0, size.height);
    path.lineTo(size.width, size.height);
    path.lineTo(size.width, topY);

    path.lineTo(center + (bumpWidth / 2), topY);

    path.lineTo(center + (bumpWidth / 2) - bumpHeight, 0);

    path.lineTo(center - (bumpWidth / 2) + bumpHeight, 0);
    path.lineTo(center - (bumpWidth / 2), topY);
    path.lineTo(0, topY);

    // Tutup path
    path.close();

    canvas.drawShadow(path, Colors.black.withOpacity(0.1), 8.0, false);
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }
}
