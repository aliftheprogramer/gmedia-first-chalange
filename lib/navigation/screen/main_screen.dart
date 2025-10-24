// lib/navigation/screen/main_screen.dart

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gmedia_project/features/home/presentation/pages/home_screen.dart';
import 'package:gmedia_project/features/product/presentation/page/product_screen.dart';
import 'package:gmedia_project/features/profile/presentation/page/profile_screen.dart';
import 'package:gmedia_project/navigation/cubit/navigation_cubit.dart';
import 'package:gmedia_project/widget/custom_navbar.dart';

class MainScreen extends StatelessWidget {
  const MainScreen({super.key});

  final List<Widget> _pages = const [
    HomeScreen(),
    ProductScreen(),
    ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<NavigationCubit, int>(
      builder: (context, state) {
        return Scaffold(
          extendBody: true, 
          body: _pages[state],
          
          bottomNavigationBar: Container(
            color: Colors.white, 
            child: CustomBottomNavBar(
              currentIndex: state,
              onTap: (index) => context.read<NavigationCubit>().updateIndex(index),
            ),
          ),
        );
      },
    );
  }
}