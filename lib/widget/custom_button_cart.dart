import 'package:flutter/material.dart';

class CustomButtonCart extends StatelessWidget {
  final VoidCallback onPressed;
  final String text;
  final IconData icon;
  final double? width;

  const CustomButtonCart({
    super.key,
    required this.onPressed,
    this.text = "Keranjang",
    this.icon = Icons.add,
    this.width,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      child: ElevatedButton.icon(
        onPressed: onPressed,
        icon: Icon(icon),
        label: Text(text),
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF3D5AFE),
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.0),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
          textStyle: const TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}