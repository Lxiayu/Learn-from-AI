import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../app/locale/app_copy.dart';
import '../../../app/theme/app_colors.dart';

class KnowledgeGraphScreen extends StatelessWidget {
  const KnowledgeGraphScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final AppCopy copy = context.copy;
    final TextTheme textTheme = Theme.of(context).textTheme;

    return Scaffold(
      backgroundColor: AppColors.surfaceContainerLow,
      body: SafeArea(
        child: Stack(
          children: [
            Positioned.fill(
              child: CustomPaint(
                painter: _GraphPainter(),
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
                        icon: const Icon(Icons.menu_rounded),
                      ),
                      Text(copy.t(en: 'Knowledge Graph View', zh: '知识图谱'), style: textTheme.titleLarge),
                      const Spacer(),
                      const CircleAvatar(
                        backgroundColor: AppColors.surfaceBlue,
                        child: Icon(Icons.person_outline, color: AppColors.primary),
                      ),
                    ],
                  ),
                  const Spacer(),
                  Center(
                    child: Wrap(
                      alignment: WrapAlignment.center,
                      spacing: 40,
                      runSpacing: 40,
                      children: [
                        _GraphNode(label: copy.t(en: 'Socratic Logic', zh: '苏格拉底逻辑'), tone: AppColors.tertiary, filled: true),
                        _GraphNode(label: copy.t(en: 'Quantum Physics', zh: '量子物理'), tone: AppColors.primary, center: true),
                        _GraphNode(label: copy.t(en: 'Probability', zh: '概率'), tone: AppColors.surfaceBlueStrong),
                        _GraphNode(label: copy.t(en: 'Calculus', zh: '微积分'), tone: AppColors.primaryContainer),
                        _GraphNode(label: copy.t(en: 'Classical Mechanics', zh: '经典力学'), tone: AppColors.surfaceContainerHighest),
                      ],
                    ),
                  ),
                  const Spacer(),
                  DecoratedBox(
                    decoration: BoxDecoration(
                      color: AppColors.surfaceElevated.withValues(alpha: 0.92),
                      borderRadius: BorderRadius.circular(28),
                      border: Border.all(color: AppColors.outlineSoft),
                      boxShadow: const [
                        BoxShadow(
                          color: AppColors.shadow,
                          blurRadius: 20,
                          offset: Offset(0, 12),
                        ),
                      ],
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(22),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(copy.t(en: 'Currently Selected', zh: '当前选中'), style: textTheme.labelMedium),
                          const SizedBox(height: 8),
                          Text(copy.t(en: 'Quantum Physics', zh: '量子物理'), style: textTheme.headlineSmall),
                          const SizedBox(height: 8),
                          Text(
                            copy.t(en: '65% mastered', zh: '已掌握 65%'),
                            style: textTheme.labelLarge?.copyWith(
                              color: AppColors.primary,
                            ),
                          ),
                          const SizedBox(height: 12),
                          ClipRRect(
                            borderRadius: BorderRadius.circular(999),
                            child: const LinearProgressIndicator(
                              value: 0.65,
                              minHeight: 8,
                              backgroundColor: AppColors.surfaceContainerHigh,
                              color: AppColors.tertiary,
                            ),
                          ),
                          const SizedBox(height: 14),
                          FilledButton(
                            onPressed: () => context.go('/chat'),
                            child: Text(copy.t(en: 'Continue Learning', zh: '继续学习')),
                          ),
                        ],
                      ),
                    ),
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

class _GraphNode extends StatelessWidget {
  const _GraphNode({
    required this.label,
    required this.tone,
    this.filled = false,
    this.center = false,
  });

  final String label;
  final Color tone;
  final bool filled;
  final bool center;

  @override
  Widget build(BuildContext context) {
    final double size = center ? 110 : 76;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: size,
          height: size,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: tone,
            boxShadow: center
                ? const [
                    BoxShadow(
                      color: AppColors.shadow,
                      blurRadius: 20,
                      offset: Offset(0, 12),
                    ),
                  ]
                : null,
          ),
          child: filled
              ? const Icon(Icons.check_rounded, color: Colors.white)
              : null,
        ),
        const SizedBox(height: 10),
        Text(label),
      ],
    );
  }
}

class _GraphPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()
      ..color = AppColors.outlineSoft
      ..strokeWidth = 1;

    final Offset center = Offset(size.width / 2, size.height / 2 - 30);
    final List<Offset> points = <Offset>[
      center,
      center + const Offset(-130, -80),
      center + const Offset(135, -50),
      center + const Offset(-110, 120),
      center + const Offset(110, 130),
    ];

    for (final Offset point in points.skip(1)) {
      canvas.drawLine(center, point, paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
