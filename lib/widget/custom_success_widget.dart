import 'package:flutter/material.dart';

class CustomSuccessWidget extends StatelessWidget {
  final VoidCallback? onBack;
  final VoidCallback? onAddAnother;

  const CustomSuccessWidget({super.key, this.onBack, this.onAddAnother});

  @override
  Widget build(BuildContext context) {
    // Menggunakan Container untuk membuat tampilan bottom sheet
    // dengan sudut membulat di bagian atas.
    return Container(
      // Padding untuk memberi jarak konten dari tepi
      padding: const EdgeInsets.fromLTRB(24.0, 12.0, 24.0, 32.0),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(20.0),
        ),
      ),
      // Column untuk menampung semua elemen secara vertikal
      child: Column(
        mainAxisSize: MainAxisSize.min, // Agar tinggi bottom sheet pas dengan konten
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Garis handle abu-abu di bagian atas
          Container(
            width: 40.0,
            height: 4.0,
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(2.0),
            ),
          ),
          const SizedBox(height: 24.0),

          // Placeholder untuk ilustrasi.
          // Anda bisa menggantinya dengan Image.asset('path/to/your/image.png')
          const Icon(
            Icons.check_circle_outline,
            color: Colors.blue, // Menggunakan warna biru seperti di screenshot
            size: 100.0,
          ),
          const SizedBox(height: 24.0),

          // Teks Judul
          const Text(
            "Yeay, Berhasil!",
            style: TextStyle(
              fontSize: 22.0,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 12.0),

          // Teks Subjudul
          Text(
            "Produk kamu sudah masuk daftar! Yuk, tambahin lagi.",
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 16.0,
              color: Colors.grey[600], // Warna abu-abu untuk subjudul
            ),
          ),
          const SizedBox(height: 32.0),

          // Baris untuk menampung kedua tombol
          Row(
            children: [
              // Tombol "Kembali"
              Expanded(
                child: OutlinedButton(
                  onPressed: onBack,
                  style: OutlinedButton.styleFrom(
                    foregroundColor: Colors.blue,
                    side: const BorderSide(color: Colors.blue, width: 1.5),
                    padding: const EdgeInsets.symmetric(vertical: 16.0),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                  ),
                  child: const Text(
                    "Kembali",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                  ),
                ),
              ),
              const SizedBox(width: 16.0), // Jarak antar tombol

              // Tombol "Tambah poduk"
              Expanded(
                child: ElevatedButton(
                  onPressed: onAddAnother,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16.0),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                    elevation: 0, // Memberi kesan flat
                  ),
                  child: const Text(
                    "Tambah poduk",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}