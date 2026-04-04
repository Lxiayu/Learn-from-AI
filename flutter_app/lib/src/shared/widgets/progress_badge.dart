import 'package:flutter/material.dart';

import '../../app/theme/app_colors.dart';

class ProgressBadge extends StatelessWidget {
  const ProgressBadge({
    super.key,
    required this.label,
  });

  final String label;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: AppColors.tertiaryFixedDim.withValues(alpha: 0.22),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        child: Text(
          label,
          style: Theme.of(context).textTheme.labelMedium?.copyWith(
                color: AppColors.tertiary,
              ),
        ),
      ),
    );
  }
}
