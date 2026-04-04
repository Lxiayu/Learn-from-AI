import 'package:flutter/material.dart';

import '../../../app/locale/app_copy.dart';
import '../../../app/theme/app_colors.dart';

class AiThinkingStateScreen extends StatelessWidget {
  const AiThinkingStateScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final AppCopy copy = context.copy;
    final TextTheme textTheme = Theme.of(context).textTheme;

    return Scaffold(
      backgroundColor: AppColors.surface,
      body: SafeArea(
        child: Stack(
          children: [
            Center(
              child: Container(
                width: 360,
                height: 360,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: RadialGradient(
                    colors: [
                      Color(0x1924389C),
                      Colors.transparent,
                    ],
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
              child: Column(
                children: [
                  Row(
                    children: [
                      IconButton(
                        onPressed: () => Navigator.of(context).maybePop(),
                        icon: const Icon(
                          Icons.arrow_back_rounded,
                          color: AppColors.primary,
                        ),
                      ),
                      Text(copy.t(en: 'Socratic Dialogue', zh: '苏格拉底对话'), style: textTheme.titleLarge),
                      const Spacer(),
                      IconButton(
                        onPressed: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                copy.t(
                                  en: 'More session actions will appear here soon.',
                                  zh: '更多会话动作很快会出现在这里。',
                                ),
                              ),
                            ),
                          );
                        },
                        icon: const Icon(
                          Icons.more_vert_rounded,
                          color: AppColors.primary,
                        ),
                      ),
                    ],
                  ),
                  const Spacer(),
                  Stack(
                    alignment: Alignment.center,
                    children: [
                      Container(
                        width: 210,
                        height: 210,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(color: AppColors.outlineSoft),
                        ),
                      ),
                      Container(
                        width: 96,
                        height: 96,
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: LinearGradient(
                            colors: [
                              AppColors.primary,
                              AppColors.primaryContainer,
                            ],
                          ),
                        ),
                      ),
                      Positioned(
                        top: 18,
                        right: 10,
                        child: _StateChip(
                          icon: Icons.psychology_alt_outlined,
                          label: copy.t(en: 'Logic Check', zh: '逻辑校验'),
                        ),
                      ),
                      Positioned(
                        bottom: 24,
                        left: 0,
                        child: _StateChip(
                          icon: Icons.auto_awesome_outlined,
                          label: copy.t(en: 'Synthesizing', zh: '综合推理中'),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 30),
                  Text(
                    copy.t(
                      en: 'Synthesizing your previous answers...',
                      zh: '正在综合你之前的回答……',
                    ),
                    textAlign: TextAlign.center,
                    style: textTheme.headlineMedium,
                  ),
                  const SizedBox(height: 14),
                  Text(
                    copy.t(
                      en: 'Evaluating dialectic patterns to craft your next cognitive challenge.',
                      zh: '正在分析你的思考轨迹，为下一轮认知挑战构建更合适的问题。',
                    ),
                    textAlign: TextAlign.center,
                    style: textTheme.bodyLarge?.copyWith(
                      color: AppColors.onSurfaceVariant,
                    ),
                  ),
                  const Spacer(),
                  Column(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(999),
                        child: const LinearProgressIndicator(
                          value: 0.67,
                          minHeight: 7,
                          backgroundColor: AppColors.surfaceContainerHigh,
                          color: AppColors.tertiary,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        copy.t(
                          en: 'Stage 2 of 3: Deep Contextual Mapping',
                          zh: '第 2 / 3 阶段：深层语境映射',
                        ),
                        style: textTheme.labelMedium,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _StateChip extends StatelessWidget {
  const _StateChip({
    required this.icon,
    required this.label,
  });

  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: AppColors.surfaceElevated.withValues(alpha: 0.9),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: AppColors.outlineSoft),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 16, color: AppColors.primary),
            const SizedBox(width: 8),
            Text(label),
          ],
        ),
      ),
    );
  }
}
