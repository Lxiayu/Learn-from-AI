import 'package:flutter/material.dart';

import '../../../app/theme/app_colors.dart';
import '../../../shared/layout/app_scaffold_shell.dart';
import '../../../shared/widgets/progress_badge.dart';
import '../../../shared/widgets/section_card.dart';

class ProfileAnalyticsScreen extends StatelessWidget {
  const ProfileAnalyticsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;

    return AppScaffoldShell(
      children: [
        DecoratedBox(
          decoration: BoxDecoration(
            color: AppColors.surfaceElevated,
            borderRadius: BorderRadius.circular(34),
            border: Border.all(color: AppColors.outlineSoft),
            boxShadow: const [
              BoxShadow(
                color: AppColors.shadow,
                blurRadius: 22,
                offset: Offset(0, 12),
              ),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const ProgressBadge(label: 'Personal Dashboard'),
                const SizedBox(height: 18),
                Row(
                  children: [
                    Container(
                      width: 64,
                      height: 64,
                      decoration: const BoxDecoration(
                        color: AppColors.surfaceBlue,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.person_outline_rounded,
                        size: 30,
                        color: AppColors.primary,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Alex Harrison', style: textTheme.headlineSmall),
                          const SizedBox(height: 4),
                          Text(
                            'Architectural reasoning track · Cohort spring',
                            style: textTheme.bodyMedium,
                          ),
                        ],
                      ),
                    ),
                    const _MiniMetric(value: '24 Days', label: 'streak'),
                  ],
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 16),
        LayoutBuilder(
          builder: (BuildContext context, BoxConstraints constraints) {
            final bool useColumns = constraints.maxWidth >= 720;
            final Widget insightCard = SectionCard(
              title: 'Learning Signals',
              subtitle: 'Momentum, focus, and consistency across the last week.',
              trailing: const ProgressBadge(label: 'On track'),
              child: Wrap(
                spacing: 12,
                runSpacing: 12,
                children: const [
                  _MetricCard(label: 'Deep sessions', value: '12'),
                  _MetricCard(label: 'Recall accuracy', value: '84%'),
                  _MetricCard(label: 'Reflection quality', value: 'A-'),
                ],
              ),
            );

            final Widget achievementsCard = SectionCard(
              title: 'Achievements',
              subtitle: 'Visible proof that the learning loop is compounding.',
              trailing: const ProgressBadge(label: '3 new'),
              child: Wrap(
                spacing: 12,
                runSpacing: 12,
                children: const [
                  _BadgeTile(label: 'Clear Explainer'),
                  _BadgeTile(label: 'Recall Keeper'),
                  _BadgeTile(label: 'Steady Rhythm'),
                ],
              ),
            );

            if (!useColumns) {
              return Column(
                children: [
                  insightCard,
                  const SizedBox(height: 16),
                  achievementsCard,
                ],
              );
            }

            return Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(child: insightCard),
                const SizedBox(width: 16),
                Expanded(child: achievementsCard),
              ],
            );
          },
        ),
        const SizedBox(height: 16),
        SectionCard(
          title: 'Account Settings',
          subtitle: 'Study cadence, reminders, sync, and profile preferences.',
          trailing: const ProgressBadge(label: 'Synced'),
          child: Column(
            children: const [
              _SettingRow(
                label: 'Evening reflection reminder',
                value: 'Enabled',
              ),
              Divider(height: 24),
              _SettingRow(
                label: 'Offline lesson cache',
                value: 'Available',
              ),
              Divider(height: 24),
              _SettingRow(
                label: 'Weekly insight digest',
                value: 'Friday',
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _MiniMetric extends StatelessWidget {
  const _MiniMetric({
    required this.value,
    required this.label,
  });

  final String value;
  final String label;

  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;

    return DecoratedBox(
      decoration: BoxDecoration(
        color: AppColors.surfaceWarm,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: AppColors.outlineSoft),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Column(
          children: [
            Text(value, style: textTheme.titleLarge),
            Text(label, style: textTheme.bodySmall),
          ],
        ),
      ),
    );
  }
}

class _MetricCard extends StatelessWidget {
  const _MetricCard({
    required this.label,
    required this.value,
  });

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;

    return DecoratedBox(
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerLow,
        borderRadius: BorderRadius.circular(22),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: SizedBox(
          width: 120,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(value, style: textTheme.headlineSmall),
              const SizedBox(height: 6),
              Text(label, style: textTheme.bodySmall),
            ],
          ),
        ),
      ),
    );
  }
}

class _BadgeTile extends StatelessWidget {
  const _BadgeTile({
    required this.label,
  });

  final String label;

  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;

    return DecoratedBox(
      decoration: BoxDecoration(
        color: AppColors.surfaceBlue,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.outlineSoft),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.workspace_premium_outlined,
              color: AppColors.primary,
            ),
            const SizedBox(width: 10),
            Text(label, style: textTheme.labelLarge),
          ],
        ),
      ),
    );
  }
}

class _SettingRow extends StatelessWidget {
  const _SettingRow({
    required this.label,
    required this.value,
  });

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;

    return Row(
      children: [
        Expanded(
          child: Text(label, style: textTheme.bodyMedium),
        ),
        Text(
          value,
          style: textTheme.labelLarge?.copyWith(color: AppColors.primary),
        ),
      ],
    );
  }
}
