import 'package:flutter/material.dart';

import '../../../app/locale/app_copy.dart';
import '../../../app/theme/app_colors.dart';
import '../../../shared/layout/detail_page_scaffold.dart';

class LearningInsightsReportScreen extends StatelessWidget {
  const LearningInsightsReportScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final AppCopy copy = context.copy;
    final TextTheme textTheme = Theme.of(context).textTheme;

    return DetailPageScaffold(
      title: copy.t(en: 'The Curator', zh: '学习策展人'),
      children: [
        Text(
          copy.t(en: 'Weekly Cognitive Report', zh: '每周认知报告'),
          style: textTheme.displayLarge?.copyWith(fontSize: 38),
        ),
        const SizedBox(height: 10),
        Wrap(
          spacing: 10,
          runSpacing: 10,
          children: [
            _InfoPill(
              label: copy.t(
                en: 'Oct 23 - Oct 29, 2023',
                zh: '2023 年 10 月 23 日 - 10 月 29 日',
              ),
            ),
            _InfoPill(label: copy.t(en: 'Velocity +12%', zh: '掌握速度 +12%')),
          ],
        ),
        const SizedBox(height: 24),
        DecoratedBox(
          decoration: BoxDecoration(
            color: AppColors.surfaceContainerLow,
            borderRadius: BorderRadius.circular(30),
          ),
          child: Padding(
            padding: const EdgeInsets.all(22),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(copy.t(en: 'Mastery Velocity', zh: '掌握速度'), style: textTheme.titleLarge),
                const SizedBox(height: 10),
                Text(
                  copy.t(en: '30-day knowledge retention and growth', zh: '近 30 天的知识保持度与增长'),
                  style: textTheme.bodySmall,
                ),
                const SizedBox(height: 18),
                const _ChartPlaceholder(),
              ],
            ),
          ),
        ),
        const SizedBox(height: 18),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: _InsightBox(
                title: copy.t(en: 'Cognitive Patterns', zh: '认知模式'),
                child: Text(
                  copy.t(
                    en: 'Your reasoning patterns are 15% more consistent this week compared to baseline.',
                    zh: '和基线相比，你本周的推理模式稳定性提升了 15%。',
                  ),
                ),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: _InsightBox(
                title: copy.t(en: 'AI Coach Perspective', zh: 'AI 导师视角'),
                child: Text(
                  copy.t(
                    en: 'You excel at abstract conceptualization and thematic mapping. Concrete examples in thermodynamics would improve retention velocity.',
                    zh: '你在抽象概念化和主题映射上表现很好。如果在热力学部分补充更多具体例子，保持速度会更高。',
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _InfoPill extends StatelessWidget {
  const _InfoPill({
    required this.label,
  });

  final String label;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(999),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        child: Text(label),
      ),
    );
  }
}

class _ChartPlaceholder extends StatelessWidget {
  const _ChartPlaceholder();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 220,
      child: CustomPaint(
        painter: _TrendPainter(),
        child: const SizedBox.expand(),
      ),
    );
  }
}

class _TrendPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final Paint grid = Paint()
      ..color = AppColors.outlineSoft
      ..strokeWidth = 1;
    final Paint blue = Paint()
      ..color = AppColors.primary
      ..strokeWidth = 4
      ..style = PaintingStyle.stroke;
    final Paint green = Paint()
      ..color = AppColors.tertiary
      ..strokeWidth = 4
      ..style = PaintingStyle.stroke;

    for (int i = 1; i <= 4; i++) {
      final double y = size.height * i / 5;
      canvas.drawLine(Offset(0, y), Offset(size.width, y), grid);
    }

    final Path bluePath = Path()
      ..moveTo(0, size.height - 28)
      ..quadraticBezierTo(
        size.width * 0.2,
        size.height - 100,
        size.width * 0.38,
        size.height - 82,
      )
      ..quadraticBezierTo(
        size.width * 0.62,
        size.height - 40,
        size.width,
        20,
      );

    final Path greenPath = Path()
      ..moveTo(0, size.height - 16)
      ..quadraticBezierTo(
        size.width * 0.24,
        size.height - 8,
        size.width * 0.52,
        size.height - 44,
      )
      ..quadraticBezierTo(
        size.width * 0.74,
        size.height - 22,
        size.width,
        size.height - 70,
      );

    canvas.drawPath(bluePath, blue);
    canvas.drawPath(greenPath, green);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _InsightBox extends StatelessWidget {
  const _InsightBox({
    required this.title,
    required this.child,
  });

  final String title;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: AppColors.surfaceElevated,
        borderRadius: BorderRadius.circular(28),
        border: Border.all(color: AppColors.outlineSoft),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 12),
            child,
          ],
        ),
      ),
    );
  }
}
