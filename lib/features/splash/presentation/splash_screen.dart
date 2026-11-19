import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../app/router.dart';
import '../../../core/constants/brand.dart';
import '../../../core/storage/preferences.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/widgets/dinoarena_logo.dart';
import '../../auth/presentation/providers/auth_providers.dart';

class SplashScreen extends ConsumerStatefulWidget {
  const SplashScreen({super.key});

  @override
  ConsumerState<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends ConsumerState<SplashScreen> with SingleTickerProviderStateMixin {
  late final AnimationController _c = AnimationController(vsync: this, duration: const Duration(milliseconds: 1700));

  late final Animation<double> _glyph = CurvedAnimation(
    parent: _c,
    curve: const Interval(0, .45, curve: Curves.easeOutBack),
  );
  late final Animation<double> _track = CurvedAnimation(
    parent: _c,
    curve: const Interval(.3, .8, curve: Curves.easeInOutCubic),
  );
  late final Animation<double> _ball = CurvedAnimation(
    parent: _c,
    curve: const Interval(.5, .95, curve: Curves.linear),
  );

  @override
  void initState() {
    super.initState();
    _c.forward();
    Future.delayed(const Duration(milliseconds: 2900), _continue);
  }

  void _continue() {
    if (!mounted) return;
    final auth = ref.read(authControllerProvider);
    final onboarded = ref.read(appPreferencesProvider).onboardingComplete;
    context.go(auth.isAuthenticated ? Routes.home : (onboarded ? Routes.login : Routes.onboarding));
  }

  @override
  void dispose() {
    _c.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: AppTheme.darkOverlay,
      child: Scaffold(
        backgroundColor: AppColors.primaryDark,
        body: DecoratedBox(
          decoration: const BoxDecoration(gradient: AppColors.heroGradient),
          child: Stack(
            children: [
              // Floodlight beams.
              Positioned.fill(
                child: CustomPaint(painter: _BeamsPainter()).animate().fadeIn(duration: 1200.ms, delay: 300.ms),
              ),
              Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    AnimatedBuilder(
                      animation: _c,
                      builder: (context, _) => Transform.scale(
                        scale: .6 + .4 * _glyph.value,
                        child: Opacity(
                          opacity: _glyph.value.clamp(0, 1),
                          child: DinoArenaMark(
                            size: 132,
                            withBackground: false,
                            trackProgress: _track.value,
                            ballProgress: _ball.value,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 26),
                    const Text.rich(
                      TextSpan(
                        children: [
                          TextSpan(text: Brand.nameFirst),
                          TextSpan(
                            text: Brand.nameSecond,
                            style: TextStyle(color: AppColors.accentLime),
                          ),
                        ],
                      ),
                      style: TextStyle(
                        fontFamily: AppFonts.primary,
                        fontWeight: FontWeight.w800,
                        fontSize: 40,
                        letterSpacing: -1.2,
                        color: Colors.white,
                        height: 1,
                      ),
                    ).animate().fadeIn(delay: 900.ms, duration: 500.ms).slideY(begin: .4, curve: Curves.easeOutCubic),
                    const SizedBox(height: 14),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        for (var i = 0; i < Brand.taglineWords.length; i++) ...[
                          if (i > 0) const SizedBox(width: 10),
                          Text(
                                Brand.taglineWords[i],
                                style: TextStyle(
                                  fontFamily: AppFonts.secondary,
                                  fontWeight: FontWeight.w700,
                                  fontSize: 13,
                                  letterSpacing: 3,
                                  color: i == Brand.taglineWords.length - 1
                                      ? AppColors.accentLime
                                      : Colors.white.withValues(alpha: .72),
                                ),
                              )
                              .animate()
                              .fadeIn(delay: (1250 + i * 180).ms, duration: 400.ms)
                              .slideY(begin: .6, curve: Curves.easeOutCubic),
                        ],
                      ],
                    ),
                  ],
                ),
              ),
              Positioned(
                left: 0,
                right: 0,
                bottom: 48 + MediaQuery.paddingOf(context).bottom,
                child: Center(
                  child: SizedBox(
                    width: 120,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(4),
                      child: const LinearProgressIndicator(
                        minHeight: 3,
                        backgroundColor: Color(0x22FFFFFF),
                        color: AppColors.accentLime,
                      ),
                    ),
                  ),
                ).animate().fadeIn(delay: 1600.ms),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _BeamsPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    for (final (origin, dir) in [
      (Offset(-size.width * .1, -20), Offset(size.width * .55, size.height * .55)),
      (Offset(size.width * 1.1, -20), Offset(size.width * .45, size.height * .55)),
    ]) {
      final path = Path()
        ..moveTo(origin.dx, origin.dy)
        ..lineTo(dir.dx - 90, dir.dy)
        ..lineTo(dir.dx + 90, dir.dy)
        ..close();
      canvas.drawPath(
        path,
        Paint()
          ..shader = LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [AppColors.accentLime.withValues(alpha: .10), AppColors.accentLime.withValues(alpha: 0)],
          ).createShader(Rect.fromPoints(origin, dir)),
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
