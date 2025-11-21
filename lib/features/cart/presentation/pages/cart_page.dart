// lib/features/cart/presentation/cart_page.dart

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gmedia_project/features/cart/presentation/cubit/cart_cubit.dart';
import 'package:gmedia_project/features/cart/presentation/cubit/cart_state.dart';
import 'package:gmedia_project/features/cart/domain/entity/cart_item_entity.dart';
import 'package:gmedia_project/features/cart/presentation/widget/item_cart_widget.dart';
import 'package:gmedia_project/features/cart/presentation/widget/total_pay_widget.dart';
import 'package:intl/intl.dart';

class CartPage extends StatelessWidget {
  const CartPage({super.key});

  @override
  Widget build(BuildContext context) {
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
      body: BlocBuilder<CartCubit, CartState>(
        builder: (context, state) {
          final isLoaded = state is CartLoaded;
          List<CartItemEntity> items = [];
          int totalPrice = 0;
          int totalItems = 0;
          if (isLoaded) {
            final loaded = state; // keep explicit for readability despite lint
            items = loaded.items;
            totalPrice = loaded.totalPrice;
            totalItems = loaded.totalItems;
          }
          final formattedTotalPrice = NumberFormat(
            '#,###',
            'id_ID',
          ).format(totalPrice);

          return Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(20),
                  child: Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.05),
                          blurRadius: 10,
                          offset: const Offset(0, 5),
                        ),
                      ],
                    ),
                    child: items.isEmpty
                        ? SizedBox(
                            height: 240,
                            child: Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: const [
                                  Icon(
                                    Icons.shopping_cart_outlined,
                                    size: 80,
                                    color: Colors.grey,
                                  ),
                                  SizedBox(height: 16),
                                  Text(
                                    'Keranjang Anda kosong',
                                    style: TextStyle(
                                      fontSize: 18,
                                      color: Colors.grey,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          )
                        : Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              ...items.asMap().entries.map((entry) {
                                int index = entry.key;
                                var item = entry.value;
                                return Column(
                                  children: [
                                    ItemCartWidget(
                                      cartItem: item,
                                      onDelete: () => context
                                          .read<CartCubit>()
                                          .removeProduct(item.product.id),
                                      onQuantityChanged: (newQty) => context
                                          .read<CartCubit>()
                                          .updateQuantity(
                                            item.product.id,
                                            newQty,
                                          ),
                                    ),
                                    if (index != items.length - 1)
                                      const Padding(
                                        padding: EdgeInsets.symmetric(
                                          horizontal: 16,
                                        ),
                                        child: Divider(
                                          height: 1,
                                          color: Color(0xFFEEEEEE),
                                        ),
                                      ),
                                  ],
                                );
                              }),
                              const Padding(
                                padding: EdgeInsets.symmetric(
                                  horizontal: 16,
                                  vertical: 8,
                                ),
                                child: Divider(
                                  height: 1,
                                  color: Color(0xFFEEEEEE),
                                ),
                              ),
                              InkWell(
                                onTap: () {},
                                child: Padding(
                                  padding: const EdgeInsets.all(16.0),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        'Bayar menggunakan',
                                        style: TextStyle(
                                          color: Colors.grey[600],
                                          fontSize: 14,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                      const Icon(
                                        Icons.chevron_right,
                                        color: Colors.grey,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                  ),
                ),
              ),
              Container(
                color: Colors.white,
                padding: const EdgeInsets.all(16.0),
                margin: const EdgeInsets.only(bottom: 72),
                child: TotalPayWidget(
                  totalPrice: 'Rp $formattedTotalPrice',
                  totalItems: totalItems,
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
