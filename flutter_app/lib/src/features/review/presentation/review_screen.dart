import 'package:flutter/material.dart';

import '../../../app/theme/app_colors.dart';
import '../../../shared/layout/app_scaffold_shell.dart';
import '../../../shared/widgets/progress_badge.dart';
import '../../../shared/widgets/section_card.dart';

class ReviewScreen extends StatelessWidget {
  const ReviewScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;

    return AppScaffoldShell(
      children: [
        DecoratedBox(
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [
                AppColors.surfaceMint,
                AppColors.surfaceElevated,
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(34),
            border: Border.all(color: AppColors.outlineSoft),
          ),
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const ProgressBadge(label: 'Today\'s Focus'),
                const SizedBox(height: 16),
                Text(
                  'Ready to master',
                  style: textTheme.displayLarge?.copyWith(fontSize: 34),
                ),
                const SizedBox(height: 10),
                Text(
                  'Revisit what is fading, strengthen what is uncertain, and close the day with one retrieval that feels satisfyingly crisp.',
                  style: textTheme.bodyLarge?.copyWith(
                    color: AppColors.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 16),
        SectionCard(
          title: 'Review Roadmap',
          subtitle: 'A spaced rhythm tuned to today\'s cognitive load.',
          trailing: const ProgressBadge(label: '4 checkpoints'),
          child: Wrap(
            spacing: 10,
            runSpacing: 10,
            children: const [
              _ReviewDayChip(day: '1D', active: true),
              _ReviewDayChip(day: '3D'),
              _ReviewDayChip(day: '7D'),
              _ReviewDayChip(day: '14D'),
            ],
          ),
        ),
        const SizedBox(height: 16),
        SectionCard(
          title: 'Active Topics',
          subtitle: 'Short, concrete topics that benefit from one more pass.',
          trailing: const ProgressBadge(label: '2 priorities'),
          child: Column(
            children: const [
              _TopicTile(
                title: 'Wave-particle duality',
                detail: 'Needs one cleaner analogy.',
                tone: AppColors.surfaceBlue,
              ),
              SizedBox(height: 12),
              _TopicTile(
                title: 'Observer effect',
                detail: 'Needs stronger contrast with measurement itself.',
                tone: AppColors.surfaceRose,
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        SectionCard(
          title: 'Retention Pulse',
          subtitle: 'A quick read on how well the loop is holding.',
          trailing: const ProgressBadge(label: 'Stable'),
          child: Text(
            'Your recall quality rises when review happens within a gentle band of effort. Today is optimized for clarity, not volume.',
            style: textTheme.bodyMedium,
          ),
        ),
      ],
    );
  }
}

class _ReviewDayChip extends StatelessWidget {
  const _ReviewDayChip({
    required this.day,
    this.active = false,
  });

  final String day;
  final bool active;

  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;

    return DecoratedBox(
      decoration: BoxDecoration(
        color: active ? AppColors.primary : AppColors.surfaceElevated,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: active ? AppColors.primary : AppColors.outlineSoft,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Text(
          day,
          style: textTheme.labelLarge?.copyWith(
            color: active ? AppColors.onPrimary : AppColors.onSurface,
          ),
        ),
      ),
    );
  }
}

class _TopicTile extends StatelessWidget {
  const _TopicTile({
    required this.title,
    required this.detail,
    required this.tone,
  });

  final String title;
  final String detail;
  final Color tone;

  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;

    return DecoratedBox(
      decoration: BoxDecoration(
        color: tone,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: AppColors.outlineSoft),
      ),
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Row(
          children: [
            Container(
              width: 42,
              height: 42,
              decoration: const BoxDecoration(
                color: AppColors.surfaceElevated,
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.refresh_rounded,
                color: AppColors.primary,
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: textTheme.titleMedium),
                  const SizedBox(height: 4),
                  Text(detail, style: textTheme.bodySmall),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
