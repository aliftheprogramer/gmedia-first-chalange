import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lucide_icons/lucide_icons.dart'; // import Lucide Icons
import 'package:gmedia_project/features/home/presentation/pages/home_screen.dart';
import 'package:gmedia_project/features/product/presentation/page/product_screen.dart';
import 'package:gmedia_project/features/profile/presentation/page/profile_screen.dart';
import 'package:gmedia_project/navigation/cubit/navigation_cubit.dart';

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
          bottomNavigationBar: Stack(
            clipBehavior: Clip.none,
            alignment: Alignment.bottomCenter,
            children: [
              BottomNavigationBar(
                currentIndex: state,
                onTap: (index) =>
                    context.read<NavigationCubit>().updateIndex(index),
                items: const [
                  BottomNavigationBarItem(
                    icon: Icon(LucideIcons.home, size: 26),
                    label: '',
                  ),
                  BottomNavigationBarItem(
                    icon: SizedBox.shrink(),
                    label: '',
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(LucideIcons.user, size: 26),
                    label: '',
                  ),
                ],
                selectedItemColor: Colors.blueAccent,
                unselectedItemColor: Colors.grey,
                showSelectedLabels: false,
                showUnselectedLabels: false,
                type: BottomNavigationBarType.fixed,
                backgroundColor: Colors.white,
                elevation: 0, // hapus shadow hitam dari navbar
              ),
              Positioned(
                top: -16,
                child: Container(
                  width: 154,
                  height: 80,
                  padding: const EdgeInsets.all(12), // border putih tebal
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(24),
                    boxShadow: const [],
                  ),
                  child: Container(
                    decoration: BoxDecoration(
                      color: const Color(0xFF2C59E5),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: IconButton(
                      icon: const Icon(LucideIcons.plus, color: Colors.white, size: 28),
                      onPressed: () =>
                          context.read<NavigationCubit>().updateIndex(1),
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
