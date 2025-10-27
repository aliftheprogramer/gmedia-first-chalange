import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';

class CustomBottomNavigator extends StatelessWidget {
	const CustomBottomNavigator({
		super.key,
		required this.currentIndex,
		required this.onTap,
	});

	final int currentIndex;
	final ValueChanged<int> onTap;

	@override
	Widget build(BuildContext context) {
		return Stack(
			clipBehavior: Clip.none,
			alignment: Alignment.bottomCenter,
			children: [
				BottomNavigationBar(
					currentIndex: currentIndex,
					onTap: onTap,
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
					elevation: 0,
				),
				Positioned(
					top: -16,
					child: Container(
						width: 154,
						height: 80,
						padding: const EdgeInsets.all(12),
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
								icon: const Icon(
									LucideIcons.plus,
									color: Colors.white,
									size: 28,
								),
								onPressed: () => onTap(1),
							),
						),
					),
				),
			],
		);
	}
}

