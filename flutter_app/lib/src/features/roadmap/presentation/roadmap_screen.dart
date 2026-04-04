import 'package:flutter/material.dart';

import '../../../app/theme/app_colors.dart';
import '../../../shared/layout/app_scaffold_shell.dart';
import '../../../shared/widgets/primary_action_button.dart';
import '../../../shared/widgets/progress_badge.dart';
import '../../../shared/widgets/section_card.dart';

class RoadmapScreen extends StatelessWidget {
  const RoadmapScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;

    return AppScaffoldShell(
      title: 'Roadmap',
      children: [
        Text('Current Roadmap', style: textTheme.displayLarge),
        const SizedBox(height: 8),
        Text(
          'From search basics to algorithmic tradeoffs, with one active node at a time.',
          style: textTheme.bodyLarge,
        ),
        const SizedBox(height: 24),
        SectionCard(
          title: 'Current Node',
          subtitle: 'Binary search invariants',
          trailing: const ProgressBadge(label: 'Stage 1'),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Understand how interval boundaries move and how to explain the invariant clearly.',
                style: textTheme.bodyMedium,
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: PrimaryActionButton(
                      label: 'Start This Node',
                      onPressed: () {},
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        SectionCard(
          title: 'Stage Progress',
          subtitle: 'The current learning path broken into milestones.',
          trailing: const ProgressBadge(label: '3 stages'),
          child: Column(
            children: const [
              _StageTile(
                title: 'Stage 1 · Core reasoning',
                status: 'In progress',
                emphasis: true,
              ),
              SizedBox(height: 12),
              _StageTile(
                title: 'Stage 2 · Applied comparison',
                status: 'Locked next',
              ),
              SizedBox(height: 12),
              _StageTile(
                title: 'Stage 3 · Transfer to real problems',
                status: 'Upcoming',
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        SectionCard(
          title: 'Knowledge Graph',
          subtitle: 'A future visual layer for relationships across concepts.',
          trailing: const ProgressBadge(label: 'Coming soon'),
          child: Text(
            'This entry will open the graph view once we wire secondary routes.',
            style: textTheme.bodyMedium,
          ),
        ),
      ],
    );
  }
}

class _StageTile extends StatelessWidget {
  const _StageTile({
    required this.title,
    required this.status,
    this.emphasis = false,
  });

  final String title;
  final String status;
  final bool emphasis;

  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;

    return DecoratedBox(
      decoration: BoxDecoration(
        color: emphasis
            ? AppColors.surfaceContainerHighest
            : AppColors.surfaceContainerLow,
        borderRadius: BorderRadius.circular(22),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Expanded(
              child: Text(
                title,
                style: textTheme.titleMedium,
              ),
            ),
            Text(
              status,
              style: textTheme.labelMedium?.copyWith(
                color: emphasis ? AppColors.primary : AppColors.onSurfaceVariant,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
