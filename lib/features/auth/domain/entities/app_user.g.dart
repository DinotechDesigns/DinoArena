// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_user.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_AppUser _$AppUserFromJson(Map<String, dynamic> json) => _AppUser(
  id: json['id'] as String,
  phone: json['phone'] as String,
  name: json['name'] as String,
  email: json['email'] as String?,
  memberSince: DateTime.parse(json['member_since'] as String),
  gamesPlayed: (json['games_played'] as num?)?.toInt() ?? 0,
  hoursPlayed: (json['hours_played'] as num?)?.toInt() ?? 0,
  tournamentsPlayed: (json['tournaments_played'] as num?)?.toInt() ?? 0,
);

Map<String, dynamic> _$AppUserToJson(_AppUser instance) => <String, dynamic>{
  'id': instance.id,
  'phone': instance.phone,
  'name': instance.name,
  'email': ?instance.email,
  'member_since': instance.memberSince.toIso8601String(),
  'games_played': instance.gamesPlayed,
  'hours_played': instance.hoursPlayed,
  'tournaments_played': instance.tournamentsPlayed,
};
