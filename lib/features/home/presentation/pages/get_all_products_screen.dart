// lib/features/home/presentation/pages/get_all_products_screen.dart

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gmedia_project/features/category/presentation/widget/list_category_widget.dart';
import 'package:gmedia_project/features/home/presentation/widget/custom_search_bar.dart';
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
        
          body: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // 1) SEARCH di paling atas
                const SearchBarWidget(),
                const SizedBox(height: 12),
        
                // 2) NAV kategori (horizontal) tepat di bawah search
                const ListCategoryWidget(),
                const SizedBox(height: 12),
        
                // 3) Area konten produk (scroll vertikal)
                Expanded(
                  child: _ProductsPlaceholder(), // Ganti dengan grid/list produk kamu
                ),
              ],
            ),
          ),
        );
      },
      )
    );
    
  }
}

// Placeholder konten biar compile; ganti dengan widget produk kamu.
class _ProductsPlaceholder extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      itemCount: 12,
      separatorBuilder: (_, __) => const SizedBox(height: 8),
      itemBuilder: (_, i) => Container(
        height: 80,
        alignment: Alignment.centerLeft,
        padding: const EdgeInsets.symmetric(horizontal: 12),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          color: Colors.grey.shade200,
        ),
        child: Text('Produk #$i'),
      ),
    );
  }
}
