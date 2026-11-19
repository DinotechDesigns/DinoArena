import 'dart:io';

import 'package:flutter/services.dart';

/// flutter_test renders text with a placeholder font. Load the real DinoArena
/// fonts (and Material icons) so layout checks and screenshots are faithful.
Future<void> loadAppFonts() async {
  Future<ByteData> bytes(String path) async => ByteData.sublistView(await File(path).readAsBytes());

  Future<void> family(String name, List<String> files) async {
    final loader = FontLoader(name);
    for (final f in files) {
      loader.addFont(bytes(f));
    }
    await loader.load();
  }

  await family('PlusJakartaSans', [for (final w in [400, 500, 600, 700, 800]) 'assets/fonts/PlusJakartaSans-$w.ttf']);
  await family('PlusJakartaSansExt', [for (final w in [400, 500, 600, 700, 800]) 'assets/fonts/PlusJakartaSansExt-$w.ttf']);
  await family('Inter', [for (final w in [400, 500, 600, 700]) 'assets/fonts/Inter-$w.ttf']);
  await family('InterExt', [for (final w in [400, 500, 600, 700]) 'assets/fonts/InterExt-$w.ttf']);

  final flutterRoot = Platform.environment['FLUTTER_ROOT'] ?? 'C:/flutter';
  final icons = File('$flutterRoot/bin/cache/artifacts/material_fonts/MaterialIcons-Regular.otf');
  if (icons.existsSync()) await family('MaterialIcons', [icons.path]);
}
