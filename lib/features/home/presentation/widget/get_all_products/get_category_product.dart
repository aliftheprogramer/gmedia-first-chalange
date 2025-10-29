import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gmedia_project/core/services/services_locator.dart';
import 'package:gmedia_project/features/home/presentation/cubit/product_sell/product_sell_cubit.dart';
import 'package:gmedia_project/features/home/presentation/cubit/product_sell/product_sell_state.dart';
import 'package:gmedia_project/features/home/presentation/widget/home/product_sell_widget.dart';
import 'package:gmedia_project/features/product/domain/entity/product_entity_response.dart';
import 'package:gmedia_project/features/product/domain/usecase/get_list_product_usecase.dart';

class ProductsPlaceholder extends StatelessWidget {
  const ProductsPlaceholder({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_){
        final cubit = ProductSellCubit(sl <GetListProductUsecase>());
        cubit.fetchSoldProductsAll();
        return cubit;
      },
      child: BlocBuilder<ProductSellCubit, ProductSellState>(
        builder: (context, state) {
          if (state is ProductSellLoading) {
            return const Center(child: CircularProgressIndicator());
          }
      
          if (state is ProductSellEmpty) {
            return const Center(child: Text('Tidak ada produk yang dijual.'));
          }
      
          if (state is ProductSellError) {
            return Center(child: Text('Error: ${state.message}'));
          }
      
          if (state is ProductSellLoaded) {
            final products = state.products.cast<ProductEntityResponse>();
            return SingleChildScrollView(
              child: GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisSpacing: 12,
                  crossAxisSpacing: 12,
                  childAspectRatio: 0.9,
                ),
                itemCount: products.length,
                itemBuilder: (context, index) {
                  final p = products[index];
                  return ProductSellItem(product: p);
                },
              ),
            );
          }
      
          return const SizedBox.shrink();
        },
      ),
    );
  }
}
