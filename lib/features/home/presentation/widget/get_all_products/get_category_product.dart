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
          late final Widget content;

          if (state is ProductSellLoading) {
            content = const Center(child: CircularProgressIndicator());
          } else if (state is ProductSellEmpty) {
            content = const Center(child: Text('Tidak ada produk yang dijual.'));
          } else if (state is ProductSellError) {
            content = Center(child: Text('Error: ${state.message}'));
          } else if (state is ProductSellLoaded) {
            final products = state.products.cast<ProductEntityResponse>();
            content = SingleChildScrollView(
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
          } else {
            content = const SizedBox.shrink();
          }

          return Container(
            color: Colors.white,
            padding: const EdgeInsets.all(16),
            child: content,

          );
        },
      ),
    );
  }
}
