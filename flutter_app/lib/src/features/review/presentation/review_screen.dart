import 'package:flutter/material.dart';

import '../../../shared/layout/app_scaffold_shell.dart';
import '../../../shared/widgets/primary_action_button.dart';
import '../../../shared/widgets/progress_badge.dart';
import '../../../shared/widgets/section_card.dart';

class ReviewScreen extends StatelessWidget {
  const ReviewScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;

    return AppScaffoldShell(
      title: 'Review',
      children: [
        Text('Review Queue', style: textTheme.displayLarge),
        const SizedBox(height: 8),
        Text(
          'Keep the learning loop warm with spaced review, weak-point recovery, and mastery checks.',
          style: textTheme.bodyLarge,
        ),
        const SizedBox(height: 24),
        SectionCard(
          title: 'Review Schedule',
          subtitle: 'Today’s review window and next checkpoints.',
          trailing: const ProgressBadge(label: '3 due'),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '1d recap, 3d compare, and 7d transfer prompts are waiting.',
                style: textTheme.bodyMedium,
              ),
              const SizedBox(height: 16),
              PrimaryActionButton(
                label: 'Open schedule',
                onPressed: () {},
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        SectionCard(
          title: 'Weak Points',
          subtitle: 'Concepts that still need reinforcement.',
          trailing: const ProgressBadge(label: '2 active'),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Boundary conditions in binary search and stable-sort reasoning are still below target.',
                style: textTheme.bodyMedium,
              ),
              const SizedBox(height: 16),
              PrimaryActionButton(
                label: 'See weak points',
                onPressed: () {},
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        SectionCard(
          title: 'Mastery Quiz',
          subtitle: 'Quick verification before moving deeper.',
          trailing: const ProgressBadge(label: 'Ready'),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Use a short quiz to confirm explanation, example, and transfer ability.',
                style: textTheme.bodyMedium,
              ),
              const SizedBox(height: 16),
              PrimaryActionButton(
                label: 'Start quiz',
                onPressed: () {},
              ),
            ],
          ),
        ),
      ],
    );
  }
}
