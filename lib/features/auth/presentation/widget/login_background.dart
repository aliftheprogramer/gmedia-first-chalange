// lib/features/auth/presentation/widgets/login_background.dart
import 'package:flutter/material.dart';

class LoginBackground extends StatelessWidget {
  const LoginBackground({super.key});

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height * 0.4;

    return SizedBox(
      height: height,
      child: Stack(
        fit: StackFit.expand,
        children: [
          // Wallpaper split into three images (same assets as welcome page)
          Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(right: 5.0),
                  child: Image.asset(
                    'assets/variant1.png',
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 5.0),
                  child: Image.asset(
                    'assets/variant2.png',
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(left: 5.0),
                  child: Image.asset(
                    'assets/variant3.png',
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ],
          ),

          // Semi-transparent blue gradient overlay to match welcome page
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.white.withOpacity(0.8),
                  const Color(0xFFAABCF4).withOpacity(0.6),
                ],
                stops: const [0.0, 1.0],
              ),
            ),
          ),

        ]
      )

    );
  }
}