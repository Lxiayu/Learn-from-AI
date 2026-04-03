import 'package:flutter/material.dart';

import 'app_colors.dart';

abstract final class AppTextStyles {
  static TextTheme buildTextTheme() {
    const TextStyle bodyBase = TextStyle(
      fontFamily: 'Inter',
      color: AppColors.onSurface,
      letterSpacing: -0.2,
    );

    return const TextTheme(
      displayLarge: TextStyle(
        fontFamily: 'Manrope',
        fontSize: 56,
        fontWeight: FontWeight.w700,
        height: 1.05,
        color: AppColors.onSurface,
      ),
      headlineMedium: TextStyle(
        fontFamily: 'Manrope',
        fontSize: 28,
        fontWeight: FontWeight.w600,
        height: 1.15,
        color: AppColors.onSurface,
      ),
      titleMedium: TextStyle(
        fontFamily: 'Inter',
        fontSize: 18,
        fontWeight: FontWeight.w500,
        height: 1.25,
        color: AppColors.onSurface,
      ),
      bodyLarge: TextStyle(
        fontFamily: 'Inter',
        fontSize: 16,
        fontWeight: FontWeight.w400,
        height: 1.5,
        color: AppColors.onSurface,
      ),
      bodyMedium: TextStyle(
        fontFamily: 'Inter',
        fontSize: 14,
        fontWeight: FontWeight.w400,
        height: 1.45,
        color: AppColors.onSurfaceVariant,
      ),
      labelMedium: TextStyle(
        fontFamily: 'Inter',
        fontSize: 12,
        fontWeight: FontWeight.w600,
        height: 1.2,
        color: AppColors.onSurfaceVariant,
      ),
    ).apply(
      bodyColor: AppColors.onSurface,
      displayColor: AppColors.onSurface,
    ).merge(TextTheme(
      bodySmall: bodyBase.copyWith(
        fontSize: 12,
        fontWeight: FontWeight.w400,
        height: 1.35,
        color: AppColors.onSurfaceVariant,
      ),
    ));
  }
}
