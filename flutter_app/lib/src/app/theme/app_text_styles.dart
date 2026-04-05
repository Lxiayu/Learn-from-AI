import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../locale/app_language.dart';
import 'app_colors.dart';

abstract final class AppTextStyles {
  static TextTheme buildTextTheme([
    AppLanguage language = AppLanguage.english,
  ]) {
    final bool isChinese = language.isChinese;
    final TextTheme base =
        Typography.material2021(platform: defaultTargetPlatform).black;

    TextStyle body({
      required double size,
      required FontWeight weight,
      required Color color,
      double height = 1.5,
      double? letterSpacing,
    }) {
      return TextStyle(
        fontSize: size,
        fontWeight: weight,
        height: height,
        letterSpacing: letterSpacing ?? (isChinese ? 0 : -0.1),
        color: color,
      );
    }

    return base.copyWith(
      displayLarge: body(
        size: isChinese ? 44 : 48,
        weight: FontWeight.w700,
        height: isChinese ? 1.16 : 1.08,
        letterSpacing: isChinese ? 0 : -0.8,
        color: AppColors.onSurface,
      ),
      headlineMedium: body(
        size: isChinese ? 26 : 28,
        weight: FontWeight.w700,
        height: isChinese ? 1.24 : 1.14,
        letterSpacing: isChinese ? 0 : -0.5,
        color: AppColors.onSurface,
      ),
      headlineSmall: body(
        size: isChinese ? 21 : 22,
        weight: FontWeight.w600,
        height: isChinese ? 1.28 : 1.18,
        letterSpacing: isChinese ? 0 : -0.35,
        color: AppColors.onSurface,
      ),
      titleLarge: body(
        size: isChinese ? 19 : 20,
        weight: FontWeight.w600,
        height: isChinese ? 1.28 : 1.2,
        letterSpacing: isChinese ? 0 : -0.25,
        color: AppColors.onSurface,
      ),
      titleMedium: body(
        size: isChinese ? 17 : 18,
        weight: FontWeight.w600,
        height: isChinese ? 1.3 : 1.24,
        color: AppColors.onSurface,
      ),
      bodyLarge: body(
        size: 16,
        weight: FontWeight.w400,
        height: isChinese ? 1.65 : 1.5,
        color: AppColors.onSurface,
      ),
      bodyMedium: body(
        size: 14,
        weight: FontWeight.w400,
        height: isChinese ? 1.6 : 1.46,
        color: AppColors.onSurfaceVariant,
      ),
      bodySmall: body(
        size: 12,
        weight: FontWeight.w400,
        height: isChinese ? 1.48 : 1.36,
        color: AppColors.onSurfaceVariant,
      ),
      labelLarge: body(
        size: 13,
        weight: FontWeight.w600,
        height: 1.25,
        letterSpacing: isChinese ? 0 : 0.1,
        color: AppColors.onSurface,
      ),
      labelMedium: body(
        size: 12,
        weight: FontWeight.w600,
        height: 1.2,
        letterSpacing: isChinese ? 0 : 0.12,
        color: AppColors.onSurfaceVariant,
      ),
    );
  }
}
