import 'package:flutter/material.dart';

import '../../app/theme/app_colors.dart';

enum StatusMessageTone {
  info,
  success,
  warning,
}

class StatusMessageCard extends StatelessWidget {
  const StatusMessageCard({
    super.key,
    required this.title,
    required this.body,
    this.tone = StatusMessageTone.info,
  });

  final String title;
  final String body;
  final StatusMessageTone tone;

  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;

    return DecoratedBox(
      decoration: BoxDecoration(
        color: _backgroundColor,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: AppColors.outlineSoft),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(_icon, color: AppColors.primary),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: textTheme.titleMedium),
                  const SizedBox(height: 4),
                  Text(body, style: textTheme.bodyMedium),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Color get _backgroundColor {
    switch (tone) {
      case StatusMessageTone.info:
        return AppColors.surfaceBlue;
      case StatusMessageTone.success:
        return AppColors.surfaceMint;
      case StatusMessageTone.warning:
        return AppColors.surfaceWarm;
    }
  }

  IconData get _icon {
    switch (tone) {
      case StatusMessageTone.info:
        return Icons.info_outline_rounded;
      case StatusMessageTone.success:
        return Icons.check_circle_outline_rounded;
      case StatusMessageTone.warning:
        return Icons.priority_high_rounded;
    }
  }
}
