import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../app/theme/app_colors.dart';
import '../../../shared/layout/app_scaffold_shell.dart';
import '../../../shared/widgets/primary_action_button.dart';
import '../../../shared/widgets/progress_badge.dart';
import '../../../shared/widgets/section_card.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;

    return AppScaffoldShell(
      children: [
        DecoratedBox(
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [
                AppColors.surfaceElevated,
                AppColors.surfaceWarm,
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(34),
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
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const ProgressBadge(label: 'Today · Thoughtful Momentum'),
                const SizedBox(height: 18),
                Text(
                  'Good Morning, Alex!',
                  style: textTheme.displayLarge?.copyWith(fontSize: 40),
                ),
                const SizedBox(height: 12),
                Text(
                  'The Curator arranged one deep concept, two spaced recalls, and a reflective finish so the day feels intentional instead of crowded.',
                  style: textTheme.bodyLarge?.copyWith(
                    color: AppColors.onSurfaceVariant,
                  ),
                ),
                const SizedBox(height: 22),
                Wrap(
                  spacing: 12,
                  runSpacing: 12,
                  children: [
                    _FactChip(
                      icon: Icons.auto_awesome_outlined,
                      label: '1 inquiry session',
                    ),
                    _FactChip(
                      icon: Icons.history_toggle_off_rounded,
                      label: '2 spaced recalls',
                    ),
                    _FactChip(
                      icon: Icons.insights_outlined,
                      label: '1 reflection prompt',
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 24),
        Text('Current Focus', style: textTheme.headlineSmall),
        const SizedBox(height: 12),
        SectionCard(
          title: 'Quantum Physics Fundamentals',
          subtitle: 'Wave-particle duality · Session 04',
          trailing: const ProgressBadge(label: '68% aligned'),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Continue with a guided dialogue on uncertainty, then anchor the idea with a real-world analogy before today\'s spaced recall begins.',
                style: textTheme.bodyMedium,
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: PrimaryActionButton(
                      label: 'Enter Inquiry',
                      onPressed: () => context.go('/chat'),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        LayoutBuilder(
          builder: (BuildContext context, BoxConstraints constraints) {
            final bool useColumns = constraints.maxWidth >= 700;

            final Widget upcomingReviews = _MiniPanel(
              title: 'Upcoming Reviews',
              tone: AppColors.surfaceBlue,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _ReviewItem(
                    title: 'Duality recall',
                    subtitle: 'In 35 minutes',
                  ),
                  const SizedBox(height: 10),
                  _ReviewItem(
                    title: 'Observer effect',
                    subtitle: 'Tonight · 20:30',
                  ),
                ],
              ),
            );

            final Widget learningGoal = _MiniPanel(
              title: 'Daily Learning Goal',
              tone: AppColors.surfaceMint,
              child: Row(
                children: [
                  const _GoalRing(progress: 0.72),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Text(
                      '72% of today\'s intention is already in motion. Finish the main inquiry and one recall to close the loop.',
                      style: textTheme.bodyMedium,
                    ),
                  ),
                ],
              ),
            );

            if (!useColumns) {
              return Column(
                children: [
                  upcomingReviews,
                  const SizedBox(height: 16),
                  learningGoal,
                ],
              );
            }

            return Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(child: upcomingReviews),
                const SizedBox(width: 16),
                Expanded(child: learningGoal),
              ],
            );
          },
        ),
        const SizedBox(height: 16),
        SectionCard(
          title: 'Curator\'s Note',
          subtitle: 'Why today is sequenced this way',
          trailing: const ProgressBadge(label: 'Gentle challenge'),
          child: Text(
            'Curator guidance: start with one elegant question while your attention is fresh, then switch to lighter retrieval so confidence compounds instead of dropping.',
            style: textTheme.bodyMedium,
          ),
        ),
      ],
    );
  }
}

class _FactChip extends StatelessWidget {
  const _FactChip({
    required this.icon,
    required this.label,
  });

  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;

    return DecoratedBox(
      decoration: BoxDecoration(
        color: AppColors.surfaceElevated.withValues(alpha: 0.8),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: AppColors.outlineSoft),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 16, color: AppColors.primary),
            const SizedBox(width: 8),
            Text(label, style: textTheme.labelMedium),
          ],
        ),
      ),
    );
  }
}

class _MiniPanel extends StatelessWidget {
  const _MiniPanel({
    required this.title,
    required this.tone,
    required this.child,
  });

  final String title;
  final Color tone;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;

    return DecoratedBox(
      decoration: BoxDecoration(
        color: tone,
        borderRadius: BorderRadius.circular(28),
        border: Border.all(color: AppColors.outlineSoft),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: textTheme.titleLarge),
            const SizedBox(height: 14),
            child,
          ],
        ),
      ),
    );
  }
}

class _ReviewItem extends StatelessWidget {
  const _ReviewItem({
    required this.title,
    required this.subtitle,
  });

  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;

    return Row(
      children: [
        Container(
          width: 12,
          height: 12,
          decoration: const BoxDecoration(
            color: AppColors.primary,
            shape: BoxShape.circle,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: textTheme.titleMedium),
              const SizedBox(height: 4),
              Text(subtitle, style: textTheme.bodySmall),
            ],
          ),
        ),
      ],
    );
  }
}

class _GoalRing extends StatelessWidget {
  const _GoalRing({
    required this.progress,
  });

  final double progress;

  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;

    return SizedBox(
      width: 84,
      height: 84,
      child: Stack(
        fit: StackFit.expand,
        alignment: Alignment.center,
        children: [
          CircularProgressIndicator(
            value: progress,
            strokeWidth: 10,
            backgroundColor: AppColors.surfaceElevated,
            color: AppColors.primary,
          ),
          Center(
            child: Text(
              '${(progress * 100).round()}%',
              style: textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
