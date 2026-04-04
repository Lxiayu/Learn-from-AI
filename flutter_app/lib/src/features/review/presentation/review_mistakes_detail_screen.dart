import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../app/locale/app_copy.dart';
import '../../../app/theme/app_colors.dart';
import '../../../shared/layout/detail_page_scaffold.dart';
import '../../../shared/widgets/primary_action_button.dart';

class ReviewMistakesDetailScreen extends StatelessWidget {
  const ReviewMistakesDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final AppCopy copy = context.copy;
    final TextTheme textTheme = Theme.of(context).textTheme;

    return DetailPageScaffold(
      title: copy.t(en: 'Review Mistakes', zh: '错题复盘'),
      children: [
        DecoratedBox(
          decoration: BoxDecoration(
            color: AppColors.surfaceElevated,
            borderRadius: BorderRadius.circular(32),
            border: Border.all(color: AppColors.outlineSoft),
          ),
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                DecoratedBox(
                  decoration: BoxDecoration(
                    color: AppColors.surfaceContainerHighest,
                    borderRadius: BorderRadius.circular(999),
                  ),
                  child: Padding(
                    padding:
                        EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    child: Text(copy.t(en: 'Quantum Physics', zh: '量子物理')),
                  ),
                ),
                const SizedBox(height: 18),
                Text(
                  copy.t(
                    en: 'What occurs to the interference pattern when an observer attempts to determine which slit a specific electron passes through?',
                    zh: '当观察者试图判断某个电子通过哪一条缝时，干涉条纹会发生什么变化？',
                  ),
                  style: textTheme.headlineSmall,
                ),
                const SizedBox(height: 18),
                _AnswerCard(
                  label: 'A',
                  text: copy.t(
                    en: 'The interference pattern remains unchanged because the electron exists in a state of superposition until it hits the final detector.',
                    zh: '干涉条纹保持不变，因为电子在最终被探测之前始终处于叠加态。',
                  ),
                  correct: false,
                ),
                const SizedBox(height: 12),
                _AnswerCard(
                  label: 'B',
                  text: copy.t(
                    en: 'The interference pattern collapses, and the electrons behave like particles, forming two distinct bands on the screen.',
                    zh: '干涉条纹会坍缩，电子表现得更像粒子，在屏幕上形成两条明显的带状分布。',
                  ),
                  correct: true,
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 20),
        DecoratedBox(
          decoration: BoxDecoration(
            color: AppColors.surfaceContainerHighest,
            borderRadius: BorderRadius.circular(28),
          ),
          child: Padding(
            padding: const EdgeInsets.all(22),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(copy.t(en: 'AI Coach Explanation', zh: 'AI 讲解'), style: textTheme.titleLarge),
                const SizedBox(height: 12),
                Text(
                  copy.t(
                    en: 'When we don\'t look, the electron behaves like a wave passing through both slits. Once we observe which slit it takes, the wavefunction collapses and the interference pattern disappears.',
                    zh: '在不进行路径观测时，电子像波一样同时穿过两条缝；一旦我们试图观察它究竟走了哪条路径，波函数就会坍缩，干涉条纹也随之消失。',
                  ),
                  style: textTheme.bodyLarge,
                ),
                const SizedBox(height: 12),
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: AppColors.tertiaryFixedDim.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: AppColors.tertiary),
                  ),
                  child: Text(
                    copy.t(
                      en: 'The act of measurement forces the universe to make a choice. This is the wavefunction collapse.',
                      zh: '测量让系统“做出选择”，这就是所谓的波函数坍缩。',
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 20),
        SizedBox(
          width: double.infinity,
          child: PrimaryActionButton(
            label: copy.t(en: 'Got It, Next Mistake', zh: '明白了，继续下一题'),
            onPressed: () => context.push('/review/celebration'),
          ),
        ),
      ],
    );
  }
}

class _AnswerCard extends StatelessWidget {
  const _AnswerCard({
    required this.label,
    required this.text,
    required this.correct,
  });

  final String label;
  final String text;
  final bool correct;

  @override
  Widget build(BuildContext context) {
    final Color tone = correct ? AppColors.tertiary : const Color(0xFFBA1A1A);

    return DecoratedBox(
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerLow,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: tone.withValues(alpha: 0.22)),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CircleAvatar(
              radius: 16,
              backgroundColor: tone,
              child: Text(label, style: const TextStyle(color: Colors.white)),
            ),
            const SizedBox(width: 14),
            Expanded(child: Text(text)),
          ],
        ),
      ),
    );
  }
}
