// lib/features/home/presentation/pages/get_all_products_screen.dart

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gmedia_project/features/category/presentation/widget/list_category_widget.dart';
import 'package:gmedia_project/features/home/presentation/widget/custom_search_bar.dart';
import 'package:gmedia_project/features/home/presentation/widget/get_all_products/get_category_product.dart';
import 'package:gmedia_project/features/home/presentation/widget/home/home_app_bar.dart';
import 'package:gmedia_project/navigation/cubit/navigation_cubit.dart';
import 'package:gmedia_project/widget/custom_bottom_navigator.dart';
import 'package:gmedia_project/core/services/services_locator.dart';
import 'package:gmedia_project/features/category/presentation/cubit/category_cubit.dart';
import 'package:gmedia_project/features/category/domain/usecase/get_all_category_usecase.dart';

class GetAllProductsScreen extends StatelessWidget {
  const GetAllProductsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: BlocBuilder<NavigationCubit, int>(
        builder: (context, state) {
          return BlocProvider(
            create: (_) {
              final cubit = CategoryCubit(sl<GetAllCategoryUsecase>());
              cubit.fetchCategories();
              return cubit;
            },
            child: Scaffold(
              extendBody: true,

              bottomNavigationBar: CustomBottomNavigator(
                currentIndex: state,
                onTap: (index) {
                  // Update the selected tab in the global NavigationCubit
                  if (index != state) {
                    context.read<NavigationCubit>().updateIndex(index);
                  }
                  // Since this screen is pushed on top of MainScreen,
                  // pop back to the root so the MainScreen body updates.
                  Navigator.of(context).popUntil((route) => route.isFirst);
                },
              ),
              body: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const HomeAppBar(),
                  const SizedBox(height: 24),
                  // 1) SEARCH di paling atas
                  const SearchBarWidget(),
                  const SizedBox(height: 12),

                  // 2) NAV kategori (horizontal) tepat di bawah search
                  const ListCategoryWidget(),
                  const SizedBox(height: 12),

                  const Expanded(
                    child: ProductsPlaceholder(),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
    
  }
}

