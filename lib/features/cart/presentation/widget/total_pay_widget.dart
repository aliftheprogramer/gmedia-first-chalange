// lib/features/cart/presentation/widget/total_pay_widget.dart

import 'package:flutter/material.dart';

class TotalPayWidget extends StatelessWidget {
  final String totalPrice;

  const TotalPayWidget({super.key, required this.totalPrice});

  @override
  Widget build(BuildContext context) {
    // Kita tidak lagi membungkus semuanya dengan satu container warna,
    // tapi menggunakan Row untuk memisahkan "Kotak Info" dan "Tombol".
    return Row(
      children: [
        // BAGIAN KIRI: Kotak Info (Icon + Harga)
        Expanded(
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: const Color(0xFFEBF0FF), // Warna background biru muda
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: const Color(0xFFC7D0F8),
              ), // Border tipis
            ),
            child: Row(
              children: [
                // 1. Ikon Keranjang dengan Badge
                Stack(
                  children: [
                    const Padding(
                      padding: EdgeInsets.all(4.0),
                      child: Icon(
                        Icons.shopping_cart_outlined,
                        color: Colors.grey,
                        size: 24,
                      ),
                    ),
                    Positioned(
                      right: 0,
                      top: 0,
                      child: Container(
                        padding: const EdgeInsets.all(4),
                        decoration: const BoxDecoration(
                          color: Colors.green, // Warna badge hijau
                          shape: BoxShape.circle,
                        ),
                        constraints: const BoxConstraints(
                          minWidth: 16,
                          minHeight: 16,
                        ),
                        child: const Text(
                          '6',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 8,
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                  ],
                ),

                // 2. Garis Putus-putus Vertikal (Custom Widget di bawah)
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 12),
                  child: SizedBox(
                    height: 30, // Tinggi garis pemisah
                    child: DashedLineVertical(),
                  ),
                ),

                // 3. Teks Total Tagihan
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Text(
                        "Total Tagihan:",
                        style: TextStyle(
                          fontSize: 11,
                          color: Color(0xFF6B82CA), // Biru agak pudar
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        totalPrice,
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF2D5BFF), // Biru utama
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),

        const SizedBox(width: 12), // Jarak antara kotak info dan tombol
        // BAGIAN KANAN: Tombol Bayar
        ElevatedButton(
          onPressed: () {},
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF2D5BFF),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            // Mengatur tinggi tombol agar sejajar dengan kotak info
            minimumSize: const Size(0, 56),
            elevation: 0,
            padding: const EdgeInsets.symmetric(horizontal: 32),
          ),
          child: const Text(
            "Bayar",
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
        ),
      ],
    );
  }
}

// Widget Kecil untuk membuat garis putus-putus vertikal
class DashedLineVertical extends StatelessWidget {
  const DashedLineVertical({super.key});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        final boxHeight = constraints.constrainHeight();
        const dashWidth = 1.0;
        const dashHeight = 3.0;
        final dashCount = (boxHeight / (2 * dashHeight)).floor();
        return Flex(
          direction: Axis.vertical,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: List.generate(dashCount, (_) {
            return SizedBox(
              width: dashWidth,
              height: dashHeight,
              child: const DecoratedBox(
                decoration: BoxDecoration(
                  color: Color(0xFFAAB8EC),
                ), // Warna garis
              ),
            );
          }),
        );
      },
    );
  }
}
