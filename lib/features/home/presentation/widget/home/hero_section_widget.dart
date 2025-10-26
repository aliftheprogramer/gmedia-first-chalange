// lib/features/home/presentation/widgets/hero_section_widget.dart
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:gmedia_project/features/home/presentation/provider/home_provider.dart';
import 'package:provider/provider.dart';

class HeroSectionWidget extends StatefulWidget {
  const HeroSectionWidget({super.key});

  @override
  State<HeroSectionWidget> createState() => _HeroSectionWidgetState();
}

class _HeroSectionWidgetState extends State<HeroSectionWidget> {
  late final PageController _pageController;
  late final Timer _timer;
  int _currentPage = 0;

  final Map<String, double> _assetAspectRatios = {};
  final Set<String> _listeningAssets = {};

  void _ensureAspectRatio(String assetPath) {
    if (_assetAspectRatios.containsKey(assetPath) || _listeningAssets.contains(assetPath)) return;
    _listeningAssets.add(assetPath);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      final provider = AssetImage(assetPath);
      final stream = provider.resolve(const ImageConfiguration());
      stream.addListener(
        ImageStreamListener((info, _) {
          final ratio = info.image.width / info.image.height;
          if (!mounted) return;
          // Update state dengan aman setelah frame
          WidgetsBinding.instance.addPostFrameCallback((__) {
            if (!mounted) return;
            setState(() {
              _assetAspectRatios[assetPath] = ratio.toDouble();
            });
          });
        }, onError: (_, __) {
          if (!mounted) return;
          WidgetsBinding.instance.addPostFrameCallback((__) {
            if (!mounted) return;
            setState(() {
              _assetAspectRatios[assetPath] = 2.0;
            });
          });
        }),
      );
    });
  }

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: _currentPage, viewportFraction: 0.9);
    
    _timer = Timer.periodic(const Duration(seconds: 5), (timer) {
      final provider = context.read<HomeProvider>();
      if (provider.banners.isNotEmpty) {
        int nextPage = (_pageController.page?.round() ?? 0) + 1;
        if (nextPage >= provider.banners.length) {
          nextPage = 0;
        }
        if (mounted && _pageController.hasClients) {
          _pageController.animateToPage(
            nextPage,
            duration: const Duration(milliseconds: 400),
            curve: Curves.easeInOut,
          );
        }
      }
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    final provider = context.read<HomeProvider>();
    for (final b in provider.banners) {
      precacheImage(AssetImage(b.imagePath), context);
    }
  }

  @override
  void dispose() {
    _pageController.dispose();
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<HomeProvider>(
      builder: (context, provider, child) {
        if (provider.isLoading && provider.banners.isEmpty) {
          return AspectRatio(
            aspectRatio: 2 / 1,
            child: const Center(child: CircularProgressIndicator()),
          );
        }

        if (provider.banners.isEmpty) {
          return AspectRatio(
            aspectRatio: 2 / 1,
            child: const Center(child: Text('No banners available.'))
          );
        }

        // Begin resolving aspect ratios for known banners
        for (final b in provider.banners) {
          _ensureAspectRatio(b.imagePath);
        }

        // Determine dynamic height based on current banner aspect ratio
  final screenWidth = MediaQuery.of(context).size.width;
  final pageWidth = screenWidth * 0.9; // matches viewportFraction
  final safeIndex = _currentPage.clamp(0, provider.banners.length - 1);
  final currentPath = provider.banners[safeIndex].imagePath;
  final currentRatio = _assetAspectRatios[currentPath] ?? 2.0; // default 2:1
  final bannerHeight = (currentRatio > 0) ? pageWidth / currentRatio : pageWidth / 2.0;

        return AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeInOut,
          height: bannerHeight,
          child: PageView.builder(
            controller: _pageController,
            itemCount: provider.banners.length,
            onPageChanged: (index) {
              setState(() {
                _currentPage = index;
              });
            },
            itemBuilder: (context, index) {
              final banner = provider.banners[index];
              final ratio = _assetAspectRatios[banner.imagePath] ?? currentRatio;
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8), // sudut 8
                  child: AspectRatio(
                    aspectRatio: ratio,
                    child: Image.asset(
                      banner.imagePath,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          color: Colors.grey[300],
                          child: const Center(child: Icon(Icons.broken_image, size: 40, color: Colors.grey)),
                        );
                      },
                    ),
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }
}