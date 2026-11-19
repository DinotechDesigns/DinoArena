import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import '../theme/app_theme.dart';
import '../theme/app_typography.dart';
import 'pressable.dart';

enum AppButtonVariant { dark, lime, green, outline, ghostOnDark }

class AppButton extends StatelessWidget {
  const AppButton({
    super.key,
    required this.label,
    this.onPressed,
    this.icon,
    this.trailingIcon,
    this.loading = false,
    this.variant = AppButtonVariant.dark,
    this.height = 56,
    this.expand = true,
  });

  final String label;
  final VoidCallback? onPressed;
  final IconData? icon;
  final IconData? trailingIcon;
  final bool loading;
  final AppButtonVariant variant;
  final double height;
  final bool expand;

  @override
  Widget build(BuildContext context) {
    final enabled = onPressed != null && !loading;
    final (bg, fg, border) = switch (variant) {
      AppButtonVariant.dark => (AppColors.primaryDark, Colors.white, null),
      AppButtonVariant.lime => (AppColors.accentLime, AppColors.primaryDark, null),
      AppButtonVariant.green => (AppColors.primaryGreen, Colors.white, null),
      AppButtonVariant.outline => (Colors.transparent, AppColors.primaryDark, AppColors.border),
      AppButtonVariant.ghostOnDark => (Colors.white.withValues(alpha: .08), Colors.white, Colors.white24),
    };

    final content = Row(
      mainAxisSize: expand ? MainAxisSize.max : MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        if (loading)
          SizedBox.square(dimension: 22, child: CircularProgressIndicator(strokeWidth: 2.4, color: fg))
        else ...[
          if (icon != null) ...[Icon(icon, size: 20, color: fg), const SizedBox(width: 10)],
          Flexible(
            child: Text(
              label,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontFamily: AppFonts.primary,
                fontFamilyFallback: AppFonts.fallback,
                fontWeight: FontWeight.w700,
                fontSize: 15.5,
                color: fg,
                letterSpacing: -.1,
              ),
            ),
          ),
          if (trailingIcon != null) ...[const SizedBox(width: 10), Icon(trailingIcon, size: 20, color: fg)],
        ],
      ],
    );

    return Semantics(
      button: true,
      enabled: enabled,
      label: label,
      child: Pressable(
        onTap: enabled ? onPressed : null,
        child: AnimatedOpacity(
          duration: const Duration(milliseconds: 200),
          opacity: enabled || loading ? 1 : .45,
          child: Container(
            height: height,
            padding: const EdgeInsets.symmetric(horizontal: 22),
            decoration: BoxDecoration(
              color: bg,
              borderRadius: BorderRadius.circular(AppRadius.md),
              border: border == null ? null : Border.all(color: border, width: 1.5),
              boxShadow: variant == AppButtonVariant.lime && enabled
                  ? [
                      BoxShadow(
                        color: AppColors.accentLime.withValues(alpha: .35),
                        blurRadius: 18,
                        offset: const Offset(0, 6),
                      ),
                    ]
                  : null,
            ),
            child: content,
          ),
        ),
      ),
    );
  }
}
