import 'package:flutter/material.dart';

import '../../../app/theme/app_colors.dart';
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
      backgroundColor: AppColors.surface,
      extendBody: true,
      body: DecoratedBox(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              AppColors.shellGradientTop,
              AppColors.shellGradientBottom,
            ],
          ),
        ),
        child: SafeArea(
          bottom: false,
          child: Column(
            children: [
              const _ShellHeader(),
              Expanded(child: child),
            ],
          ),
        ),
      ),
      bottomNavigationBar: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
          child: AppBottomNav(
            currentIndex: _currentIndex(location),
          ),
        ),
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

class _ShellHeader extends StatelessWidget {
  const _ShellHeader();

  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;

    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 12),
      child: Row(
        children: [
          DecoratedBox(
            decoration: BoxDecoration(
              color: AppColors.surfaceElevated,
              borderRadius: BorderRadius.circular(22),
              boxShadow: const [
                BoxShadow(
                  color: AppColors.shadow,
                  blurRadius: 18,
                  offset: Offset(0, 10),
                ),
              ],
            ),
            child: const Padding(
              padding: EdgeInsets.all(4),
              child: CircleAvatar(
                radius: 22,
                backgroundColor: AppColors.surfaceBlue,
                child: Icon(
                  Icons.psychology_alt_outlined,
                  color: AppColors.primary,
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('The Curator', style: textTheme.titleLarge),
                Text(
                  'A guided studio for thoughtful learning',
                  style: textTheme.bodySmall,
                ),
              ],
            ),
          ),
          _HeaderIconButton(
            icon: Icons.notifications_none_rounded,
            onPressed: () {},
          ),
          const SizedBox(width: 8),
          _HeaderIconButton(
            icon: Icons.tune_rounded,
            onPressed: () {},
          ),
        ],
      ),
    );
  }
}

class _HeaderIconButton extends StatelessWidget {
  const _HeaderIconButton({
    required this.icon,
    required this.onPressed,
  });

  final IconData icon;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: AppColors.surfaceElevated.withValues(alpha: 0.9),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppColors.outlineSoft),
      ),
      child: IconButton(
        onPressed: onPressed,
        icon: Icon(icon, color: AppColors.onSurface),
      ),
    );
  }
}
