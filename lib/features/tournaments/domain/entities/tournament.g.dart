// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'tournament.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Tournament _$TournamentFromJson(Map<String, dynamic> json) => _Tournament(
  id: json['id'] as String,
  name: json['name'] as String,
  tagline: json['tagline'] as String,
  sport: $enumDecode(_$SportTypeEnumMap, json['sport']),
  format: json['format'] as String,
  startDate: DateTime.parse(json['start_date'] as String),
  endDate: DateTime.parse(json['end_date'] as String),
  registrationCloses: DateTime.parse(json['registration_closes'] as String),
  entryFee: (json['entry_fee'] as num).toInt(),
  prizePool: (json['prize_pool'] as num).toInt(),
  teamSize: (json['team_size'] as num).toInt(),
  maxTeams: (json['max_teams'] as num).toInt(),
  registeredTeams: (json['registered_teams'] as num).toInt(),
  status: $enumDecode(_$TournamentStatusEnumMap, json['status']),
  rules: (json['rules'] as List<dynamic>?)?.map((e) => e as String).toList() ?? const <String>[],
  prizes: (json['prizes'] as List<dynamic>?)?.map((e) => e as String).toList() ?? const <String>[],
);

Map<String, dynamic> _$TournamentToJson(_Tournament instance) => <String, dynamic>{
  'id': instance.id,
  'name': instance.name,
  'tagline': instance.tagline,
  'sport': _$SportTypeEnumMap[instance.sport]!,
  'format': instance.format,
  'start_date': instance.startDate.toIso8601String(),
  'end_date': instance.endDate.toIso8601String(),
  'registration_closes': instance.registrationCloses.toIso8601String(),
  'entry_fee': instance.entryFee,
  'prize_pool': instance.prizePool,
  'team_size': instance.teamSize,
  'max_teams': instance.maxTeams,
  'registered_teams': instance.registeredTeams,
  'status': _$TournamentStatusEnumMap[instance.status]!,
  'rules': instance.rules,
  'prizes': instance.prizes,
};

const _$SportTypeEnumMap = {
  SportType.cricket: 'cricket',
  SportType.football: 'football',
  SportType.badminton: 'badminton',
  SportType.cricketNets: 'cricket_nets',
};

const _$TournamentStatusEnumMap = {
  TournamentStatus.open: 'open',
  TournamentStatus.closingSoon: 'closing_soon',
  TournamentStatus.full: 'full',
  TournamentStatus.live: 'live',
};

_TournamentRegistration _$TournamentRegistrationFromJson(Map<String, dynamic> json) => _TournamentRegistration(
  tournamentId: json['tournament_id'] as String,
  teamName: json['team_name'] as String,
  captainName: json['captain_name'] as String,
  captainPhone: json['captain_phone'] as String,
  players: (json['players'] as num).toInt(),
);

Map<String, dynamic> _$TournamentRegistrationToJson(_TournamentRegistration instance) => <String, dynamic>{
  'tournament_id': instance.tournamentId,
  'team_name': instance.teamName,
  'captain_name': instance.captainName,
  'captain_phone': instance.captainPhone,
  'players': instance.players,
};
