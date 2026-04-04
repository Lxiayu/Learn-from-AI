import 'package:flutter/material.dart';

import '../../../app/locale/app_copy.dart';
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
    final AppCopy copy = context.copy;

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
              _ShellHeader(
                title: copy.t(en: 'The Curator', zh: '学习策展人'),
                subtitle: copy.t(
                  en: 'A guided studio for thoughtful learning',
                  zh: '一个以提问驱动思考的学习工作台',
                ),
              ),
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
  const _ShellHeader({
    required this.title,
    required this.subtitle,
  });

  final String title;
  final String subtitle;

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
                Text(title, style: textTheme.titleLarge),
                Text(
                  subtitle,
                  style: textTheme.bodySmall,
                ),
              ],
            ),
          ),
          _HeaderIconButton(
            icon: Icons.notifications_none_rounded,
            onPressed: () {
              final ScaffoldMessengerState messenger =
                  ScaffoldMessenger.of(context);
              messenger
                ..hideCurrentSnackBar()
                ..showSnackBar(
                SnackBar(
                  content: Text(
                    AppCopy.of(context).t(
                      en: 'Notifications will appear here soon.',
                      zh: '通知中心很快会出现在这里。',
                    ),
                  ),
                ),
              );
            },
          ),
          const SizedBox(width: 8),
          _HeaderIconButton(
            icon: Icons.tune_rounded,
            onPressed: () {
              final ScaffoldMessengerState messenger =
                  ScaffoldMessenger.of(context);
              messenger
                ..hideCurrentSnackBar()
                ..showSnackBar(
                SnackBar(
                  content: Text(
                    AppCopy.of(context).t(
                      en: 'Quick filters will live here soon.',
                      zh: '快捷筛选很快会补到这里。',
                    ),
                  ),
                ),
              );
            },
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
