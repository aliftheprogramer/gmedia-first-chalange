// lib/features/welcome/presentation/widgets/scrolling_column.dart

import 'package:flutter/material.dart';

enum ScrollDirection { up, down }

class ScrollingColumn extends StatefulWidget {
  final String imagePath;
  final Duration duration;
  final ScrollDirection scrollDirection;

  const ScrollingColumn({
    super.key,
    required this.imagePath,
    this.duration = const Duration(seconds: 20),
    this.scrollDirection = ScrollDirection.down,
  });

  @override
  State<ScrollingColumn> createState() => _ScrollingColumnState();
}

class _ScrollingColumnState extends State<ScrollingColumn> with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  
  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: widget.duration)..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;

    // 1. Bungkus dengan ClipRect untuk "memotong" gambar yang keluar dari area widget
    return ClipRect(
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          double offset = _controller.value * screenHeight;
          if (widget.scrollDirection == ScrollDirection.up) {
            offset = screenHeight - offset;
          }

          // 2. Gunakan Stack untuk menumpuk gambar
          return Stack(
            children: [
              // Gambar pertama
              Transform.translate(
                offset: Offset(0, offset),
                child: Image.asset(
                  widget.imagePath,
                  height: screenHeight,
                  fit: BoxFit.cover,
                  alignment: Alignment.center,
                ),
              ),
              // Gambar kedua (untuk efek looping)
              Transform.translate(
                offset: Offset(0, offset - screenHeight),
                child: Image.asset(
                  widget.imagePath,
                  height: screenHeight,
                  fit: BoxFit.cover,
                  alignment: Alignment.center,
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}