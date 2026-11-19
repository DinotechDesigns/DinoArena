import 'package:freezed_annotation/freezed_annotation.dart';

part 'app_user.freezed.dart';
part 'app_user.g.dart';

@freezed
abstract class AppUser with _$AppUser {
  const AppUser._();

  const factory AppUser({
    required String id,
    required String phone,
    required String name,
    String? email,
    required DateTime memberSince,
    @Default(0) int gamesPlayed,
    @Default(0) int hoursPlayed,
    @Default(0) int tournamentsPlayed,
  }) = _AppUser;

  factory AppUser.fromJson(Map<String, dynamic> json) => _$AppUserFromJson(json);

  String get firstName => name.trim().isEmpty ? 'Player' : name.trim().split(' ').first;

  String get initials {
    final parts = name.trim().split(RegExp(r'\s+')).where((p) => p.isNotEmpty).toList();
    if (parts.isEmpty) return 'DA';
    return parts.take(2).map((p) => p[0].toUpperCase()).join();
  }

  String get tier => gamesPlayed >= 25 ? 'Arena Legend' : (gamesPlayed >= 10 ? 'Arena Pro' : 'Rookie');
}
