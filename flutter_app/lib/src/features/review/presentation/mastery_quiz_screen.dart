import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../app/locale/app_copy.dart';
import '../../../app/theme/app_colors.dart';
import '../../../shared/layout/detail_page_scaffold.dart';
import '../../../shared/widgets/primary_action_button.dart';

class MasteryQuizScreen extends StatelessWidget {
  const MasteryQuizScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final AppCopy copy = context.copy;
    final TextTheme textTheme = Theme.of(context).textTheme;

    return DetailPageScaffold(
      title: copy.t(en: 'Mastery Quiz', zh: '掌握度测验'),
      eyebrow: copy.t(en: 'Module 04 - Advanced Physics', zh: '模块 04 - 高阶物理'),
      trailing: Text(
        'Curator.ai',
        style: textTheme.labelLarge?.copyWith(color: AppColors.primary),
      ),
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Expanded(
              child: Text(
                copy.t(en: 'Quantum Mechanics: Wave-Particle Duality', zh: '量子力学：波粒二象性'),
                style: textTheme.headlineMedium,
              ),
            ),
            const SizedBox(width: 16),
            Text(copy.t(en: 'Question 07 of 12', zh: '第 7 / 12 题'), style: textTheme.labelMedium),
          ],
        ),
        const SizedBox(height: 16),
        ClipRRect(
          borderRadius: BorderRadius.circular(999),
          child: const LinearProgressIndicator(
            value: 0.58,
            minHeight: 8,
            backgroundColor: AppColors.surfaceContainerHigh,
            color: AppColors.tertiary,
          ),
        ),
        const SizedBox(height: 24),
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
                Text(
                  copy.t(
                    en: 'In the context of the double-slit experiment, what occurs to the interference pattern when an observer attempts to determine which slit a specific electron passes through?',
                    zh: '在双缝实验中，如果观察者试图判断某个电子究竟穿过了哪一条缝，干涉条纹会发生什么变化？',
                  ),
                ),
                SizedBox(height: 20),
                _OptionTile(
                  label: 'A',
                  text: copy.t(
                    en: 'The interference pattern remains unchanged but increases in brightness.',
                    zh: '干涉条纹保持不变，只是整体亮度增加。',
                  ),
                  selected: true,
                ),
                SizedBox(height: 12),
                _OptionTile(
                  label: 'B',
                  text: copy.t(
                    en: 'The interference pattern collapses and the electrons behave as classical particles.',
                    zh: '干涉条纹消失，电子表现得更像经典粒子。',
                  ),
                ),
                SizedBox(height: 12),
                _OptionTile(
                  label: 'C',
                  text: copy.t(
                    en: 'The pattern shifts laterally by exactly one half-wavelength.',
                    zh: '条纹会横向平移，恰好偏移半个波长。',
                  ),
                ),
                SizedBox(height: 12),
                _OptionTile(
                  label: 'D',
                  text: copy.t(
                    en: 'Multiple interference patterns emerge, creating a complex fractal geometry.',
                    zh: '会出现多组干涉条纹，形成复杂的分形结构。',
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 20),
        Row(
          children: [
            TextButton(
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      copy.t(
                        en: 'Question skipped in preview mode.',
                        zh: '当前是预览模式，已跳过这道题。',
                      ),
                    ),
                  ),
                );
              },
              child: Text(copy.t(en: 'Skip Question', zh: '跳过此题')),
            ),
            const Spacer(),
            SizedBox(
              width: 180,
              child: PrimaryActionButton(
                label: copy.t(en: 'Submit Answer', zh: '提交答案'),
                onPressed: () => context.push('/review/results'),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _OptionTile extends StatelessWidget {
  const _OptionTile({
    required this.label,
    required this.text,
    this.selected = false,
  });

  final String label;
  final String text;
  final bool selected;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: selected ? AppColors.surfaceContainerHighest : AppColors.surfaceContainerLow,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: selected ? AppColors.primary.withValues(alpha: 0.25) : Colors.transparent,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CircleAvatar(
              radius: 18,
              backgroundColor:
                  selected ? AppColors.primary : AppColors.surfaceElevated,
              child: Text(
                label,
                style: TextStyle(
                  color: selected ? AppColors.onPrimary : AppColors.onSurface,
                ),
              ),
            ),
            const SizedBox(width: 14),
            Expanded(child: Text(text)),
          ],
        ),
      ),
    );
  }
}
