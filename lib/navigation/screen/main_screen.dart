import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gmedia_project/features/home/presentation/pages/home_screen.dart';
// Removed full-page AddProductScreen usage; using bottom sheet variant instead.
import 'package:gmedia_project/features/product/presentation/widget/add_product_sheet.dart';
import 'package:gmedia_project/features/category/presentation/page/add_category_screen.dart';

import 'package:gmedia_project/features/profile/presentation/page/profile_screen.dart';
import 'package:gmedia_project/navigation/cubit/navigation_cubit.dart';
import 'package:gmedia_project/widget/chosee_add_widget.dart';
import 'package:gmedia_project/widget/custom_bottom_navigator.dart';

class MainScreen extends StatelessWidget {
  const MainScreen({super.key});

  final List<Widget> _pages = const [
    HomeScreen(),
    HomeScreen(), // index 1 tidak digunakan (tombol tengah menampilkan overlay)
    ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<NavigationCubit, int>(
      builder: (context, state) {
        return Scaffold(
          extendBody: true,
          body: _pages[state],
          bottomNavigationBar: CustomBottomNavigator(
            currentIndex: state,
            onTap: (index) {
              if (index == 1) return; // abaikan, center handled by onCenterTap
              context.read<NavigationCubit>().updateIndex(index);
            },
            onCenterTap: () {
              showModalBottomSheet(
                context: context,
                isScrollControlled: false,
                backgroundColor: Colors.white,
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
                ),
                builder: (ctx) {
                  return ChoseeAddWidget(
                    onProdukTap: () {
                      Navigator.of(ctx).pop();
                      // Show product form as another bottom sheet overlay (not a full page)
                      showModalBottomSheet(
                        context: context,
                        isScrollControlled: true,
                        backgroundColor: Colors.white,
                        shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
                        ),
                        builder: (_) => const AddProductSheet(),
                      );
                    },
                    onKategoriTap: () {
                      Navigator.of(ctx).pop();
                      Navigator.of(context).push(
                        MaterialPageRoute(builder: (_) => const AddCategoryScreen()),
                      );
                    },
                  );
                },
              );
            },
          ),
        );
      },
    );
  }
}
