// lib/features/cart/presentation/cart_page.dart

import 'package:flutter/material.dart';
import 'package:gmedia_project/features/cart/presentation/widget/item_cart_widget.dart';
import 'package:gmedia_project/features/cart/presentation/widget/total_pay_widget.dart';

class CartPage extends StatelessWidget {
  const CartPage({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> items = [
      {
        "title": "Pepperoni cheese",
        "price": "Rp 45.000",
        "qty": 1,
        "image":
            "https://images.unsplash.com/photo-1628840042765-356cda07504e?q=80&w=200&auto=format&fit=crop",
      },
      {
        "title": "Pancake",
        "price": "Rp 45.000",
        "qty": 1,
        "image":
            "https://images.unsplash.com/photo-1567620905732-2d1ec7ab7445?q=80&w=200&auto=format&fit=crop",
      },
      {
        "title": "Cheese Burger",
        "price": "Rp 45.000",
        "qty": 1,
        "image":
            "https://images.unsplash.com/photo-1568901346375-23c9450c58cd?q=80&w=200&auto=format&fit=crop",
      },
    ];

    return Scaffold(
      backgroundColor: const Color(0xFFF5F6F8), // Warna background abu-abu muda
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {},
        ),
        title: const Text(
          "Daftar Pesanan",
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          // SCROLLABLE AREA (List Item + Bayar Menggunakan)
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20), // Jarak pinggir layar
              child: Container(
                // WIDGET CONTAINER PUTIH BESAR
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20), // Sudut melengkung
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.05),
                      blurRadius: 10,
                      offset: const Offset(0, 5),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // 1. Looping Item (Pake spread operator ... agar tidak butuh ListView lagi di dalam sini)
                    ...items.asMap().entries.map((entry) {
                      int index = entry.key;
                      var item = entry.value;

                      return Column(
                        children: [
                          ItemCartWidget(
                            title: item['title'],
                            price: item['price'],
                            quantity: item['qty'],
                            imageUrl: item['image'],
                          ),
                          // Tambahkan garis pemisah antar item (kecuali item terakhir)
                          if (index != items.length - 1)
                            const Padding(
                              padding: EdgeInsets.symmetric(horizontal: 16),
                              child: Divider(
                                height: 1,
                                color: Color(0xFFEEEEEE),
                              ),
                            ),
                        ],
                      );
                    }).toList(),

                    // Garis pemisah sebelum tombol "Bayar menggunakan"
                    const Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                      child: Divider(height: 1, color: Color(0xFFEEEEEE)),
                    ),

                    // 2. Bagian "Bayar menggunakan" (Masih di dalam Container Putih)
                    InkWell(
                      onTap: () {},
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Bayar menggunakan",
                              style: TextStyle(
                                color: Colors.grey[600],
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            const Icon(Icons.chevron_right, color: Colors.grey),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          // BOTTOM FIXED (Total Pay Widget)
          Container(
            color: Colors.white, // Background putih untuk area bawah
            padding: const EdgeInsets.all(16.0),
            child: const TotalPayWidget(totalPrice: "Rp 224.000"),
          ),
        ],
      ),
    );
  }
}
