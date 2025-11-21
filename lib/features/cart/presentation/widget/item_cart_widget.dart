// lib/features/cart/presentation/widget/item_cart_widget.dart

import 'package:flutter/material.dart';
import 'package:gmedia_project/features/cart/domain/entity/cart_item_entity.dart';
import 'package:intl/intl.dart';

class ItemCartWidget extends StatelessWidget {
  final CartItemEntity cartItem;
  final VoidCallback onDelete;
  final Function(int) onQuantityChanged;

  const ItemCartWidget({
    super.key,
    required this.cartItem,
    required this.onDelete,
    required this.onQuantityChanged,
  });

  @override
  Widget build(BuildContext context) {
    final formattedPrice = NumberFormat(
      '#,###',
      'id_ID',
    ).format(cartItem.product.price);
    final formattedTotalPrice = NumberFormat(
      '#,###',
      'id_ID',
    ).format(cartItem.totalPrice);

    return Container(
      // HAPUS: color: Colors.white,  <-- Agar transparan dan mengikuti warna parent
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 1. Bagian Gambar
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Image.network(
              cartItem.product.pictureUrl,
              width: 80,
              height: 80,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) => Container(
                width: 80,
                height: 80,
                color: Colors.grey[300],
                child: const Icon(Icons.image, color: Colors.grey),
              ),
            ),
          ),
          const SizedBox(width: 16),

          // 2. Bagian Info Produk (Nama & Harga)
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  cartItem.product.name,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Rp.$formattedPrice',
                  style: TextStyle(fontSize: 12, color: Colors.grey[500]),
                ),
                const SizedBox(height: 8),
                Text(
                  'Rp.$formattedTotalPrice',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: Colors.black54,
                  ),
                ),
              ],
            ),
          ),

          // 3. Bagian Aksi (Hapus & Counter)
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              InkWell(
                onTap: onDelete,
                child: Container(
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey.shade300),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    Icons.delete_outline,
                    size: 18,
                    color: Colors.grey[600],
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey.shade300),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    InkWell(
                      onTap: () {
                        if (cartItem.quantity > 1) {
                          onQuantityChanged(cartItem.quantity - 1);
                        }
                      },
                      child: const Icon(
                        Icons.remove,
                        size: 16,
                        color: Colors.black54,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Text(
                      '${cartItem.quantity}',
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(width: 12),
                    InkWell(
                      onTap: () {
                        onQuantityChanged(cartItem.quantity + 1);
                      },
                      child: const Icon(
                        Icons.add,
                        size: 16,
                        color: Colors.black54,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
