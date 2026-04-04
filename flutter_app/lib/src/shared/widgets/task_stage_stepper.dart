import 'package:flutter/material.dart';

import '../../app/theme/app_colors.dart';

class TaskStageStep {
  const TaskStageStep({
    required this.label,
    required this.isActive,
    required this.isComplete,
  });

  final String label;
  final bool isActive;
  final bool isComplete;
}

class TaskStageStepper extends StatelessWidget {
  const TaskStageStepper({
    super.key,
    required this.steps,
  });

  final List<TaskStageStep> steps;

  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;

    return Wrap(
      spacing: 10,
      runSpacing: 10,
      children: steps.map((TaskStageStep step) {
        final Color backgroundColor = step.isActive
            ? AppColors.primary
            : step.isComplete
                ? AppColors.surfaceMint
                : AppColors.surfaceElevated;

        final Color foregroundColor = step.isActive
            ? AppColors.onPrimary
            : AppColors.onSurface;

        return DecoratedBox(
          decoration: BoxDecoration(
            color: backgroundColor,
            borderRadius: BorderRadius.circular(999),
            border: Border.all(
              color: step.isActive ? AppColors.primary : AppColors.outlineSoft,
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Icon(
                  step.isComplete
                      ? Icons.check_rounded
                      : step.isActive
                          ? Icons.radio_button_checked_rounded
                          : Icons.radio_button_unchecked_rounded,
                  size: 16,
                  color: foregroundColor,
                ),
                const SizedBox(width: 8),
                Text(
                  step.label,
                  style: textTheme.labelLarge?.copyWith(color: foregroundColor),
                ),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }
}
