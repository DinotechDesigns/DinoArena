import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';

import '../theme/app_colors.dart';
import '../theme/app_theme.dart';
import 'app_button.dart';
import 'pressable.dart';

class SectionHeader extends StatelessWidget {
  const SectionHeader({super.key, required this.title, this.subtitle, this.action, this.onAction});

  final String title;
  final String? subtitle;
  final String? action;
  final VoidCallback? onAction;

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context).textTheme;
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: t.titleLarge),
              if (subtitle != null) ...[
                const SizedBox(height: 2),
                Text(subtitle!, style: t.bodySmall?.copyWith(color: AppColors.textSecondary)),
              ],
            ],
          ),
        ),
        if (action != null)
          Pressable(
            onTap: onAction,
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 4),
              child: Row(
                children: [
                  Text(action!, style: t.labelMedium?.copyWith(color: AppColors.primaryGreen)),
                  const SizedBox(width: 2),
                  const Icon(Icons.chevron_right_rounded, size: 18, color: AppColors.primaryGreen),
                ],
              ),
            ),
          ),
      ],
    );
  }
}

/// Small rounded label.
class Pill extends StatelessWidget {
  const Pill({
    super.key,
    required this.label,
    this.color = AppColors.primaryGreen,
    this.background,
    this.icon,
    this.dense = false,
  });

  final String label;
  final Color color;
  final Color? background;
  final IconData? icon;
  final bool dense;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: dense ? 8 : 10, vertical: dense ? 3 : 5),
      decoration: BoxDecoration(
        color: background ?? color.withValues(alpha: .12),
        borderRadius: BorderRadius.circular(100),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[Icon(icon, size: dense ? 12 : 14, color: color), const SizedBox(width: 4)],
          Text(
            label,
            style: Theme.of(context).textTheme.labelSmall?.copyWith(color: color, fontSize: dense ? 10.5 : 11.5),
          ),
        ],
      ),
    );
  }
}

/// Pulsing "LIVE" dot.
class LiveDot extends StatelessWidget {
  const LiveDot({super.key, this.color = AppColors.accentLime, this.size = 8});

  final Color color;
  final double size;

  @override
  Widget build(BuildContext context) {
    return SizedBox.square(
      dimension: size * 2.2,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Container(
                width: size,
                height: size,
                decoration: BoxDecoration(color: color.withValues(alpha: .5), shape: BoxShape.circle),
              )
              .animate(onPlay: (c) => c.repeat())
              .scale(begin: const Offset(1, 1), end: const Offset(2.2, 2.2), duration: 1200.ms)
              .fadeOut(duration: 1200.ms),
          Container(
            width: size,
            height: size,
            decoration: BoxDecoration(color: color, shape: BoxShape.circle),
          ),
        ],
      ),
    );
  }
}

class CircleIconButton extends StatelessWidget {
  const CircleIconButton({
    super.key,
    required this.icon,
    this.onTap,
    this.background = AppColors.surface,
    this.foreground = AppColors.primaryDark,
    this.size = 44,
    this.badge,
    this.tooltip,
  });

  final IconData icon;
  final VoidCallback? onTap;
  final Color background;
  final Color foreground;
  final double size;
  final int? badge;
  final String? tooltip;

  @override
  Widget build(BuildContext context) {
    final button = Pressable(
      onTap: onTap,
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          color: background,
          shape: BoxShape.circle,
          border: background == AppColors.surface ? Border.all(color: AppColors.border) : null,
        ),
        child: Stack(
          clipBehavior: Clip.none,
          alignment: Alignment.center,
          children: [
            Icon(icon, size: size * .48, color: foreground),
            if ((badge ?? 0) > 0)
              Positioned(
                top: size * .16,
                right: size * .16,
                child: Container(
                  constraints: const BoxConstraints(minWidth: 16, minHeight: 16),
                  padding: const EdgeInsets.symmetric(horizontal: 4),
                  decoration: BoxDecoration(
                    color: AppColors.accentLime,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: background, width: 1.5),
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    '${badge! > 9 ? '9+' : badge}',
                    style: const TextStyle(fontSize: 9.5, fontWeight: FontWeight.w800, color: AppColors.primaryDark),
                  ),
                ).animate().scale(curve: Curves.easeOutBack, duration: 350.ms),
              ),
          ],
        ),
      ),
    );
    return Semantics(
      button: true,
      label: tooltip,
      child: tooltip == null ? button : Tooltip(message: tooltip!, child: button),
    );
  }
}

class AppBackButton extends StatelessWidget {
  const AppBackButton({super.key, this.onDark = false});

  final bool onDark;

  @override
  Widget build(BuildContext context) {
    return CircleIconButton(
      icon: Icons.arrow_back_rounded,
      tooltip: 'Back',
      size: 42,
      background: onDark ? Colors.white.withValues(alpha: .12) : AppColors.surface,
      foreground: onDark ? Colors.white : AppColors.primaryDark,
      onTap: () => context.canPop() ? context.pop() : context.go('/home'),
    );
  }
}

/// Simple top bar used on pushed screens.
class AppTopBar extends StatelessWidget implements PreferredSizeWidget {
  const AppTopBar({super.key, required this.title, this.actions = const [], this.showBack = true});

  final String title;
  final List<Widget> actions;
  final bool showBack;

  @override
  Size get preferredSize => const Size.fromHeight(64);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      bottom: false,
      child: SizedBox(
        height: 64,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
          child: Row(
            children: [
              if (showBack) ...[const AppBackButton(), const SizedBox(width: 12)],
              Expanded(
                child: Text(title, style: Theme.of(context).textTheme.titleLarge, overflow: TextOverflow.ellipsis),
              ),
              ...actions,
            ],
          ),
        ),
      ),
    );
  }
}

class SkeletonBox extends StatelessWidget {
  const SkeletonBox({super.key, this.width, required this.height, this.radius = AppRadius.md});

  final double? width;
  final double height;
  final double radius;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(color: AppColors.surfaceMuted, borderRadius: BorderRadius.circular(radius)),
    ).animate(onPlay: (c) => c.repeat()).shimmer(duration: 1300.ms, color: Colors.white.withValues(alpha: .6));
  }
}

class EmptyState extends StatelessWidget {
  const EmptyState({
    super.key,
    required this.icon,
    required this.title,
    required this.message,
    this.actionLabel,
    this.onAction,
  });

  final IconData icon;
  final String title;
  final String message;
  final String? actionLabel;
  final VoidCallback? onAction;

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context).textTheme;
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.xl),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 84,
              height: 84,
              decoration: const BoxDecoration(color: AppColors.limeSoft, shape: BoxShape.circle),
              child: Icon(icon, size: 38, color: AppColors.primaryGreen),
            ).animate().scale(curve: Curves.easeOutBack, duration: 500.ms),
            const SizedBox(height: 20),
            Text(title, style: t.titleLarge, textAlign: TextAlign.center),
            const SizedBox(height: 6),
            Text(
              message,
              style: t.bodyMedium?.copyWith(color: AppColors.textSecondary),
              textAlign: TextAlign.center,
            ),
            if (actionLabel != null) ...[
              const SizedBox(height: 22),
              AppButton(label: actionLabel!, onPressed: onAction, expand: false, height: 50),
            ],
          ],
        ),
      ),
    );
  }
}

class ErrorView extends StatelessWidget {
  const ErrorView({super.key, required this.message, this.onRetry});

  final String message;
  final VoidCallback? onRetry;

  @override
  Widget build(BuildContext context) => EmptyState(
    icon: Icons.wifi_tethering_error_rounded,
    title: 'Couldn’t load this',
    message: message,
    actionLabel: onRetry == null ? null : 'Try again',
    onAction: onRetry,
  );
}

/// Dashed separator used on tickets / passes.
class DashedLine extends StatelessWidget {
  const DashedLine({super.key, this.color = AppColors.border, this.dash = 6, this.gap = 5});

  final Color color;
  final double dash;
  final double gap;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, c) {
        final count = (c.maxWidth / (dash + gap)).floor();
        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: List.generate(
            count,
            (_) => SizedBox(
              width: dash,
              height: 1.4,
              child: ColoredBox(color: color),
            ),
          ),
        );
      },
    );
  }
}

class InfoRow extends StatelessWidget {
  const InfoRow({super.key, required this.label, required this.value, this.bold = false, this.valueColor});

  final String label;
  final String value;
  final bool bold;
  final Color? valueColor;

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context).textTheme;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          Expanded(
            child: Text(
              label,
              style: (bold ? t.titleSmall : t.bodyMedium)?.copyWith(color: bold ? null : AppColors.textSecondary),
            ),
          ),
          Text(value, style: (bold ? t.titleMedium : t.labelLarge)?.copyWith(color: valueColor)),
        ],
      ),
    );
  }
}

void showAppSnack(BuildContext context, String message, {IconData icon = Icons.info_outline_rounded}) {
  ScaffoldMessenger.of(context)
    ..hideCurrentSnackBar()
    ..showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(icon, color: AppColors.accentLime, size: 20),
            const SizedBox(width: 12),
            Expanded(child: Text(message)),
          ],
        ),
      ),
    );
}
