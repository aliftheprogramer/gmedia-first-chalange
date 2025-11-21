// lib/main_test.dart

import 'package:flutter/material.dart';
import 'package:gmedia_project/features/cart/presentation/pages/cart_page.dart';
// Pastikan import ini sesuai dengan lokasi file CartPage kamu

void main() {
  runApp(const TestApp());
}

class TestApp extends StatelessWidget {
  const TestApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false, // Menghilangkan pita "Debug" di pojok kanan atas
      theme: ThemeData(
        // Kita set warna dasar agar mirip dengan desain
        scaffoldBackgroundColor: Colors.white,
        primarySwatch: Colors.blue,
      ),
      home: const CartPage(), // Langsung memanggil halaman yang baru kita buat
    );
  }
}