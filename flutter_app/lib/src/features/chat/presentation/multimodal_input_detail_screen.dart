import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../app/locale/app_copy.dart';
import '../../../app/theme/app_colors.dart';
import '../../../shared/layout/detail_page_scaffold.dart';
import '../../../shared/widgets/primary_action_button.dart';
import '../../../shared/widgets/progress_badge.dart';
import '../../../shared/widgets/section_card.dart';

class MultimodalInputDetailScreen extends StatelessWidget {
  const MultimodalInputDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final AppCopy copy = context.copy;
    final TextTheme textTheme = Theme.of(context).textTheme;

    return DetailPageScaffold(
      title: copy.t(en: 'Socratic Dialogue', zh: '苏格拉底对话'),
      eyebrow: copy.t(en: 'Multimodal Capture', zh: '多模态采集'),
      children: [
        Text(
          copy.t(en: 'Cognitive Input', zh: '认知输入'),
          style: textTheme.displayLarge?.copyWith(fontSize: 34),
        ),
        const SizedBox(height: 18),
        LayoutBuilder(
          builder: (BuildContext context, BoxConstraints constraints) {
            final bool useColumns = constraints.maxWidth >= 840;
            final Widget preview = _CapturePreviewCard(
              textTheme: textTheme,
              copy: copy,
            );
            final Widget details = Column(
              children: [
                SectionCard(
                  title: copy.t(en: 'Extracted Text', zh: '识别文本'),
                  subtitle: copy.t(en: 'OCR refined for learning context.', zh: '针对学习场景优化后的 OCR 结果。'),
                  trailing: ProgressBadge(label: copy.t(en: 'OCR Verified', zh: 'OCR 已校验')),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        copy.t(
                          en: 'A mass m = 5 kg is attached to a spring with k = 120 N/m. Determine the period, maximum velocity, and total mechanical energy of the system.',
                          zh: '质量 m = 5 kg 的物体连接在劲度系数 k = 120 N/m 的弹簧上。求该系统的周期、最大速度以及总机械能。',
                        ),
                        style: textTheme.bodyMedium,
                      ),
                      const SizedBox(height: 16),
                      TextField(
                        minLines: 3,
                        maxLines: 4,
                        decoration: InputDecoration(
                          hintText: copy.t(
                            en: 'Add custom notes or clarify symbols...',
                            zh: '补充你的笔记，或说明你不确定的符号……',
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                SizedBox(
                  width: double.infinity,
                  child: PrimaryActionButton(
                    label: copy.t(en: 'Analyze with AI', zh: '交给 AI 分析'),
                    onPressed: () => context.push('/chat/thinking'),
                  ),
                ),
              ],
            );

            if (!useColumns) {
              return Column(
                children: [
                  preview,
                  const SizedBox(height: 16),
                  details,
                ],
              );
            }

            return Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(flex: 7, child: preview),
                const SizedBox(width: 16),
                Expanded(flex: 5, child: details),
              ],
            );
          },
        ),
      ],
    );
  }
}

class _CapturePreviewCard extends StatelessWidget {
  const _CapturePreviewCard({
    required this.textTheme,
    required this.copy,
  });

  final TextTheme textTheme;
  final AppCopy copy;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: AppColors.surfaceBlue,
        borderRadius: BorderRadius.circular(30),
        border: Border.all(color: AppColors.outlineSoft),
      ),
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AspectRatio(
              aspectRatio: 3 / 4,
              child: Stack(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      color: AppColors.surfaceElevated,
                      borderRadius: BorderRadius.circular(24),
                    ),
                  ),
                  Positioned.fill(
                    child: Align(
                      alignment: Alignment.center,
                      child: Container(
                        width: double.infinity,
                        height: 2,
                        margin: const EdgeInsets.symmetric(horizontal: 18),
                        color: AppColors.tertiary.withValues(alpha: 0.6),
                      ),
                    ),
                  ),
                  Positioned(
                    left: 28,
                    top: 60,
                    child: _HighlightBox(width: 110, height: 34),
                  ),
                  Positioned(
                    left: 44,
                    top: 170,
                    child: _HighlightBox(width: 160, height: 40),
                  ),
                  Positioned(
                    right: 30,
                    bottom: 90,
                    child: _HighlightBox(width: 180, height: 44),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            Text(
              copy.t(
                en: 'Analyzing complex physics formulas. Detecting: Newton\'s Laws.',
                zh: '正在分析复杂物理公式。识别到主题：牛顿定律。',
              ),
              style: textTheme.bodyMedium,
            ),
          ],
        ),
      ),
    );
  }
}

class _HighlightBox extends StatelessWidget {
  const _HighlightBox({
    required this.width,
    required this.height,
  });

  final double width;
  final double height;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: AppColors.tertiaryFixedDim.withValues(alpha: 0.2),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.tertiary),
      ),
    );
  }
}
