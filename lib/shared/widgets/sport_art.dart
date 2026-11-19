import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import '../domain/sport_type.dart';

/// Illustrated, top-down venue art for each sport — turf, court or practice lanes.
/// Keeps the app asset-light and visually consistent with the DinoArena mark.
class SportArt extends StatelessWidget {
  const SportArt({super.key, required this.sport, this.borderRadius = BorderRadius.zero, this.child});

  final SportType sport;
  final BorderRadius borderRadius;
  final Widget? child;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: borderRadius,
      child: CustomPaint(painter: _SportArtPainter(sport), child: child ?? const SizedBox.expand()),
    );
  }
}

class _SportArtPainter extends CustomPainter {
  _SportArtPainter(this.sport);

  final SportType sport;

  @override
  void paint(Canvas canvas, Size size) {
    final rect = Offset.zero & size;
    final (top, bottom) = switch (sport) {
      SportType.badminton => (const Color(0xFF1F4F5E), const Color(0xFF102A31)),
      SportType.cricketNets => (const Color(0xFF2C4A22), const Color(0xFF15240F)),
      _ => (const Color(0xFF1F6A47), AppColors.secondaryDark),
    };
    canvas.drawRect(
      rect,
      Paint()
        ..shader = LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [top, bottom],
        ).createShader(rect),
    );

    // Mowing stripes.
    final stripe = Paint()..color = Colors.white.withValues(alpha: .035);
    final w = size.width / 9;
    for (var i = 0; i < 9; i += 2) {
      canvas.drawRect(Rect.fromLTWH(i * w, 0, w, size.height), stripe);
    }

    final line = Paint()
      ..color = Colors.white.withValues(alpha: .26)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.6;

    canvas.save();
    // Slight perspective tilt for depth.
    canvas.translate(size.width / 2, size.height / 2);
    canvas.transform(
      (Matrix4.identity()
            ..setEntry(3, 2, .0012)
            ..rotateX(-.55))
          .storage,
    );
    canvas.translate(-size.width / 2, -size.height / 2);

    final field = Rect.fromCenter(
      center: Offset(size.width / 2, size.height * .58),
      width: size.width * .82,
      height: size.height * .9,
    );
    switch (sport) {
      case SportType.football:
      case SportType.cricket:
        canvas.drawRRect(RRect.fromRectAndRadius(field, const Radius.circular(6)), line);
        canvas.drawLine(field.topCenter, field.bottomCenter, line);
        canvas.drawCircle(field.center, field.height * .16, line);
        final box = field.height * .44;
        canvas.drawRect(
          Rect.fromCenter(
            center: field.centerLeft.translate(field.width * .07, 0),
            width: field.width * .14,
            height: box,
          ),
          line,
        );
        canvas.drawRect(
          Rect.fromCenter(
            center: field.centerRight.translate(-field.width * .07, 0),
            width: field.width * .14,
            height: box,
          ),
          line,
        );
        if (sport == SportType.cricket) {
          final pitch = Paint()..color = const Color(0xFFD9C79A).withValues(alpha: .4);
          canvas.drawRect(
            Rect.fromCenter(center: field.center, width: field.width * .36, height: field.height * .12),
            pitch,
          );
        }
      case SportType.badminton:
        final court = Rect.fromCenter(center: field.center, width: field.width * .9, height: field.height * .8);
        canvas.drawRect(court, line);
        canvas.drawRect(court.deflate(court.shortestSide * .06), line);
        canvas.drawLine(court.topCenter, court.bottomCenter, line..strokeWidth = 2.4);
        line.strokeWidth = 1.6;
        canvas.drawLine(court.centerLeft, court.centerRight, line);
        final svc = court.width * .14;
        canvas.drawLine(court.topCenter.translate(-svc, 0), court.bottomCenter.translate(-svc, 0), line);
        canvas.drawLine(court.topCenter.translate(svc, 0), court.bottomCenter.translate(svc, 0), line);
      case SportType.cricketNets:
        final lanes = 2;
        final laneW = field.width / lanes;
        for (var i = 0; i < lanes; i++) {
          final lane = Rect.fromLTWH(field.left + i * laneW + 8, field.top, laneW - 16, field.height);
          canvas.drawRect(
            Rect.fromCenter(center: lane.center, width: lane.width * .5, height: lane.height * .92),
            Paint()..color = const Color(0xFFC9D98A).withValues(alpha: .22),
          );
          canvas.drawRect(lane, line);
        }
        // Netting mesh.
        final mesh = Paint()
          ..color = Colors.white.withValues(alpha: .07)
          ..strokeWidth = 1;
        for (var x = field.left; x < field.right; x += 10) {
          canvas.drawLine(Offset(x, field.top), Offset(x + 30, field.bottom), mesh);
        }
    }
    canvas.restore();

    // Floodlight glow + vignette.
    canvas.drawCircle(
      Offset(size.width * .85, -size.height * .1),
      size.longestSide * .55,
      Paint()
        ..shader =
            RadialGradient(
              colors: [AppColors.accentLime.withValues(alpha: .22), AppColors.accentLime.withValues(alpha: 0)],
            ).createShader(
              Rect.fromCircle(center: Offset(size.width * .85, -size.height * .1), radius: size.longestSide * .55),
            ),
    );
    canvas.drawRect(
      rect,
      Paint()
        ..shader = LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Colors.transparent, AppColors.primaryDark.withValues(alpha: .75)],
          stops: const [.35, 1],
        ).createShader(rect),
    );

    // Oversized sport glyph watermark.
    final icon = sport.icon;
    final tp = TextPainter(
      text: TextSpan(
        text: String.fromCharCode(icon.codePoint),
        style: TextStyle(
          fontSize: size.height * .62,
          fontFamily: icon.fontFamily,
          package: icon.fontPackage,
          color: Colors.white.withValues(alpha: .07),
        ),
      ),
      textDirection: TextDirection.ltr,
    )..layout();
    canvas.save();
    canvas.translate(size.width - tp.width * .78, size.height * .02);
    canvas.rotate(-math.pi / 14);
    tp.paint(canvas, Offset.zero);
    canvas.restore();
  }

  @override
  bool shouldRepaint(_SportArtPainter old) => old.sport != sport;
}
