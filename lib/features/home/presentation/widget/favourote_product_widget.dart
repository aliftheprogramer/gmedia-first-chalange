import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:logger/logger.dart';
import 'package:gmedia_project/core/services/services_locator.dart';
import 'package:gmedia_project/features/home/presentation/cubit/favorite_product_cubit.dart';
import 'package:gmedia_project/features/home/presentation/cubit/favorite_product_state.dart';
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Diminati Pembeli 😍'),
          const SizedBox(height: 12),
          SizedBox(
            height: 180,
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
    );
  }
}

class _FavoriteProductItem extends StatelessWidget {
  final ProductEntityResponse product;

  const _FavoriteProductItem({required this.product});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 140,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: SizedBox(
              width: 140,
              height: 100,
              child: Builder(builder: (context) {
                if (product.pictureUrl.isEmpty) {
                  return Container(
                    color: Colors.grey[200],
                    child: const Center(child: Icon(Icons.image, color: Colors.grey)),
                  );
                }

                // Normalize http -> https to avoid mixed-content blocks on web
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
                      // fallback to print if logger isn't available
                      // ignore: avoid_print
                      print('Image load error: $url -> $error');
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
          const SizedBox(height: 8),
          Text(
            product.name,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 4),
          Text(
            'Rp ${product.price}',
            style: const TextStyle(fontSize: 13, color: Colors.grey),
          ),
        ],
      ),
    );
  }
}
