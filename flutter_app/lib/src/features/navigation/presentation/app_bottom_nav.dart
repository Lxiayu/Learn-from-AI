import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../app/locale/app_copy.dart';
import '../../../app/theme/app_colors.dart';

class AppBottomNav extends StatelessWidget {
  const AppBottomNav({
    super.key,
    required this.currentIndex,
  });

  final int currentIndex;

  @override
  Widget build(BuildContext context) {
    final AppCopy copy = context.copy;
    final List<_NavDestination> destinations = <_NavDestination>[
      _NavDestination(
        label: copy.t(en: 'Home', zh: '首页'),
        icon: Icons.home_outlined,
        path: '/home',
      ),
      _NavDestination(
        label: copy.t(en: 'Roadmap', zh: '路线'),
        icon: Icons.alt_route_outlined,
        path: '/roadmap',
      ),
      _NavDestination(
        label: copy.t(en: 'Review', zh: '复习'),
        icon: Icons.refresh_outlined,
        path: '/review',
      ),
      _NavDestination(
        label: copy.t(en: 'Chat', zh: '对话'),
        icon: Icons.chat_bubble_outline,
        path: '/chat',
      ),
      _NavDestination(
        label: copy.t(en: 'Profile', zh: '我的'),
        icon: Icons.person_outline,
        path: '/profile',
      ),
    ];

    return DecoratedBox(
      decoration: BoxDecoration(
        color: AppColors.surfaceElevated.withValues(alpha: 0.94),
        borderRadius: BorderRadius.circular(28),
        border: Border.all(color: AppColors.outlineSoft),
        boxShadow: const [
          BoxShadow(
            color: AppColors.shadow,
            blurRadius: 24,
            offset: Offset(0, 12),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
        child: Row(
          children: List<Widget>.generate(destinations.length, (int index) {
            final _NavDestination destination = destinations[index];
            final bool isSelected = index == currentIndex;

            return Expanded(
              child: InkWell(
                borderRadius: BorderRadius.circular(22),
                onTap: () => context.go(destination.path),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 180),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 10,
                  ),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? AppColors.surfaceBlue
                        : Colors.transparent,
                    borderRadius: BorderRadius.circular(22),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        destination.icon,
                        size: 20,
                        color: isSelected
                            ? AppColors.primary
                            : AppColors.onSurfaceVariant,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        destination.label,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: Theme.of(context).textTheme.labelMedium?.copyWith(
                              color: isSelected
                                  ? AppColors.primary
                                  : AppColors.onSurfaceVariant,
                            ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          }),
        ),
      ),
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
