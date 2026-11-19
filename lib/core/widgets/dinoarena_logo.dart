import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../constants/brand.dart';
import '../theme/app_colors.dart';
import '../theme/app_typography.dart';

enum LogoTone { onDark, onLight, mono }

/// The DinoArena mark: an italic geometric "D" whose counter holds a ball,
/// cut by a speed slash and wrapped by an arena track arc.
///
/// Drawn in a 100×100 unit space so it scales crisply from favicon to signage.
/// This painter is the single source of truth for the logo: the launcher icons
/// are rendered from it by `tool/generate_brand_assets_test.dart`.
class DinoArenaMarkPainter extends CustomPainter {
  DinoArenaMarkPainter({
    this.tone = LogoTone.onDark,
    this.withBackground = false,
    this.backgroundRadius = 24,
    this.glyphScale = 1,
    this.trackProgress = 1,
    this.ballProgress = 1,
    this.monoColor = Colors.white,
  });

  final LogoTone tone;
  final bool withBackground;
  final double backgroundRadius;
  final double glyphScale;
  final double trackProgress;
  final double ballProgress;
  final Color monoColor;

  static Path glyphPath() {
    final outer = Path()
      ..moveTo(30, 22)
      ..lineTo(50, 22)
      ..arcToPoint(const Offset(50, 78), radius: const Radius.circular(28))
      ..lineTo(30, 78)
      ..arcToPoint(const Offset(22, 70), radius: const Radius.circular(8))
      ..lineTo(22, 30)
      ..arcToPoint(const Offset(30, 22), radius: const Radius.circular(8))
      ..close();
    final counter = Path()
      ..moveTo(36.5, 36)
      ..lineTo(50, 36)
      ..arcToPoint(const Offset(50, 64), radius: const Radius.circular(14))
      ..lineTo(36.5, 64)
      ..close();
    // Speed slash rising through the stem.
    final slash = Path()
      ..moveTo(12, 66.5)
      ..lineTo(38, 54)
      ..lineTo(38, 58.6)
      ..lineTo(12, 71.1)
      ..close();
    final d = Path.combine(PathOperation.difference, outer, counter);
    return Path.combine(PathOperation.difference, d, slash);
  }

  @override
  void paint(Canvas canvas, Size size) {
    final s = size.shortestSide / 100;
    canvas.save();
    canvas.translate((size.width - 100 * s) / 2, (size.height - 100 * s) / 2);
    canvas.scale(s);

    if (withBackground) {
      final rect = const Rect.fromLTWH(0, 0, 100, 100);
      final bg = Paint()
        ..shader =
            (tone == LogoTone.onLight
                    ? const LinearGradient(colors: [AppColors.surface, AppColors.background])
                    : AppColors.darkGradient)
                .createShader(rect);
      canvas.drawRRect(RRect.fromRectAndRadius(rect, Radius.circular(backgroundRadius)), bg);
      if (tone != LogoTone.onLight) {
        // Soft floodlight glow behind the mark.
        canvas.drawCircle(
          const Offset(62, 38),
          46,
          Paint()
            ..shader = RadialGradient(
              colors: [AppColors.primaryGreen.withValues(alpha: .28), AppColors.primaryGreen.withValues(alpha: 0)],
            ).createShader(Rect.fromCircle(center: const Offset(62, 38), radius: 46)),
        );
      }
    }

    // Glyph space: centre, scale, italicise.
    canvas.translate(50, 50);
    canvas.scale(glyphScale);
    canvas.save();
    canvas.skew(-0.16, 0);
    canvas.translate(-53, -50);

    final glyphRect = const Rect.fromLTWH(22, 22, 56, 56);
    final glyphPaint = Paint()..isAntiAlias = true;
    switch (tone) {
      case LogoTone.onDark:
        glyphPaint.shader = const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Colors.white, Color(0xFFDCEBE1)],
        ).createShader(glyphRect);
      case LogoTone.onLight:
        glyphPaint.shader = const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [AppColors.secondaryDark, AppColors.primaryDark],
        ).createShader(glyphRect);
      case LogoTone.mono:
        glyphPaint.color = monoColor;
    }
    canvas.drawPath(glyphPath(), glyphPaint);

    // Arena track arc hugging the bowl of the D.
    if (trackProgress > 0) {
      const start = -58 * math.pi / 180;
      const fullSweep = 116 * math.pi / 180;
      final arcRect = Rect.fromCircle(center: const Offset(50, 50), radius: 36.5);
      final trackPaint = Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 5
        ..strokeCap = StrokeCap.round;
      if (tone == LogoTone.mono) {
        trackPaint.color = monoColor;
      } else {
        trackPaint.shader = SweepGradient(
          endAngle: fullSweep + .6,
          transform: const GradientRotation(start - .3),
          stops: const [.12, .88],
          colors: tone == LogoTone.onDark
              ? const [AppColors.primaryGreen, AppColors.accentLime]
              : const [AppColors.primaryGreen, Color(0xFF5CC46E)],
        ).createShader(arcRect);
      }
      canvas.drawArc(arcRect, start, fullSweep * trackProgress.clamp(0, 1), false, trackPaint);
    }

    canvas.restore();

    // The ball, sitting in the counter of the D (drawn unskewed so it stays round).
    canvas.translate(-53, -50);
    if (ballProgress > 0) {
      const c = Offset(49.5, 50);
      final r = 8.6 * Curves.easeOutBack.transform(ballProgress.clamp(0, 1));
      final ballColor = switch (tone) {
        LogoTone.onDark => AppColors.accentLime,
        LogoTone.onLight => AppColors.primaryGreen,
        LogoTone.mono => monoColor,
      };
      canvas.drawCircle(c, r, Paint()..color = ballColor);
      if (tone != LogoTone.mono && r > 4) {
        final seam = Paint()
          ..style = PaintingStyle.stroke
          ..strokeWidth = 1.6
          ..strokeCap = StrokeCap.round
          ..color = (tone == LogoTone.onDark ? AppColors.secondaryDark : AppColors.accentLime).withValues(alpha: .85);
        final k = r / 8.6;
        canvas.drawPath(
          Path()
            ..moveTo(c.dx - 3.2 * k, c.dy - 7.6 * k)
            ..quadraticBezierTo(c.dx + 3.4 * k, c.dy, c.dx - 3.2 * k, c.dy + 7.6 * k),
          seam,
        );
      }
    }
    canvas.restore();
  }

  @override
  bool shouldRepaint(DinoArenaMarkPainter old) =>
      old.tone != tone ||
      old.withBackground != withBackground ||
      old.glyphScale != glyphScale ||
      old.trackProgress != trackProgress ||
      old.ballProgress != ballProgress ||
      old.monoColor != monoColor;
}

/// The square DinoArena mark.
class DinoArenaMark extends StatelessWidget {
  const DinoArenaMark({
    super.key,
    this.size = 48,
    this.tone = LogoTone.onDark,
    this.withBackground = true,
    this.trackProgress = 1,
    this.ballProgress = 1,
  });

  final double size;
  final LogoTone tone;
  final bool withBackground;
  final double trackProgress;
  final double ballProgress;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: '${Brand.name} logo',
      image: true,
      child: SizedBox.square(
        dimension: size,
        child: CustomPaint(
          painter: DinoArenaMarkPainter(
            tone: tone,
            withBackground: withBackground,
            trackProgress: trackProgress,
            ballProgress: ballProgress,
          ),
        ),
      ),
    );
  }
}

/// Horizontal lockup: mark + "DinoArena" wordmark (+ optional tagline).
class DinoArenaWordmark extends StatelessWidget {
  const DinoArenaWordmark({super.key, this.size = 36, this.onDark = false, this.showTagline = false});

  final double size;
  final bool onDark;
  final bool showTagline;

  @override
  Widget build(BuildContext context) {
    final fg = onDark ? Colors.white : AppColors.primaryDark;
    final accent = onDark ? AppColors.accentLime : AppColors.primaryGreen;
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        DinoArenaMark(size: size, tone: onDark ? LogoTone.onDark : LogoTone.onDark, withBackground: true),
        SizedBox(width: size * .3),
        Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text.rich(
              TextSpan(
                children: [
                  TextSpan(
                    text: Brand.nameFirst,
                    style: TextStyle(color: fg),
                  ),
                  TextSpan(
                    text: Brand.nameSecond,
                    style: TextStyle(color: accent),
                  ),
                ],
              ),
              style: TextStyle(
                fontFamily: AppFonts.primary,
                fontWeight: FontWeight.w800,
                fontSize: size * .56,
                height: 1,
                letterSpacing: -size * .015,
              ),
            ),
            if (showTagline) ...[
              SizedBox(height: size * .1),
              Text(
                Brand.tagline,
                style: TextStyle(
                  fontFamily: AppFonts.secondary,
                  fontWeight: FontWeight.w700,
                  fontSize: size * .2,
                  letterSpacing: size * .045,
                  color: fg.withValues(alpha: .6),
                ),
              ),
            ],
          ],
        ),
      ],
    );
  }
}
