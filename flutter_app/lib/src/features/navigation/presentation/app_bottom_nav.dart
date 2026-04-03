import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class AppBottomNav extends StatelessWidget {
  const AppBottomNav({
    super.key,
    required this.currentIndex,
  });

  final int currentIndex;

  static const List<_NavDestination> _destinations = <_NavDestination>[
    _NavDestination(label: 'Home', icon: Icons.home_outlined, path: '/home'),
    _NavDestination(
      label: 'Roadmap',
      icon: Icons.alt_route_outlined,
      path: '/roadmap',
    ),
    _NavDestination(
      label: 'Review',
      icon: Icons.refresh_outlined,
      path: '/review',
    ),
    _NavDestination(
      label: 'Socratic Chat',
      icon: Icons.chat_bubble_outline,
      path: '/chat',
    ),
    _NavDestination(
      label: 'Profile & Analytics',
      icon: Icons.person_outline,
      path: '/profile',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: currentIndex,
      type: BottomNavigationBarType.fixed,
      onTap: (int index) => context.go(_destinations[index].path),
      items: _destinations
          .map(
            (_NavDestination destination) => BottomNavigationBarItem(
              icon: Icon(destination.icon),
              label: destination.label,
            ),
          )
          .toList(),
    );
  }
}

class _NavDestination {
  const _NavDestination({
    required this.label,
    required this.icon,
    required this.path,
  });

  final String label;
  final IconData icon;
  final String path;
}
