import 'package:flutter/material.dart';

/// DinoArena colour system.
abstract final class AppColors {
  // Brand palette
  static const Color primaryDark = Color(0xFF101B18);
  static const Color secondaryDark = Color(0xFF18372A);
  static const Color primaryGreen = Color(0xFF268B60);
  static const Color accentLime = Color(0xFFA6F36B);
  static const Color background = Color(0xFFF4F7F2);
  static const Color surface = Color(0xFFFFFFFF);

  // Supporting neutrals derived from the brand darks
  static const Color textPrimary = primaryDark;
  static const Color textSecondary = Color(0xFF55655E);
  static const Color textMuted = Color(0xFF8A9891);
  static const Color border = Color(0xFFE2E9E3);
  static const Color surfaceMuted = Color(0xFFEAF0E9);
  static const Color limeSoft = Color(0xFFE9FBD9);
  static const Color greenSoft = Color(0xFFDDF1E7);

  // Semantic
  static const Color success = primaryGreen;
  static const Color warning = Color(0xFFE5A23B);
  static const Color warningSoft = Color(0xFFFCF1DE);
  static const Color error = Color(0xFFD64545);
  static const Color errorSoft = Color(0xFFFBE4E4);
  static const Color info = Color(0xFF3A7BD5);

  static const LinearGradient darkGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [secondaryDark, primaryDark],
  );

  static const LinearGradient heroGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFF1D4433), secondaryDark, primaryDark],
    stops: [0, .45, 1],
  );

  static const LinearGradient limeGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [accentLime, Color(0xFF6FD46B)],
  );

  static const LinearGradient greenGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFF2FA572), primaryGreen],
  );
}
