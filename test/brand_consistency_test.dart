import 'dart:io';

import 'package:dinoarena/core/constants/brand.dart';
import 'package:flutter_test/flutter_test.dart';

/// Guards the DinoArena brand: correct name/package everywhere and no
/// leftover placeholder brands.
void main() {
  test('brand constants', () {
    expect(Brand.name, 'DinoArena');
    expect(Brand.tagline, 'PLAY. BOOK. COMPETE.');
    expect(Brand.packageName, 'com.dinoarena.app');
  });

  test('Android app is labelled DinoArena with package com.dinoarena.app', () {
    final manifest = File('android/app/src/main/AndroidManifest.xml').readAsStringSync();
    expect(manifest, contains('android:label="DinoArena"'));
    final gradle = File('android/app/build.gradle.kts').readAsStringSync();
    expect(gradle, contains('applicationId = "com.dinoarena.app"'));
    expect(gradle, contains('namespace = "com.dinoarena.app"'));
    expect(File('android/app/src/main/kotlin/com/dinoarena/app/MainActivity.kt').existsSync(), isTrue);
  });

  test('iOS display name is DinoArena', () {
    final plist = File('ios/Runner/Info.plist').readAsStringSync();
    expect(plist, contains('<string>DinoArena</string>'));
  });

  test('no placeholder brand names remain in the project', () {
    final banned = RegExp(r'arena\s*x\b', caseSensitive: false);
    final roots = ['lib', 'android/app/src', 'ios/Runner', 'README.md', 'pubspec.yaml'];
    final offenders = <String>[];
    for (final root in roots) {
      final entity = FileSystemEntity.typeSync(root);
      final files = entity == FileSystemEntityType.directory
          ? Directory(root).listSync(recursive: true).whereType<File>()
          : [File(root)];
      for (final f in files) {
        if (!RegExp(r'\.(dart|xml|kt|kts|plist|md|yaml|json|storyboard)$').hasMatch(f.path)) continue;
        if (banned.hasMatch(f.readAsStringSync())) offenders.add(f.path);
      }
    }
    expect(offenders, isEmpty, reason: 'Found placeholder brand in: $offenders');
  });
}
