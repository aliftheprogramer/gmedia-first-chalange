// lib/features/home/presentation/pages/home_screen.dart

import 'package:flutter/material.dart';
import 'package:gmedia_project/core/services/services_locator.dart';
import 'package:gmedia_project/features/home/presentation/provider/home_provider.dart';
import 'package:gmedia_project/features/home/presentation/widget/custom_search_bar.dart';
import 'package:gmedia_project/features/home/presentation/widget/hero_section_widget.dart';
import 'package:gmedia_project/features/home/presentation/widget/home_app_bar.dart';
import 'package:gmedia_project/navigation/cubit/navigation_cubit.dart';
import 'package:logger/logger.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final logger = sl<Logger>();

    return ChangeNotifierProvider(
      create: (_) => sl<HomeProvider>(),
      child: SafeArea(
        child: Scaffold(
          
          appBar: HomeAppBar(
            profileImageUrl: 'https://i.pravatar.cc/150?u=a042581f4e29026704d',
            onProfileTap: () {
              context.read<NavigationCubit>().updateIndex(2);
            },
          ),
            backgroundColor: const Color(0xFFD6DFFA),
          body: ListView(
            padding: EdgeInsets.zero,
            children: [
              const SizedBox(height: 24),
              SearchBarWidget(
                hintText: 'Cari nama produk...',
                onChanged: (query) {
                  // Logika untuk live search bisa ditambahkan di sini
                  logger.d('Search query: $query');
                },
              ),
        
              const SizedBox(height: 24),
        
              const HeroSectionWidget(),
        
              const SizedBox(height: 24),
        
              // Di sini nanti kita akan menambahkan bagian "Diminati pembeli"
              // dan "Produk yang dijual"
            ],
          ),
        ),
      ),
    );
  }
}
