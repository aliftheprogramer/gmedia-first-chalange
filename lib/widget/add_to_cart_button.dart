import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gmedia_project/features/cart/presentation/cubit/cart/cart_cubit.dart';
import 'package:gmedia_project/features/product/domain/entity/product_entity_response.dart';
import 'package:gmedia_project/core/services/services_locator.dart';

class AddToCartButton extends StatelessWidget {
  final ProductEntityResponse product;
  final double height;
  final double? width;
  final BorderRadius borderRadius;

  const AddToCartButton({
    super.key,
    required this.product,
    this.height = 40,
    this.width,
    this.borderRadius = const BorderRadius.all(Radius.circular(8)),
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      width: width ?? double.infinity,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF2C59E5),
          foregroundColor: Colors.white,
          elevation: 0,
          shape: RoundedRectangleBorder(borderRadius: borderRadius),
          padding: const EdgeInsets.symmetric(horizontal: 12),
        ),
        onPressed: () {
          // Try context provider first, fallback to service locator for robustness.
          CartCubit? cubit;
          try {
            cubit = context.read<CartCubit>();
          } catch (_) {
            cubit = sl<CartCubit>();
          }
          cubit.addProduct(product);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('${product.name} ditambahkan ke keranjang'),
              duration: const Duration(seconds: 2),
            ),
          );
        },
        child: const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.add_shopping_cart, size: 18),
            SizedBox(width: 6),
            Text('Tambah'),
          ],
        ),
      ),
    );
  }
}
