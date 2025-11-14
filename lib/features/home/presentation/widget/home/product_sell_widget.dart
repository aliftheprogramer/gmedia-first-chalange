import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gmedia_project/core/services/services_locator.dart';
import 'package:gmedia_project/features/home/presentation/cubit/product_sell/product_sell_cubit.dart';
import 'package:gmedia_project/features/home/presentation/cubit/product_sell/product_sell_state.dart';
import 'package:gmedia_project/features/home/presentation/pages/get_all_products_screen.dart';
import 'package:gmedia_project/features/product/domain/entity/product_entity_response.dart';
import 'package:gmedia_project/features/product/domain/usecase/get_list_product_usecase.dart';
import 'package:gmedia_project/widget/custom_button_cart.dart';
import 'package:intl/intl.dart';
import 'package:logger/logger.dart';

class ProductSellWidget extends StatelessWidget {
  const ProductSellWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) {
        final cubit = ProductSellCubit(sl<GetListProductUsecase>());
        cubit.fetchSoldProducts();
        return cubit;
      },
      child: Container(
        color: Colors.white,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Produk yang dijual',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  InkWell(
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => const GetAllProductsScreen(),
                        ),
                      );
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Menampilkan semua produk'),
                        ),
                      );
                    },
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: const [
                        Text(
                          'Lihat Semua',
                          style: TextStyle(
                            color: Colors.blue,
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        SizedBox(width: 6),
                        Icon(
                          Icons.arrow_forward_ios,
                          size: 16,
                          color: Colors.blue,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),
            // Use a grid with 2 columns; let parent ListView scroll (so grid is shrinkWrapped)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: BlocBuilder<ProductSellCubit, ProductSellState>(
                builder: (context, state) {
                  if (state is ProductSellLoading) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  if (state is ProductSellEmpty) {
                    return const Center(
                      child: Text('Tidak ada produk yang dijual.'),
                    );
                  }

                  if (state is ProductSellError) {
                    return Center(child: Text('Error: ${state.message}'));
                  }

                  if (state is ProductSellLoaded) {
                    final products = state.products
                        .cast<ProductEntityResponse>();
                    return GridView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 2,
                                  mainAxisSpacing: 12,
                                  crossAxisSpacing: 12,
                                  // make items taller by reducing the aspect ratio
                                  childAspectRatio: 0.62,
                                ),
                      itemCount: products.length,
                      itemBuilder: (context, index) {
                        final p = products[index];
                        return ProductSellItem(product: p);
                      },
                    );
                  }

                  return const SizedBox.shrink();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ProductSellItem extends StatelessWidget {
  final String formattedPrice;

  final ProductEntityResponse product;
  ProductSellItem({super.key, required this.product})
    : formattedPrice = NumberFormat('#,###', 'id_ID').format(product.price);

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.transparent, // transparan, tanpa background
      elevation: 0, // hilangin bayangan
      shadowColor: Colors.transparent, // biar gak ada efek shadow
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Let the image take the available top space so the card can be taller
          Expanded(
            flex: 6,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: SizedBox(
                width: double.infinity,
                child: Builder(
                  builder: (context) {
                    if (product.pictureUrl.isEmpty) {
                      return Container(
                        color: Colors.grey[200],
                        child: const Center(
                          child: Icon(Icons.image, color: Colors.grey),
                        ),
                      );
                    }

                    String imageUrl = product.pictureUrl.trim();
                    if (imageUrl.startsWith('http://')) {
                      imageUrl = imageUrl.replaceFirst('http://', 'https://');
                    }

                    final logger = sl<Logger>();

                    return CachedNetworkImage(
                      imageUrl: imageUrl,
                      fit: BoxFit.cover,
                      placeholder: (context, url) => Container(
                        color: Colors.grey[200],
                        child: const Center(
                          child: CircularProgressIndicator(strokeWidth: 2),
                        ),
                      ),
                      errorWidget: (context, url, error) {
                        try {
                          logger.e('Failed loading product image');
                        } catch (_) {
                          logger.e('Image load error: $url -> $error');
                        }
                        return Container(
                          color: Colors.grey[200],
                          child: const Center(
                            child: Icon(Icons.broken_image, color: Colors.grey),
                          ),
                        );
                      },
                    );
                  },
                ),
              ),
            ),
          ),
          const SizedBox(height: 8),
          // Make title flexible to avoid overflow and ensure ellipsis
          Flexible(
            flex: 2,
            child: Text(
              product.name,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'Rp.$formattedPrice',
            style: const TextStyle(
              fontSize: 14,
              color: Colors.grey,
              fontWeight: FontWeight.w400,
              height: 1.2,
            ),
          ),
          const SizedBox(height: 8),
          // Constrain the button height so it won't overflow
          SizedBox(
            height: 40,
            width: double.infinity,
            child: CustomButtonCart(
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      '${product.name} telah ditambahkan ke keranjang',
                    ),
                    duration: const Duration(seconds: 2),
                  ),
                );
              },
              width: double.infinity,
            ),
          ),
        ],
      ),
    );
  }
}
