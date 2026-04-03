import 'package:flutter/material.dart';

import '../../../shared/layout/app_scaffold_shell.dart';
import '../../../shared/mock/mock_learning_data.dart';
import '../../../shared/widgets/primary_action_button.dart';
import '../../../shared/widgets/progress_badge.dart';
import '../../../shared/widgets/section_card.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;

    return AppScaffoldShell(
      title: 'Home',
      children: [
        Text(
          mockHomeDashboardData.greeting,
          style: textTheme.displayLarge,
        ),
        const SizedBox(height: 8),
        Text(
          mockHomeDashboardData.goalSummary,
          style: textTheme.bodyLarge,
        ),
        const SizedBox(height: 24),
        SectionCard(
          title: 'Continue Learning',
          subtitle: mockHomeDashboardData.learningTask.title,
          trailing: ProgressBadge(
            label: mockHomeDashboardData.learningTask.progressLabel,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                mockHomeDashboardData.learningTask.description,
                style: textTheme.bodyMedium,
              ),
              const SizedBox(height: 16),
              PrimaryActionButton(
                label: mockHomeDashboardData.learningTask.ctaLabel,
                onPressed: () {},
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        SectionCard(
          title: 'Today Review',
          subtitle: mockHomeDashboardData.reviewTask.title,
          trailing: ProgressBadge(
            label: mockHomeDashboardData.reviewTask.dueLabel,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                mockHomeDashboardData.reviewTask.description,
                style: textTheme.bodyMedium,
              ),
              const SizedBox(height: 16),
              PrimaryActionButton(
                label: mockHomeDashboardData.reviewTask.ctaLabel,
                onPressed: () {},
              ),
            ],
          ),
        ),
      ],
    );
  }
}
