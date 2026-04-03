import 'package:flutter/material.dart';

import 'app_bottom_nav.dart';

class AppShell extends StatelessWidget {
  const AppShell({
    super.key,
    required this.location,
    required this.child,
  });

  final String location;
  final Widget child;

  static const List<String> _paths = <String>[
    '/home',
    '/roadmap',
    '/review',
    '/chat',
    '/profile',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: child,
      bottomNavigationBar: AppBottomNav(
        currentIndex: _currentIndex(location),
      ),
    );
  }

  int _currentIndex(String currentLocation) {
    for (int index = 0; index < _paths.length; index++) {
      if (currentLocation.startsWith(_paths[index])) {
        return index;
      }
    }
    return 0;
  }
}
