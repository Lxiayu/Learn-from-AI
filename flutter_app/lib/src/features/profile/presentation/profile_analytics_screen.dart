import 'package:flutter/material.dart';

import '../../../app/theme/app_colors.dart';
import '../../../shared/layout/app_scaffold_shell.dart';
import '../../../shared/widgets/primary_action_button.dart';
import '../../../shared/widgets/progress_badge.dart';
import '../../../shared/widgets/section_card.dart';

class ProfileAnalyticsScreen extends StatelessWidget {
  const ProfileAnalyticsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;

    return AppScaffoldShell(
      title: 'Profile & Analytics',
      children: [
        Text('Learning Insights', style: textTheme.displayLarge),
        const SizedBox(height: 8),
        Text(
          'Track consistency, progress, and the signals that show how well the learning loop is working.',
          style: textTheme.bodyLarge,
        ),
        const SizedBox(height: 24),
        SectionCard(
          title: 'Profile Snapshot',
          subtitle: 'Advanced Algorithms · 12 week sprint',
          trailing: const ProgressBadge(label: 'Cloud sync on'),
          child: Wrap(
            spacing: 12,
            runSpacing: 12,
            children: const [
              _MetricTile(
                label: 'Current Streak',
                value: '7 days',
              ),
              _MetricTile(
                label: 'Weekly Time',
                value: '4.5 h',
              ),
              _MetricTile(
                label: 'Completion',
                value: '42%',
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        SectionCard(
          title: 'Achievements',
          subtitle: 'Recent momentum and milestone signals.',
          trailing: const ProgressBadge(label: '2 new'),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Consistency Builder, Review Finisher, and Clear Explainer are already unlocked.',
                style: textTheme.bodyMedium,
              ),
              const SizedBox(height: 16),
              PrimaryActionButton(
                label: 'View achievements',
                onPressed: () {},
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        SectionCard(
          title: 'Preferences',
          subtitle: 'Sync, notifications, and study rhythm.',
          trailing: const ProgressBadge(label: 'Stable'),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Evening review reminders are enabled. Local-first storage is active.',
                style: textTheme.bodyMedium,
              ),
              const SizedBox(height: 16),
              PrimaryActionButton(
                label: 'Open settings',
                onPressed: () {},
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _MetricTile extends StatelessWidget {
  const _MetricTile({
    required this.label,
    required this.value,
  });

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;

    return ConstrainedBox(
      constraints: const BoxConstraints(minWidth: 120),
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: AppColors.surfaceContainerLow,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(value, style: textTheme.titleMedium),
              const SizedBox(height: 6),
              Text(label, style: textTheme.labelMedium),
            ],
          ),
        ),
      ),
    );
  }
}
