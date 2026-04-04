import 'package:flutter/material.dart';

import '../../../app/locale/app_copy.dart';
import '../../../app/theme/app_colors.dart';

class NewAchievementNotificationScreen extends StatelessWidget {
  const NewAchievementNotificationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final AppCopy copy = context.copy;
    final TextTheme textTheme = Theme.of(context).textTheme;

    return Scaffold(
      backgroundColor: AppColors.surface,
      body: SafeArea(
        child: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
              child: Column(
                children: [
                  Row(
                    children: [
                      const Icon(Icons.menu_rounded, color: AppColors.primary),
                      const SizedBox(width: 12),
                      Text(copy.t(en: 'The Curator', zh: '学习策展人'), style: textTheme.titleLarge),
                      const Spacer(),
                      const CircleAvatar(
                        backgroundColor: AppColors.surfaceContainerHighest,
                        child: Icon(Icons.person_outline, color: AppColors.primary),
                      ),
                    ],
                  ),
                  const Spacer(),
                ],
              ),
            ),
            Center(
              child: DecoratedBox(
                decoration: BoxDecoration(
                  color: AppColors.surfaceElevated.withValues(alpha: 0.96),
                  borderRadius: BorderRadius.circular(32),
                  border: Border.all(color: AppColors.outlineSoft),
                  boxShadow: const [
                    BoxShadow(
                      color: AppColors.shadow,
                      blurRadius: 28,
                      offset: Offset(0, 16),
                    ),
                  ],
                ),
                child: SizedBox(
                  width: 380,
                  child: Padding(
                    padding: const EdgeInsets.all(28),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          width: 128,
                          height: 128,
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            gradient: LinearGradient(
                              colors: [
                                AppColors.primary,
                                AppColors.primaryContainer,
                              ],
                            ),
                          ),
                          child: const Icon(
                            Icons.badge_rounded,
                            size: 62,
                            color: AppColors.onPrimary,
                          ),
                        ),
                        const SizedBox(height: 22),
                        Text(
                          copy.t(en: 'New Achievement Unlocked!', zh: '解锁新成就！'),
                          style: textTheme.titleLarge?.copyWith(
                            color: AppColors.primary,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          copy.t(en: 'The Deep Diver', zh: '深潜者'),
                          style: textTheme.displayLarge?.copyWith(fontSize: 32),
                        ),
                        const SizedBox(height: 12),
                        Text(
                          copy.t(
                            en: 'You have asked 10 deep-probing questions in a single session. Your curiosity is your greatest tool.',
                            zh: '你在一次学习中提出了 10 个深入追问。持续的好奇心，就是你最强的学习工具。',
                          ),
                          textAlign: TextAlign.center,
                          style: textTheme.bodyLarge,
                        ),
                        const SizedBox(height: 22),
                        FilledButton(
                          onPressed: () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                  copy.t(
                                    en: 'Share cards will be available here soon.',
                                    zh: '分享卡片功能很快会出现在这里。',
                                  ),
                                ),
                              ),
                            );
                          },
                          child: Text(copy.t(en: 'Share Achievement', zh: '分享成就')),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
