// lib/features/home/presentation/pages/get_all_products_screen.dart

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gmedia_project/features/category/presentation/widget/list_category_widget.dart';
import 'package:gmedia_project/features/home/presentation/widget/custom_search_bar.dart';
import 'package:gmedia_project/features/home/presentation/widget/get_all_products/get_all_product.dart';
import 'package:gmedia_project/features/home/presentation/widget/home/home_app_bar.dart';
import 'package:gmedia_project/navigation/cubit/navigation_cubit.dart';
import 'package:gmedia_project/widget/custom_bottom_navigator.dart';
import 'package:gmedia_project/core/services/services_locator.dart';
import 'package:gmedia_project/features/category/presentation/cubit/category_cubit.dart';
import 'package:gmedia_project/features/category/domain/usecase/get_all_category_usecase.dart';
import 'package:gmedia_project/features/category/presentation/cubit/category_state.dart';
import 'package:gmedia_project/features/home/presentation/cubit/product_sell/product_sell_cubit.dart';
import 'package:gmedia_project/features/product/domain/usecase/get_list_product_usecase.dart';
import 'package:gmedia_project/features/cart/presentation/cubit/cart_cubit.dart';

class GetAllProductsScreen extends StatefulWidget {
  const GetAllProductsScreen({super.key});

  @override
  State<GetAllProductsScreen> createState() => _GetAllProductsScreenState();
}

class _GetAllProductsScreenState extends State<GetAllProductsScreen> {
  final TextEditingController _searchCtrl = TextEditingController();

  @override
  void dispose() {
    _searchCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<NavigationCubit, int>(
      builder: (context, navIndex) {
        return MultiBlocProvider(
          providers: [
            BlocProvider<CategoryCubit>(
              create: (_) {
                final cubit = CategoryCubit(sl<GetAllCategoryUsecase>());
                cubit.fetchCategories();
                return cubit;
              },
            ),
            BlocProvider<ProductSellCubit>(
              create: (_) {
                final cubit = ProductSellCubit(sl<GetListProductUsecase>());
                cubit.fetchSoldProductsAll();
                return cubit;
              },
            ),
            // Provide CartCubit here so ProductSellItem can access it when navigated via this standalone screen
            BlocProvider<CartCubit>(create: (_) => sl<CartCubit>()),
          ],
          child: Scaffold(
            extendBody: true,
            backgroundColor: Colors.white,
            appBar: HomeAppBar(
              onCartTap: () {
                // Navigate to cart via NavigationCubit index then return to root if needed
                context.read<NavigationCubit>().updateIndex(1);
                Navigator.of(context).popUntil((route) => route.isFirst);
              },
              onProfileTap: () {
                context.read<NavigationCubit>().updateIndex(2);
                Navigator.of(context).popUntil((route) => route.isFirst);
              },
            ),
            bottomNavigationBar: CustomBottomNavigator(
              currentIndex: navIndex,
              onTap: (index) {
                if (index != navIndex) {
                  context.read<NavigationCubit>().updateIndex(index);
                }
                Navigator.of(context).popUntil((route) => route.isFirst);
              },
            ),
            body: BlocListener<CategoryCubit, CategoryState>(
              listener: (context, catState) {
                final prodCubit = context.read<ProductSellCubit>();
                final search = _searchCtrl.text.trim();
                if (catState is CategoryIsClicked) {
                  prodCubit.fetchByFilter(
                    categoryId: catState.categoryId,
                    search: search.isEmpty ? null : search,
                  );
                } else if (catState is CategoryLoaded &&
                    catState.selectedId == null) {
                  prodCubit.fetchByFilter(
                    categoryId: null,
                    search: search.isEmpty ? null : search,
                  );
                }
              },
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const SizedBox(height: 24),
                  SearchBarWidget(
                    controller: _searchCtrl,
                    onChanged: (value) {
                      final catId = context.read<CategoryCubit>().selectedId;
                      context.read<ProductSellCubit>().fetchByFilter(
                        categoryId: catId,
                        search: value.isEmpty ? null : value,
                      );
                    },
                    onSubmitted: (value) {
                      final catId = context.read<CategoryCubit>().selectedId;
                      context.read<ProductSellCubit>().fetchByFilter(
                        categoryId: catId,
                        search: value.isEmpty ? null : value,
                      );
                    },
                  ),
                  const SizedBox(height: 12),
                  const ListCategoryWidget(),
                  const SizedBox(height: 12),
                  const Expanded(child: ProductsPlaceholder()),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
