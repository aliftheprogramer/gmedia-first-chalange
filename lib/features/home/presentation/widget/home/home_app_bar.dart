// lib/features/home/presentation/widgets/home_app_bar.dart

import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/services.dart';

class HomeAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String? profileImageUrl;
  final VoidCallback? onSearchTap;
  final VoidCallback? onCartTap;
  final VoidCallback? onProfileTap;

  const HomeAppBar({
    super.key,
    this.profileImageUrl,
    this.onSearchTap,
    this.onCartTap,
    this.onProfileTap,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      automaticallyImplyLeading: false,
      elevation: 0,
      backgroundColor: Colors.transparent,
      systemOverlayStyle: const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark,
        statusBarBrightness: Brightness.light,
      ),
      title: const Text(
        'MASPOS',
        style: TextStyle(
          color: Color(0xFF2C59E5),
          fontWeight: FontWeight.bold,
          fontSize: 24,
        ),
      ),
      actions: [
        IconButton(
          onPressed: onSearchTap,
          icon: const Icon(Icons.search, color: Colors.black54),
        ),
        IconButton(
          onPressed: onCartTap,
          icon: const Icon(Icons.shopping_cart_outlined, color: Colors.black54),
        ),
        Padding(
          padding: const EdgeInsets.only(right: 16.0, left: 8.0),
          child: InkWell(
            onTap: onProfileTap,
            customBorder: const CircleBorder(),
              child: CircleAvatar(
              radius: 18,
              backgroundColor: Color(0xFFEBF0FD),
              child: ClipOval(
                child: profileImageUrl != null
                    ? CachedNetworkImage(
                        imageUrl: profileImageUrl!,
                        width: 36,
                        height: 36,
                        fit: BoxFit.cover,
                        placeholder: (context, url) => const SizedBox(
                          width: 36,
                          height: 36,
                          child: Center(
                            child: SizedBox(
                              width: 16,
                              height: 16,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            ),
                          ),
                        ),
                        errorWidget: (context, url, error) => const Icon(
                          Icons.person,
                          size: 20,
                          color: Colors.grey,
                        ),
                      )
                    : const Icon(Icons.person, size: 20, color: Colors.grey),
              ),
            ),
          ),
        ),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}