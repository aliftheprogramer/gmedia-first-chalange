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
            height: 45,
            decoration: BoxDecoration(
              color: const Color(0xFF2C59E5),
              borderRadius: BorderRadius.circular(12),
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