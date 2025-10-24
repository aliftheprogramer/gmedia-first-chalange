import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gmedia_project/core/services/services_locator.dart';
import 'package:gmedia_project/features/home/presentation/cubit/product_sold/product_sold_cubit.dart';
import 'package:gmedia_project/features/product/domain/entity/product_entity_response.dart';
import 'package:gmedia_project/features/product/domain/usecase/get_list_product_usecase.dart';
import 'package:gmedia_project/widget/custom_button_cart.dart';
import 'package:logger/logger.dart';

class ProductSoldWidget extends StatelessWidget {
  const ProductSoldWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(create: (_){
      final cubit = ProductSoldCubit(sl<GetListProductUsecase>());
      cubit.fetchSoldProducts();
      return cubit;
    },
    child: Container(
      color: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(padding: const EdgeInsets.all(16.0), child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Produk yang dijual', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),),
              InkWell(
                onTap: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Menampilkan semua produk')),
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
                    Icon(Icons.arrow_forward_ios, size: 16, color: Colors.blue),
                  ],
                ),
              ),
            ],
          ) ,),
          const SizedBox(height: 12,)
          SizedBox(
            height: 260,
            child: BlocBuilder(builder: builder),
          )
        ],
      ),
    ));
  }
}

class ProductSoldItem extends StatelessWidget {
  final ProductEntityResponse product;
  const ProductSoldItem({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
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
          SizedBox(),
          Text(
            product.name,
            maxLines: 2,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w400),
          ),
          const SizedBox(height: 1),
          Text(
            'Rp ${product.price}',
            style: const TextStyle(
              fontSize: 14,
              color: Colors.grey,
              fontWeight: FontWeight.w300,
            ),
          ),
          CustomButtonCart(
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    '${product.name} telah ditambahkan ke keranjang',
                  ),
                  duration: Duration(seconds: 2),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
