import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:intl/intl.dart';
import 'package:logger/logger.dart';
import 'package:gmedia_project/core/services/services_locator.dart';
import 'package:gmedia_project/features/home/presentation/cubit/favorite/favorite_product_cubit.dart';
import 'package:gmedia_project/features/home/presentation/cubit/favorite/favorite_product_state.dart';
import 'package:gmedia_project/features/product/domain/entity/product_entity_response.dart';
import 'package:gmedia_project/features/product/domain/usecase/get_list_product_usecase.dart';

class FavouroteProductWidget extends StatelessWidget {
  const FavouroteProductWidget({super.key});
  

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) {
        final cubit = FavoriteProductCubit(sl<GetListProductUsecase>());
        cubit.fetchFavorites();
        return cubit;
      },
      child: Container(
        color: Colors.white,
        child: Column(
          
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: const Text('Diminati Pembeli 😍', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
            ),
            const SizedBox(height: 12),
            SizedBox(
              height: 220,
              child: BlocBuilder<FavoriteProductCubit, FavoriteProductState>(
                builder: (context, state) {
                  if (state is FavoriteProductLoading) {
                    return const Center(child: CircularProgressIndicator());
                  }
        
                  if (state is FavoriteProductEmpty) {
                    return const Center(child: Text('Tidak ada produk favorit.'));
                  }
        
                  if (state is FavoriteProductError) {
                    return Center(child: Text('Error: ${state.message}'));
                  }
        
                  if (state is FavoriteProductLoaded) {
                    final products = state.products.cast<ProductEntityResponse>();
                    return ListView.separated(
                      scrollDirection: Axis.horizontal,
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      itemCount: products.length,
                      separatorBuilder: (_, __) => const SizedBox(width: 12),
                      itemBuilder: (context, index) {
                        final p = products[index];
                        return _FavoriteProductItem(product: p);
                      },
                    );
                  }
        
                  // Default placeholder for initial state
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

class _FavoriteProductItem extends StatelessWidget {
  final String formattedPrice;

  final ProductEntityResponse product;

   _FavoriteProductItem({required this.product}) : formattedPrice = NumberFormat('#,###', 'id_ID').format(product.price);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 160,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(8, 0, 8, 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
              child: SizedBox(
              width: double.infinity,
              height: 140,
              child: Builder(builder: (context) {
                if (product.pictureUrl.isEmpty) {
                  return Container(
                    color: Colors.grey[200],
                    child: const Center(child: Icon(Icons.image, color: Colors.grey)),
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
                    child: const Center(child: CircularProgressIndicator(strokeWidth: 2)),
                  ),
                  errorWidget: (context, url, error) {
                    // Log details for debugging
                    try {
                      logger.e('Failed loading product image');
                    } catch (_) {
                      logger.e('Image load error: $url -> $error');
                    }
                    return Container(
                      color: Colors.grey[200],
                      child: const Center(child: Icon(Icons.broken_image, color: Colors.grey)),
                    );
                  },
                );
              }),
            ),
          ),
          const SizedBox(height: 10),
          
          Text(
            product.name,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
          ),
          const SizedBox(height: 6),
          
          Text(
            'Rp.$formattedPrice',
            style: const TextStyle(
              fontSize: 14,
              color: Colors.grey,
              fontWeight: FontWeight.w400,
              height: 1.2, 
            ),
          ),

        
        ],
      ),
    ),
  );
  }
}
