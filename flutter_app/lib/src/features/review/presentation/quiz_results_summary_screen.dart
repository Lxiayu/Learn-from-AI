import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../app/locale/app_copy.dart';
import '../../../app/theme/app_colors.dart';
import '../../../shared/layout/detail_page_scaffold.dart';
import '../../../shared/widgets/primary_action_button.dart';

class QuizResultsSummaryScreen extends StatelessWidget {
  const QuizResultsSummaryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final AppCopy copy = context.copy;
    final TextTheme textTheme = Theme.of(context).textTheme;

    return DetailPageScaffold(
      title: copy.t(en: 'Learning Progress', zh: '学习进度'),
      children: [
        Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  DecoratedBox(
                    decoration: BoxDecoration(
                      color: AppColors.tertiaryFixedDim.withValues(alpha: 0.25),
                      borderRadius: BorderRadius.circular(999),
                    ),
                    child: Padding(
                      padding:
                          EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                      child: Text(copy.t(en: 'New Milestone Achieved', zh: '达成新里程碑')),
                    ),
                  ),
                  const SizedBox(height: 18),
                  Text(
                    copy.t(en: 'Phenomenal work on Quantum Mechanics II.', zh: '你在《量子力学 II》中的表现非常出色。'),
                    style: textTheme.headlineMedium,
                  ),
                  const SizedBox(height: 12),
                  Text(
                    copy.t(
                      en: 'You\'ve demonstrated a deep understanding of wavefunctions and observer effects.',
                      zh: '你已经对波函数和观察者效应表现出了相当深入的理解。',
                    ),
                    style: textTheme.bodyLarge,
                  ),
                ],
              ),
            ),
            const SizedBox(width: 20),
            Container(
              width: 160,
              height: 160,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                gradient: SweepGradient(
                  colors: [
                    AppColors.primary,
                    AppColors.primaryContainer,
                    AppColors.surfaceContainerHighest,
                    AppColors.surfaceContainerHighest,
                  ],
                  stops: [0.0, 0.92, 0.92, 1.0],
                ),
              ),
              child: Center(
                child: Container(
                  width: 120,
                  height: 120,
                  decoration: const BoxDecoration(
                    color: AppColors.surface,
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: Text(
                      '92%',
                      style: textTheme.displayLarge?.copyWith(fontSize: 32),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 24),
        Wrap(
          spacing: 14,
          runSpacing: 14,
          children: [
            _MetricCard(label: copy.t(en: 'Concepts Mastered', zh: '已掌握概念'), value: '8/10'),
            _MetricCard(label: copy.t(en: 'Time Taken', zh: '耗时'), value: copy.t(en: '14m 22s', zh: '14分22秒')),
            _MetricCard(label: copy.t(en: 'Accuracy Rate', zh: '正确率'), value: '90%'),
          ],
        ),
        const SizedBox(height: 24),
        _InsightCard(textTheme: textTheme, copy: copy),
        const SizedBox(height: 24),
        Row(
          children: [
            Expanded(
              child: PrimaryActionButton(
                label: copy.t(en: 'Continue Journey', zh: '继续学习旅程'),
                onPressed: () => context.go('/roadmap'),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: OutlinedButton(
                onPressed: () => context.push('/review/mistakes'),
                child: Text(copy.t(en: 'Review Mistakes', zh: '查看错题')),
              ),
            ),
          ],
        ),
      ],
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

    return SizedBox(
      width: 180,
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: AppColors.surfaceContainerLow,
          borderRadius: BorderRadius.circular(24),
        ),
        child: Padding(
          padding: const EdgeInsets.all(20),
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

class _InsightCard extends StatelessWidget {
  const _InsightCard({
    required this.textTheme,
    required this.copy,
  });

  final TextTheme textTheme;
  final AppCopy copy;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(28),
      ),
      child: Padding(
        padding: const EdgeInsets.all(22),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(copy.t(en: 'Curator\'s Insight', zh: '学习建议'), style: textTheme.titleLarge),
            const SizedBox(height: 12),
            Text(
              copy.t(
                en: 'Excellent work! You\'ve masterfully navigated Wave-Particle Duality. Let\'s tackle Quantum Entanglement next.',
                zh: '表现很棒！你已经很好地掌握了“波粒二象性”。下一步可以挑战“量子纠缠”了。',
              ),
              style: textTheme.bodyLarge,
            ),
          ],
        ),
      ),
    );
  }
}
