import 'package:flutter/material.dart';

import '../../../app/locale/app_copy.dart';
import '../../../app/theme/app_colors.dart';
import '../../../shared/layout/detail_page_scaffold.dart';

class AchievementsGalleryScreen extends StatelessWidget {
  const AchievementsGalleryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final AppCopy copy = context.copy;
    final TextTheme textTheme = Theme.of(context).textTheme;

    return DetailPageScaffold(
      title: copy.t(en: 'Your Achievements', zh: '你的成就'),
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    copy.t(en: 'Elite', zh: '高阶'),
                    style: textTheme.displayLarge?.copyWith(fontSize: 40),
                  ),
                  Text(
                    copy.t(en: 'Cognitive Strategist', zh: '认知策略家'),
                    style: textTheme.displayLarge?.copyWith(
                      fontSize: 40,
                      color: AppColors.primaryContainer,
                    ),
                  ),
                ],
              ),
            ),
            DecoratedBox(
              decoration: BoxDecoration(
                color: AppColors.surfaceContainerLow,
                borderRadius: BorderRadius.circular(28),
              ),
              child: Padding(
                padding: EdgeInsets.all(18),
                child: Column(
                  children: [
                    Text('12,450'),
                    SizedBox(height: 4),
                    Text(copy.t(en: 'Total Points', zh: '总积分')),
                  ],
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 24),
        GridView.count(
          crossAxisCount: 2,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          crossAxisSpacing: 14,
          mainAxisSpacing: 14,
          childAspectRatio: 1,
          children: [
            _AchievementTile(
              title: copy.t(en: 'Socratic Master', zh: '苏格拉底大师'),
              detail: copy.t(
                en: 'Maintained a questioning streak for 30 consecutive sessions.',
                zh: '连续 30 次学习保持高质量追问。',
              ),
              earned: true,
            ),
            _AchievementTile(
              title: copy.t(en: 'Deep Diver', zh: '深潜者'),
              detail: copy.t(
                en: 'Spent over 10 hours exploring a single complex subject node.',
                zh: '在一个复杂主题节点上累计探索超过 10 小时。',
              ),
              earned: true,
            ),
            _AchievementTile(
              title: copy.t(en: 'Consistency King', zh: '稳定节奏王'),
              detail: copy.t(
                en: 'Hit your daily learning goal for 50 days in a row.',
                zh: '连续 50 天完成每日学习目标。',
              ),
              earned: true,
            ),
            _AchievementTile(
              title: copy.t(en: 'Insight Architect', zh: '洞察架构师'),
              detail: copy.t(
                en: 'Generate 500 unique concept connections within the graph.',
                zh: '在知识图谱中建立 500 条独特概念连接。',
              ),
              earned: false,
            ),
          ],
        ),
      ],
    );
  }
}

class _AchievementTile extends StatelessWidget {
  const _AchievementTile({
    required this.title,
    required this.detail,
    required this.earned,
  });

  final String title;
  final String detail;
  final bool earned;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: earned ? AppColors.surfaceContainerHighest : AppColors.surfaceContainerLow,
        borderRadius: BorderRadius.circular(28),
        border: Border.all(
          color: earned ? Colors.transparent : AppColors.outlineSoft,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(
              earned ? Icons.workspace_premium_rounded : Icons.lock_outline_rounded,
              color: earned ? AppColors.primary : AppColors.onSurfaceVariant,
            ),
            const SizedBox(height: 14),
            Text(title, style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 10),
            Expanded(child: Text(detail)),
          ],
        ),
      ),
    );
  }
}
