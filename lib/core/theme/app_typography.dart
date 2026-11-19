import 'package:flutter/material.dart';

import 'app_colors.dart';

/// Plus Jakarta Sans (display / headings) + Inter (body / UI).
abstract final class AppFonts {
  static const String primary = 'PlusJakartaSans';
  static const String secondary = 'Inter';

  /// latin-ext subsets (₹ and accented characters).
  static const List<String> fallback = ['PlusJakartaSansExt', 'InterExt'];
  static const List<String> secondaryFallback = ['InterExt', 'PlusJakartaSansExt'];
}

abstract final class AppTypography {
  static TextTheme textTheme({Color color = AppColors.textPrimary}) {
    TextStyle jakarta(double size, FontWeight weight, {double? height, double spacing = 0}) => TextStyle(
      fontFamily: AppFonts.primary,
      fontFamilyFallback: AppFonts.fallback,
      fontSize: size,
      fontWeight: weight,
      height: height,
      letterSpacing: spacing,
      color: color,
    );
    TextStyle inter(double size, FontWeight weight, {double? height, double spacing = 0}) => TextStyle(
      fontFamily: AppFonts.secondary,
      fontFamilyFallback: AppFonts.secondaryFallback,
      fontSize: size,
      fontWeight: weight,
      height: height,
      letterSpacing: spacing,
      color: color,
    );

    return TextTheme(
      displayLarge: jakarta(44, FontWeight.w800, height: 1.05, spacing: -1.2),
      displayMedium: jakarta(36, FontWeight.w800, height: 1.08, spacing: -1),
      displaySmall: jakarta(30, FontWeight.w800, height: 1.1, spacing: -.8),
      headlineLarge: jakarta(28, FontWeight.w800, height: 1.15, spacing: -.6),
      headlineMedium: jakarta(24, FontWeight.w700, height: 1.2, spacing: -.4),
      headlineSmall: jakarta(20, FontWeight.w700, height: 1.25, spacing: -.3),
      titleLarge: jakarta(18, FontWeight.w700, height: 1.3, spacing: -.2),
      titleMedium: jakarta(16, FontWeight.w700, height: 1.3),
      titleSmall: jakarta(14, FontWeight.w700, height: 1.3),
      bodyLarge: inter(16, FontWeight.w400, height: 1.5),
      bodyMedium: inter(14, FontWeight.w400, height: 1.45),
      bodySmall: inter(12, FontWeight.w400, height: 1.4),
      labelLarge: inter(15, FontWeight.w600, height: 1.2),
      labelMedium: inter(13, FontWeight.w600, height: 1.2),
      labelSmall: inter(11, FontWeight.w600, height: 1.2, spacing: .4),
    );
  }
}
