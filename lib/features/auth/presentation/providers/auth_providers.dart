import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/config/app_config.dart';
import '../../../../core/network/dio_client.dart';
import '../../../../core/storage/preferences.dart';
import '../../data/auth_repository_impl.dart';
import '../../domain/entities/app_user.dart';
import '../../domain/repositories/auth_repository.dart';

final authRepositoryProvider = Provider<AuthRepository>(
  (ref) => AppConfig.useMockData ? MockAuthRepository() : RemoteAuthRepository(ref.watch(dioProvider)),
);

class AuthState {
  const AuthState({this.user});

  final AppUser? user;

  bool get isAuthenticated => user != null;
  bool get needsProfile => user != null && user!.name.trim().isEmpty;
}

final authControllerProvider = NotifierProvider<AuthController, AuthState>(AuthController.new);

class AuthController extends Notifier<AuthState> {
  AppPreferences get _prefs => ref.read(appPreferencesProvider);
  AuthRepository get _repo => ref.read(authRepositoryProvider);

  @override
  AuthState build() {
    final prefs = ref.watch(appPreferencesProvider);
    final json = prefs.userJson;
    if (prefs.authToken == null || json == null) return const AuthState();
    try {
      return AuthState(user: AppUser.fromJson(jsonDecode(json) as Map<String, dynamic>));
    } catch (_) {
      return const AuthState();
    }
  }

  Future<void> requestOtp(String phone) => _repo.requestOtp(phone);

  /// Returns true when the user still has to complete their profile.
  Future<bool> verifyOtp(String phone, String otp) async {
    final session = await _repo.verifyOtp(phone: phone, otp: otp);
    await _prefs.saveSession(session.token, jsonEncode(session.user.toJson()));
    state = AuthState(user: session.user);
    return state.needsProfile;
  }

  Future<void> updateProfile({required String name, String? email}) async {
    final current = state.user;
    if (current == null) return;
    final updated = await _repo.updateProfile(
      current.copyWith(name: name.trim(), email: (email?.trim().isEmpty ?? true) ? null : email!.trim()),
    );
    await _prefs.saveUser(jsonEncode(updated.toJson()));
    state = AuthState(user: updated);
  }

  Future<void> logout() async {
    await _prefs.clearSession();
    state = const AuthState();
  }
}
