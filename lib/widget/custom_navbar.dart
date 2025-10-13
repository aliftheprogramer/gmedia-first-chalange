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
    return Container(
      height: 70,
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Tombol Home
              _buildNavItem(
                context,
                icon: Icons.home,
                index: 0,
                isSelected: currentIndex == 0,
              ),
              
              // Tombol Tengah (+ biru)
              Container(
                width: 110,
                height: 50,
                decoration: BoxDecoration(
                  color: const Color(0xFF2C59E5),
                  borderRadius: BorderRadius.circular(25),
                ),
                child: IconButton(
                  icon: const Icon(Icons.add, color: Colors.white, size: 28),
                  onPressed: () => onTap(1),
                ),
              ),
              
              // Tombol Profile
              _buildNavItem(
                context,
                icon: Icons.person_outline,
                index: 2,
                isSelected: currentIndex == 2,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem(BuildContext context, {required IconData icon, required int index, required bool isSelected}) {
    final color = isSelected ? const Color(0xFF2C59E5) : Colors.grey[800];
    return IconButton(
      icon: Icon(icon, color: color, size: 30),
      onPressed: () => onTap(index),
    );
  }
}