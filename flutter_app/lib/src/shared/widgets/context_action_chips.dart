import 'package:flutter/material.dart';

import '../../app/theme/app_colors.dart';

class ContextActionChipItem {
  const ContextActionChipItem({
    required this.label,
    required this.icon,
    required this.onTap,
  });

  final String label;
  final IconData icon;
  final VoidCallback onTap;
}

class ContextActionChips extends StatelessWidget {
  const ContextActionChips({
    super.key,
    required this.items,
  });

  final List<ContextActionChipItem> items;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 12,
      runSpacing: 12,
      children: items.map((ContextActionChipItem item) {
        return Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: item.onTap,
            borderRadius: BorderRadius.circular(999),
            child: DecoratedBox(
              decoration: BoxDecoration(
                color: AppColors.surfaceElevated,
                borderRadius: BorderRadius.circular(999),
                border: Border.all(color: AppColors.outlineSoft),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Icon(item.icon, size: 18, color: AppColors.primary),
                    const SizedBox(width: 8),
                    Text(item.label),
                  ],
                ),
              ),
            ),
          ),
        );
      }).toList(),
    );
  }
}
