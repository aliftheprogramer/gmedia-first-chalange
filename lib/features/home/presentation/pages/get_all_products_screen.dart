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

class GetAllProductsScreen extends StatelessWidget {
  const GetAllProductsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<NavigationCubit, int>(
      builder: (context, navIndex) {
        return BlocProvider(
          create: (_) {
            final cubit = CategoryCubit(sl<GetAllCategoryUsecase>());
            cubit.fetchCategories();
            return cubit;
          },
          child: Scaffold(
            extendBody: true,
            backgroundColor: Colors.white,
            appBar: const HomeAppBar(),
            bottomNavigationBar: CustomBottomNavigator(
              currentIndex: navIndex,
              onTap: (index) {
                if (index != navIndex) {
                  context.read<NavigationCubit>().updateIndex(index);
                }
                Navigator.of(context).popUntil((route) => route.isFirst);
              },
            ),
            body: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: const [
                SizedBox(height: 24),
                SearchBarWidget(),
                SizedBox(height: 12),
                ListCategoryWidget(),
                SizedBox(height: 12),
                Expanded(child: ProductsPlaceholder()),
              ],
            ),
          ),
        );
      },
    );
  }
}
