import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../../../../core/constants/brand.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/widgets/common.dart';
import '../../../../core/widgets/dinoarena_logo.dart';

/// Shared layout for login / OTP / profile setup: a dark brand header with the
/// DinoArena mark and a light sheet holding the form.
class AuthScaffold extends StatelessWidget {
  const AuthScaffold({
    super.key,
    required this.title,
    required this.subtitle,
    required this.child,
    this.showBack = false,
  });

  final String title;
  final String subtitle;
  final Widget child;
  final bool showBack;

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context).textTheme;
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: AppTheme.darkOverlay,
      child: Scaffold(
        backgroundColor: AppColors.primaryDark,
        resizeToAvoidBottomInset: true,
        body: DecoratedBox(
          decoration: const BoxDecoration(gradient: AppColors.heroGradient),
          child: SafeArea(
            bottom: false,
            child: CustomScrollView(
              slivers: [
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(AppSpacing.gutter, 12, AppSpacing.gutter, 28),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            if (showBack) ...[const AppBackButton(onDark: true), const SizedBox(width: 14)],
                            const DinoArenaWordmark(size: 34, onDark: true),
                          ],
                        ),
                        const SizedBox(height: 36),
                        Text(
                          title,
                          style: t.headlineLarge?.copyWith(color: Colors.white),
                        ).animate().fadeIn(duration: 400.ms).slideY(begin: .2, curve: Curves.easeOutCubic),
                        const SizedBox(height: 8),
                        Text(
                          subtitle,
                          style: t.bodyMedium?.copyWith(color: Colors.white70),
                        ).animate().fadeIn(delay: 100.ms, duration: 400.ms),
                      ],
                    ),
                  ),
                ),
                SliverFillRemaining(
                  hasScrollBody: false,
                  child: Container(
                    padding: EdgeInsets.fromLTRB(
                      AppSpacing.gutter,
                      28,
                      AppSpacing.gutter,
                      24 + MediaQuery.paddingOf(context).bottom,
                    ),
                    decoration: const BoxDecoration(
                      color: AppColors.background,
                      borderRadius: BorderRadius.vertical(top: Radius.circular(AppRadius.xl + 4)),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        child,
                        const Spacer(),
                        const SizedBox(height: 24),
                        Center(
                          child: Text(
                            Brand.tagline,
                            style: t.labelSmall?.copyWith(color: AppColors.textMuted, letterSpacing: 3),
                          ),
                        ),
                      ],
                    ),
                  ).animate().slideY(begin: .08, duration: 500.ms, curve: Curves.easeOutCubic).fadeIn(),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
