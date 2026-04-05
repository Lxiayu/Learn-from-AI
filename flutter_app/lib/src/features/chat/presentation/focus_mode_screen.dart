import 'package:flutter/material.dart';

import '../../../app/locale/app_copy.dart';
import '../../../app/theme/app_colors.dart';

class FocusModeScreen extends StatelessWidget {
  const FocusModeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final AppCopy copy = context.copy;
    final TextTheme textTheme = Theme.of(context).textTheme;

    return Scaffold(
      backgroundColor: AppColors.surface,
      body: DecoratedBox(
        decoration: const BoxDecoration(
          gradient: RadialGradient(
            colors: [
              AppColors.surfaceElevated,
              AppColors.surfaceContainerLow,
            ],
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
            child: Column(
              children: [
                Row(
                  children: [
                    TextButton.icon(
                      onPressed: () => Navigator.of(context).maybePop(),
                      icon: const Icon(Icons.close_rounded),
                      label: Text(copy.t(en: 'Exit Focus', zh: '退出专注')),
                    ),
                    const Spacer(),
                    DecoratedBox(
                      decoration: BoxDecoration(
                        color: AppColors.surfaceElevated.withValues(alpha: 0.88),
                        borderRadius: BorderRadius.circular(999),
                        border: Border.all(color: AppColors.outlineSoft),
                      ),
                      child: Padding(
                        padding:
                            EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                        child: Row(
                          children: [
                            Icon(
                              Icons.circle,
                              size: 10,
                              color: AppColors.tertiary,
                            ),
                            SizedBox(width: 8),
                            Text(copy.t(en: '18:42', zh: '18:42')),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 40),
                Container(
                  width: 128,
                  height: 128,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: const LinearGradient(
                      colors: [
                        AppColors.surfaceBlueStrong,
                        AppColors.surfaceContainerHighest,
                      ],
                    ),
                    boxShadow: const [
                      BoxShadow(
                        color: AppColors.shadow,
                        blurRadius: 32,
                        offset: Offset(0, 14),
                      ),
                    ],
                  ),
                  child: const Icon(
                    Icons.grain_rounded,
                    size: 48,
                    color: AppColors.primary,
                  ),
                ),
                const SizedBox(height: 36),
                Text(
                  copy.t(
                    en: 'How would you describe the relationship between Wavefunction and Probability?',
                    zh: '你会如何描述“波函数”和“概率”之间的关系？',
                  ),
                  textAlign: TextAlign.center,
                  style: textTheme.displayLarge?.copyWith(
                    fontSize: 30,
                    height: 1.18,
                  ),
                ),
                const SizedBox(height: 18),
                Text(
                  copy.t(
                    en: 'Take a moment to center your thoughts. When you are ready to articulate your insight, begin typing below.',
                    zh: '先让思绪沉下来。准备好表达你的理解之后，再开始输入。',
                  ),
                  textAlign: TextAlign.center,
                  style: textTheme.bodyLarge?.copyWith(
                    color: AppColors.onSurfaceVariant,
                  ),
                ),
                const SizedBox(height: 28),
                TextField(
                  minLines: 5,
                  maxLines: 7,
                  decoration: InputDecoration(
                    hintText: copy.t(
                      en: 'Enter your thoughts...',
                      zh: '输入你的思考……',
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Wrap(
                  alignment: WrapAlignment.center,
                  spacing: 10,
                  runSpacing: 10,
                  children: [
                    _FocusChip(label: copy.t(en: 'The Born Rule', zh: '玻恩定则')),
                    _FocusChip(label: copy.t(en: 'Superposition', zh: '叠加态')),
                    _FocusChip(label: copy.t(en: 'Observable States', zh: '可观测状态')),
                  ],
                ),
                const SizedBox(height: 28),
                DecoratedBox(
                  decoration: BoxDecoration(
                    color: AppColors.surfaceElevated.withValues(alpha: 0.8),
                    borderRadius: BorderRadius.circular(999),
                    border: Border.all(color: AppColors.outlineSoft),
                  ),
                  child: Padding(
                    padding:
                        EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                    child: Text(copy.t(en: 'Deep Flow Mode Active', zh: '深度专注模式已开启')),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _FocusChip extends StatelessWidget {
  const _FocusChip({
    required this.label,
  });

  final String label;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: AppColors.surfaceElevated.withValues(alpha: 0.8),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: AppColors.outlineSoft),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        child: Text(label),
      ),
    );
  }
}
