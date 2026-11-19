// Renders the DinoArena brand assets from the in-app logo painter.
//
//   flutter test tool/generate_brand_assets_test.dart
//   dart run flutter_launcher_icons
//
// Outputs into assets/brand/.
import 'dart:io';
import 'dart:ui' as ui;

import 'package:dinoarena/core/widgets/dinoarena_logo.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

Future<void> _render(String path, int px, void Function(Canvas c, Size s) draw) async {
  final recorder = ui.PictureRecorder();
  final canvas = Canvas(recorder);
  final size = Size(px.toDouble(), px.toDouble());
  draw(canvas, size);
  final image = await recorder.endRecording().toImage(px, px);
  final bytes = await image.toByteData(format: ui.ImageByteFormat.png);
  File(path)
    ..createSync(recursive: true)
    ..writeAsBytesSync(bytes!.buffer.asUint8List());
}

void main() {
  testWidgets('generate DinoArena brand assets', (tester) async {
    await tester.runAsync(() async {
      // Full-bleed icon (iOS + legacy Android). iOS applies its own mask, so square corners.
      await _render('assets/brand/dinoarena_icon.png', 1024, (c, s) {
        DinoArenaMarkPainter(withBackground: true, backgroundRadius: 0, glyphScale: .82).paint(c, s);
      });
      // Adaptive foreground: mark only, kept inside the 66% safe zone.
      await _render('assets/brand/dinoarena_icon_foreground.png', 1024, (c, s) {
        DinoArenaMarkPainter(glyphScale: .82).paint(c, s);
      });
      // Android 13 themed (monochrome) icon.
      await _render('assets/brand/dinoarena_icon_monochrome.png', 1024, (c, s) {
        DinoArenaMarkPainter(tone: LogoTone.mono, glyphScale: .82).paint(c, s);
      });
      // In-app / social / signage lockups.
      await _render('assets/brand/dinoarena_mark_rounded.png', 1024, (c, s) {
        DinoArenaMarkPainter(withBackground: true).paint(c, s);
      });
      await _render('assets/brand/dinoarena_mark_on_light.png', 1024, (c, s) {
        DinoArenaMarkPainter(tone: LogoTone.onLight).paint(c, s);
      });
    });
  });
}
