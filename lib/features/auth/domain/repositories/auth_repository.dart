import '../entities/app_user.dart';

class AuthSession {
  const AuthSession({required this.token, required this.user, required this.isNewUser});

  final String token;
  final AppUser user;
  final bool isNewUser;
}

abstract interface class AuthRepository {
  /// Sends an OTP to [phone] (E.164 without '+', e.g. 919876543210).
  Future<void> requestOtp(String phone);

  Future<AuthSession> verifyOtp({required String phone, required String otp});

  Future<AppUser> updateProfile(AppUser user);
}
