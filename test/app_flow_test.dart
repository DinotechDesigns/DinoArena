import 'package:dinoarena/app/app.dart';
import 'package:dinoarena/core/config/app_config.dart';
import 'package:dinoarena/core/storage/preferences.dart';
import 'package:dinoarena/features/auth/presentation/screens/login_screen.dart';
import 'package:dinoarena/features/auth/presentation/screens/otp_screen.dart';
import 'package:dinoarena/features/auth/presentation/screens/profile_setup_screen.dart';
import 'package:dinoarena/features/home/presentation/home_screen.dart';
import 'package:dinoarena/features/onboarding/presentation/onboarding_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'helpers/fonts.dart';

/// Pumps frames for [d] without waiting for infinite animations to settle.
Future<void> _advance(WidgetTester tester, Duration d) async {
  const step = Duration(milliseconds: 100);
  for (var t = Duration.zero; t < d; t += step) {
    await tester.pump(step);
  }
}

void main() {
  testWidgets('first launch: splash → onboarding → login → OTP → profile → home', (tester) async {
    await tester.runAsync(loadAppFonts);
    tester.view.physicalSize = const Size(1170, 2532);
    tester.view.devicePixelRatio = 3;
    addTearDown(tester.view.reset);

    SharedPreferences.setMockInitialValues({});
    final prefs = await SharedPreferences.getInstance();
    await tester.pumpWidget(
      ProviderScope(
        overrides: [appPreferencesProvider.overrideWithValue(AppPreferences(prefs))],
        child: const DinoArenaApp(),
      ),
    );

    // Splash shows the brand.
    await _advance(tester, const Duration(milliseconds: 1600));
    expect(find.text('PLAY.'), findsOneWidget);
    expect(find.text('COMPETE.'), findsOneWidget);

    // Onboarding: three pages.
    await _advance(tester, const Duration(seconds: 2));
    expect(find.byType(OnboardingScreen), findsOneWidget);
    for (var i = 0; i < 2; i++) {
      await tester.tap(find.text('Next'));
      await _advance(tester, const Duration(milliseconds: 700));
    }
    expect(find.text('Get started'), findsOneWidget);
    await tester.tap(find.text('Get started'));
    await _advance(tester, const Duration(milliseconds: 800));
    expect(prefs.getBool('onboarding_complete'), isTrue);

    // Login.
    expect(find.byType(LoginScreen), findsOneWidget);
    expect(find.text('Welcome to\nDinoArena'), findsOneWidget);
    await tester.enterText(find.byType(TextField), '9876543210');
    await tester.pump();
    await tester.tap(find.text('Get OTP'));
    await _advance(tester, const Duration(milliseconds: 1600));

    // OTP: wrong code first, then the demo code.
    expect(find.byType(OtpScreen), findsOneWidget);
    await tester.enterText(find.byType(TextField), '9999');
    await _advance(tester, const Duration(milliseconds: 1500));
    expect(find.textContaining('doesn’t match'), findsOneWidget);
    await tester.enterText(find.byType(TextField), AppConfig.demoOtp);
    await _advance(tester, const Duration(milliseconds: 1800));

    // New user completes their profile.
    expect(find.byType(ProfileSetupScreen), findsOneWidget);
    await tester.enterText(find.byType(TextField).first, 'Arjun Mehta');
    await tester.pump();
    await tester.tap(find.text('Enter the arena'));
    await _advance(tester, const Duration(milliseconds: 1500));

    // Home dashboard.
    expect(find.byType(HomeScreen), findsOneWidget);
    expect(find.text('Arjun'), findsOneWidget);
    await _advance(tester, const Duration(seconds: 1));
    expect(find.text('Our arenas'), findsOneWidget);
    expect(find.text('The Dino Box'), findsWidgets);

    // Let any outstanding mock timers complete.
    await tester.pumpWidget(const SizedBox());
    await _advance(tester, const Duration(seconds: 20));
  });
}
