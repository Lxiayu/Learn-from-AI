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
      children: [
        DecoratedBox(
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [
                AppColors.surfaceBlue,
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
                const ProgressBadge(label: 'Your Journey'),
                const SizedBox(height: 16),
                Text(
                  'Mastering Digital Architecture',
                  style: textTheme.displayLarge?.copyWith(fontSize: 36),
                ),
                const SizedBox(height: 10),
                Text(
                  'Advance from first principles to design judgment through a paced sequence of foundations, critique, and synthesis.',
                  style: textTheme.bodyLarge?.copyWith(
                    color: AppColors.onSurfaceVariant,
                  ),
                ),
                const SizedBox(height: 18),
                SizedBox(
                  width: double.infinity,
                  child: PrimaryActionButton(
                    label: 'CONTINUE LEARNING',
                    onPressed: () {},
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 16),
        SectionCard(
          title: 'Journey Milestones',
          subtitle: 'One active stage, one stretching stage, one horizon stage.',
          trailing: const ProgressBadge(label: '3 stages'),
          child: Column(
            children: const [
              _JourneyNode(
                title: 'Foundation Systems',
                detail: 'Clarify structure, intent, and constraints.',
                state: 'In progress',
                accent: AppColors.surfaceWarm,
                isFirst: true,
              ),
              _JourneyNode(
                title: 'Patterns in Motion',
                detail: 'Compare multiple architectures against real trade-offs.',
                state: 'Up next',
                accent: AppColors.surfaceBlue,
              ),
              _JourneyNode(
                title: 'Synthesis Studio',
                detail: 'Defend your own architecture with concrete rationale.',
                state: 'Locked',
                accent: AppColors.surfaceMint,
                isLast: true,
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        SectionCard(
          title: 'Knowledge Constellation',
          subtitle: 'A visual layer that reveals how each concept connects.',
          trailing: const ProgressBadge(label: 'Soon'),
          child: Text(
            'After the primary roadmap is stable, this view will let you branch into related systems, tensions, and examples without losing the main sequence.',
            style: textTheme.bodyMedium,
          ),
        ),
      ],
    );
  }
}

class _JourneyNode extends StatelessWidget {
  const _JourneyNode({
    required this.title,
    required this.detail,
    required this.state,
    required this.accent,
    this.isFirst = false,
    this.isLast = false,
  });

  final String title;
  final String detail;
  final String state;
  final Color accent;
  final bool isFirst;
  final bool isLast;

  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;

    return SizedBox(
      height: 118,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SizedBox(
            width: 28,
            child: Column(
              children: [
                Expanded(
                  child: Container(
                    width: 2,
                    color: isFirst ? Colors.transparent : AppColors.outlineSoft,
                  ),
                ),
                Container(
                  width: 14,
                  height: 14,
                  decoration: BoxDecoration(
                    color: AppColors.primary,
                    borderRadius: BorderRadius.circular(999),
                  ),
                ),
                Expanded(
                  child: Container(
                    width: 2,
                    color: isLast ? Colors.transparent : AppColors.outlineSoft,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: DecoratedBox(
              decoration: BoxDecoration(
                color: accent,
                borderRadius: BorderRadius.circular(24),
                border: Border.all(color: AppColors.outlineSoft),
              ),
              child: Padding(
                padding: const EdgeInsets.all(18),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title, style: textTheme.titleLarge),
                    const SizedBox(height: 8),
                    Expanded(
                      child: Text(detail, style: textTheme.bodyMedium),
                    ),
                    Text(
                      state,
                      style: textTheme.labelLarge?.copyWith(
                        color: AppColors.primary,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
