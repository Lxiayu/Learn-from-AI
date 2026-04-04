import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../app/locale/app_copy.dart';
import '../../../app/theme/app_colors.dart';
import '../../../shared/layout/detail_page_scaffold.dart';
import '../../../shared/widgets/primary_action_button.dart';

class MistakesMasteredCelebrationScreen extends StatelessWidget {
  const MistakesMasteredCelebrationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final AppCopy copy = context.copy;
    final TextTheme textTheme = Theme.of(context).textTheme;

    return DetailPageScaffold(
      title: copy.t(en: 'Mistakes Mastered', zh: '薄弱点已掌握'),
      children: [
        const SizedBox(height: 12),
        Center(
          child: Stack(
            alignment: Alignment.center,
            children: [
              Container(
                width: 240,
                height: 240,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: Color(0x1424389C),
                ),
              ),
              Container(
                width: 172,
                height: 172,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: LinearGradient(
                    colors: [
                      AppColors.primary,
                      AppColors.primaryContainer,
                    ],
                  ),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.verified_rounded,
                      size: 54,
                      color: AppColors.onPrimary,
                    ),
                    SizedBox(height: 12),
                    Text(
                      copy.t(en: 'MASTERED', zh: '已掌握'),
                      style: TextStyle(
                        color: AppColors.onPrimary,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 1.2,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 24),
        Center(
          child: Text(
            copy.t(en: 'Mistakes Mastered', zh: '薄弱点已掌握'),
            style: textTheme.displayLarge?.copyWith(fontSize: 36),
          ),
        ),
        const SizedBox(height: 10),
        Center(
          child: Text(
            copy.t(
              en: 'Excellent work, Alex! By revisiting these challenging concepts, you\'ve turned a potential gap into a solid foundation.',
              zh: '做得很好，Alex！通过重新攻克这些困难概念，你已经把原本可能成为短板的地方，变成了更扎实的基础。',
            ),
            textAlign: TextAlign.center,
            style: textTheme.bodyLarge,
          ),
        ),
        const SizedBox(height: 24),
        Wrap(
          spacing: 12,
          runSpacing: 12,
          alignment: WrapAlignment.center,
          children: [
            _CelebrationStat(value: '3', label: copy.t(en: 'CONCEPTS', zh: '概念')),
            _CelebrationStat(value: copy.t(en: '12-day', zh: '12 天'), label: copy.t(en: 'STREAK', zh: '连续')),
          ],
        ),
        const SizedBox(height: 24),
        Row(
          children: [
            Expanded(
              child: DecoratedBox(
                decoration: BoxDecoration(
                  color: AppColors.surfaceElevated,
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(color: AppColors.outlineSoft),
                ),
                child: Padding(
                  padding: EdgeInsets.all(18),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Icon(Icons.school_outlined, color: AppColors.primary),
                      SizedBox(height: 12),
                      Text(copy.t(en: 'Foundations', zh: '基础能力')),
                      SizedBox(height: 4),
                      Text(copy.t(en: 'Cognitive Bias, Logic, Reasoning', zh: '认知偏差、逻辑与推理')),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: DecoratedBox(
                decoration: BoxDecoration(
                  color: AppColors.surfaceElevated,
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(color: AppColors.outlineSoft),
                ),
                child: Padding(
                  padding: EdgeInsets.all(18),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Icon(Icons.trending_up_rounded, color: AppColors.tertiary),
                      SizedBox(height: 12),
                      Text(copy.t(en: 'Growth', zh: '成长')),
                      SizedBox(height: 4),
                      Text(copy.t(en: '+15% retention rate this week', zh: '本周保持度提升 15%')),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 24),
        SizedBox(
          width: double.infinity,
          child: PrimaryActionButton(
            label: copy.t(en: 'Continue Journey', zh: '继续学习旅程'),
            onPressed: () => context.go('/home'),
          ),
        ),
      ],
    );
  }
}

class _CelebrationStat extends StatelessWidget {
  const _CelebrationStat({
    required this.value,
    required this.label,
  });

  final String value;
  final String label;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerLow,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(value, style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(width: 8),
            Text(label),
          ],
        ),
      ),
    );
  }
}
