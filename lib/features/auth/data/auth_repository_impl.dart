import 'package:dio/dio.dart';

import '../../../core/config/app_config.dart';
import '../../../core/network/api_endpoints.dart';
import '../../../core/network/api_exception.dart';
import '../../../core/network/dio_client.dart';
import '../domain/entities/app_user.dart';
import '../domain/repositories/auth_repository.dart';

/// Release 1: accepts the demo OTP [AppConfig.demoOtp] for any number.
class MockAuthRepository implements AuthRepository {
  @override
  Future<void> requestOtp(String phone) => Future.delayed(const Duration(milliseconds: 900));

  @override
  Future<AuthSession> verifyOtp({required String phone, required String otp}) async {
    await Future.delayed(const Duration(milliseconds: 1100));
    if (otp != AppConfig.demoOtp) {
      throw const ApiException('That code doesn’t match. Use the demo code ${AppConfig.demoOtp}.');
    }
    final user = AppUser(
      id: 'usr_${phone.hashCode.abs()}',
      phone: phone,
      name: '',
      memberSince: DateTime.now(),
      gamesPlayed: 12,
      hoursPlayed: 19,
      tournamentsPlayed: 2,
    );
    return AuthSession(token: 'demo-token-${DateTime.now().millisecondsSinceEpoch}', user: user, isNewUser: true);
  }

  @override
  Future<AppUser> updateProfile(AppUser user) async {
    await Future.delayed(const Duration(milliseconds: 500));
    return user;
  }
}

/// FastAPI implementation.
class RemoteAuthRepository implements AuthRepository {
  RemoteAuthRepository(this._dio);

  final Dio _dio;

  @override
  Future<void> requestOtp(String phone) =>
      guardApi(() => _dio.post<void>(ApiEndpoints.requestOtp, data: {'phone': phone}));

  @override
  Future<AuthSession> verifyOtp({required String phone, required String otp}) => guardApi(() async {
    final res = await _dio.post<Map<String, dynamic>>(ApiEndpoints.verifyOtp, data: {'phone': phone, 'otp': otp});
    final body = res.data!;
    return AuthSession(
      token: body['access_token'] as String,
      user: AppUser.fromJson(body['user'] as Map<String, dynamic>),
      isNewUser: body['is_new_user'] as bool? ?? false,
    );
  });

  @override
  Future<AppUser> updateProfile(AppUser user) => guardApi(() async {
    final res = await _dio.patch<Map<String, dynamic>>(ApiEndpoints.me, data: {'name': user.name, 'email': user.email});
    return AppUser.fromJson(res.data!);
  });
}
