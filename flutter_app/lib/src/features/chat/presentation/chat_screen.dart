import 'package:flutter/material.dart';

import '../../../app/theme/app_colors.dart';
import '../../../shared/layout/app_scaffold_shell.dart';
import '../../../shared/widgets/primary_action_button.dart';
import '../../../shared/widgets/progress_badge.dart';
import '../../../shared/widgets/section_card.dart';

class ChatScreen extends StatelessWidget {
  const ChatScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;

    return AppScaffoldShell(
      title: 'Socratic Chat',
      children: [
        Text('Current Topic', style: textTheme.displayLarge),
        const SizedBox(height: 8),
        Text(
          'Binary search, boundary conditions, and how to explain the invariant in your own words.',
          style: textTheme.bodyLarge,
        ),
        const SizedBox(height: 24),
        const SectionCard(
          title: 'AI Prompt',
          subtitle: 'Explain before you optimize',
          trailing: ProgressBadge(label: 'Question 3 of 6'),
          child: _PromptPanel(),
        ),
        const SizedBox(height: 16),
        SectionCard(
          title: 'Response Workspace',
          subtitle: 'Use your own words, then compare with a concrete example.',
          trailing: const ProgressBadge(label: 'Active'),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextField(
                minLines: 5,
                maxLines: 7,
                decoration: InputDecoration(
                  hintText:
                      'Try describing why the search interval keeps shrinking...',
                  filled: true,
                  fillColor: AppColors.surfaceContainerLow,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(24),
                    borderSide: BorderSide.none,
                  ),
                  contentPadding: const EdgeInsets.all(18),
                ),
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: PrimaryActionButton(
                      label: 'Submit Response',
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
          title: 'Learning Controls',
          subtitle: 'Use the AI tools that support this round.',
          trailing: const ProgressBadge(label: 'Ready'),
          child: Wrap(
            spacing: 12,
            runSpacing: 12,
            children: [
              _SecondaryPillButton(
                label: 'Focus Mode',
                onPressed: () {},
              ),
              _SecondaryPillButton(
                label: 'Multimodal Input',
                onPressed: () {},
              ),
              _SecondaryPillButton(
                label: 'Ask for Hint',
                onPressed: () {},
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _PromptPanel extends StatelessWidget {
  const _PromptPanel();

  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'If a binary search implementation skips the target at the edges, what invariant is most likely broken?',
          style: textTheme.bodyLarge,
        ),
        const SizedBox(height: 12),
        Text(
          'Think about the meaning of the left and right pointers after each iteration.',
          style: textTheme.bodyMedium,
        ),
      ],
    );
  }
}

class _SecondaryPillButton extends StatelessWidget {
  const _SecondaryPillButton({
    required this.label,
    required this.onPressed,
  });

  final String label;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      onPressed: onPressed,
      style: OutlinedButton.styleFrom(
        foregroundColor: AppColors.primary,
        side: BorderSide.none,
        backgroundColor: AppColors.surfaceContainer,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        shape: const StadiumBorder(),
      ),
      child: Text(label),
    );
  }
}
