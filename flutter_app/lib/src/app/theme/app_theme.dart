import 'package:flutter/material.dart';

import 'app_colors.dart';
import 'app_text_styles.dart';

ThemeData buildAppTheme() {
  const ColorScheme colorScheme = ColorScheme(
    brightness: Brightness.light,
    primary: AppColors.primary,
    onPrimary: AppColors.onPrimary,
    secondary: Color(0xFF565C84),
    onSecondary: Color(0xFFFFFFFF),
    error: Color(0xFFBA1A1A),
    onError: Color(0xFFFFFFFF),
    surface: AppColors.surface,
    onSurface: AppColors.onSurface,
  );

  final TextTheme textTheme = AppTextStyles.buildTextTheme();

  return ThemeData(
    useMaterial3: true,
    colorScheme: colorScheme,
    scaffoldBackgroundColor: AppColors.surface,
    canvasColor: AppColors.surface,
    textTheme: textTheme,
    appBarTheme: textTheme.titleMedium == null
        ? null
        : AppBarTheme(
            backgroundColor: AppColors.surface,
            foregroundColor: AppColors.onSurface,
            centerTitle: false,
            elevation: 0,
            titleTextStyle: textTheme.titleMedium!.copyWith(
              fontSize: 20,
              fontWeight: FontWeight.w600,
            ),
          ),
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      backgroundColor: AppColors.surface,
      selectedItemColor: AppColors.primary,
      unselectedItemColor: AppColors.onSurfaceVariant,
      selectedLabelStyle: TextStyle(
        fontFamily: 'Inter',
        fontSize: 12,
        fontWeight: FontWeight.w600,
      ),
      unselectedLabelStyle: TextStyle(
        fontFamily: 'Inter',
        fontSize: 12,
        fontWeight: FontWeight.w500,
      ),
      type: BottomNavigationBarType.fixed,
      showUnselectedLabels: true,
    ),
    cardTheme: const CardThemeData(
      color: AppColors.surfaceContainerHighest,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(24)),
      ),
      margin: EdgeInsets.zero,
    ),
    dividerColor: Colors.transparent,
    splashColor: AppColors.primary.withValues(alpha: 0.06),
    highlightColor: AppColors.primary.withValues(alpha: 0.04),
  );
}
