// lib/features/home/presentation/pages/get_all_products_screen.dart

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gmedia_project/features/category/presentation/widget/list_category_widget.dart';
import 'package:gmedia_project/features/home/presentation/widget/custom_search_bar.dart';
import 'package:gmedia_project/features/home/presentation/widget/get_all_products/get_category_product.dart';
import 'package:gmedia_project/features/home/presentation/widget/home/home_app_bar.dart';
import 'package:gmedia_project/navigation/cubit/navigation_cubit.dart';
import 'package:gmedia_project/widget/custom_bottom_navigator.dart';

class GetAllProductsScreen extends StatelessWidget {
  const GetAllProductsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      
      child: BlocBuilder<NavigationCubit, int>(
        builder: (context, state) {
          return Scaffold(

            bottomNavigationBar: CustomBottomNavigator(
                currentIndex: state,
                onTap: (index) => context.read<NavigationCubit>().updateIndex(index),
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
                  

              Expanded(
                child: ProductsPlaceholder(), // Ganti dengan grid/list produk kamu
              ),
            ],
          ),
        );
      },
      )
    );
    
  }
}

