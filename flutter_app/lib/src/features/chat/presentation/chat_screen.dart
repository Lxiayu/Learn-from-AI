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
                const ProgressBadge(label: 'Current Inquiry'),
                const SizedBox(height: 16),
                Text(
                  'The Essence of Justice',
                  style: textTheme.displayLarge?.copyWith(fontSize: 34),
                ),
                const SizedBox(height: 10),
                Text(
                  'Move from intuition to articulation: define justice, contrast it with obedience, and test the idea against a hard case.',
                  style: textTheme.bodyLarge?.copyWith(
                    color: AppColors.onSurfaceVariant,
                  ),
                ),
                const SizedBox(height: 18),
                Row(
                  children: [
                    Expanded(
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(999),
                        child: const LinearProgressIndicator(
                          value: 0.55,
                          minHeight: 9,
                          backgroundColor: AppColors.surfaceContainerHigh,
                          color: AppColors.primary,
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Text('Question 3 / 5', style: textTheme.labelMedium),
                  ],
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 16),
        SectionCard(
          title: 'Dialogue Canvas',
          subtitle: 'Follow the prompt ladder from explanation to transfer.',
          trailing: const ProgressBadge(label: 'Socratic mode'),
          child: Column(
            children: const [
              _ChatBubble(
                speaker: 'Socrates',
                message:
                    'Before we speak of justice, tell me this: is every lawful act also just, or have you seen moments where the two separate?',
                accent: AppColors.surfaceWarm,
                alignEnd: false,
              ),
              SizedBox(height: 12),
              _ChatBubble(
                speaker: 'You',
                message:
                    'I think justice is deeper than rules, because rules can be used without wisdom or fairness.',
                accent: AppColors.surfaceBlue,
                alignEnd: true,
              ),
              SizedBox(height: 12),
              _ChatBubble(
                speaker: 'Socrates',
                message:
                    'Good. Now give me a concrete example where obedience feels insufficient, and we will test your definition against it.',
                accent: AppColors.surfaceRose,
                alignEnd: false,
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        SectionCard(
          title: 'Shape Your Answer',
          subtitle: 'Respond in your own words, then refine after the next prompt.',
          trailing: const ProgressBadge(label: 'Active response'),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const TextField(
                minLines: 5,
                maxLines: 7,
                decoration: InputDecoration(
                  hintText:
                      'Describe justice in your own words, then add one example where fairness and law pull apart...',
                ),
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: PrimaryActionButton(
                      label: 'Send Reflection',
                      onPressed: () {},
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        Wrap(
          spacing: 12,
          runSpacing: 12,
          children: const [
            _ActionChip(label: 'Ask for a hint', icon: Icons.lightbulb_outline),
            _ActionChip(label: 'Request a counterexample', icon: Icons.compare_arrows_rounded),
            _ActionChip(label: 'Switch to focus mode', icon: Icons.center_focus_strong_rounded),
          ],
        ),
      ],
    );
  }
}

class _ChatBubble extends StatelessWidget {
  const _ChatBubble({
    required this.speaker,
    required this.message,
    required this.accent,
    required this.alignEnd,
  });

  final String speaker;
  final String message;
  final Color accent;
  final bool alignEnd;

  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;

    return Align(
      alignment: alignEnd ? Alignment.centerRight : Alignment.centerLeft,
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 420),
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
                Text(
                  speaker,
                  style: textTheme.labelLarge?.copyWith(
                    color: AppColors.onSurface,
                  ),
                ),
                const SizedBox(height: 8),
                Text(message, style: textTheme.bodyMedium),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _ActionChip extends StatelessWidget {
  const _ActionChip({
    required this.label,
    required this.icon,
  });

  final String label;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;

    return DecoratedBox(
      decoration: BoxDecoration(
        color: AppColors.surfaceElevated,
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: AppColors.outlineSoft),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
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
