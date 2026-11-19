import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Typed wrapper around [SharedPreferences]. Overridden in `main.dart`.
final appPreferencesProvider = Provider<AppPreferences>(
  (ref) => throw UnimplementedError('appPreferencesProvider must be overridden at startup'),
);

class AppPreferences {
  AppPreferences(this._prefs);

  final SharedPreferences _prefs;

  static const _kOnboarded = 'onboarding_complete';
  static const _kToken = 'auth_token';
  static const _kUser = 'auth_user';

  bool get onboardingComplete => _prefs.getBool(_kOnboarded) ?? false;
  Future<void> setOnboardingComplete() => _prefs.setBool(_kOnboarded, true);

  String? get authToken => _prefs.getString(_kToken);
  String? get userJson => _prefs.getString(_kUser);

  Future<void> saveSession(String token, String userJson) async {
    await _prefs.setString(_kToken, token);
    await _prefs.setString(_kUser, userJson);
  }

  Future<void> saveUser(String userJson) => _prefs.setString(_kUser, userJson);

  Future<void> clearSession() async {
    await _prefs.remove(_kToken);
    await _prefs.remove(_kUser);
  }
}
