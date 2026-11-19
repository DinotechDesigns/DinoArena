// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'arena_event.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_ArenaEvent _$ArenaEventFromJson(Map<String, dynamic> json) => _ArenaEvent(
  id: json['id'] as String,
  title: json['title'] as String,
  subtitle: json['subtitle'] as String,
  description: json['description'] as String,
  cadence: $enumDecode(_$EventCadenceEnumMap, json['cadence']),
  sport: $enumDecode(_$SportTypeEnumMap, json['sport']),
  start: DateTime.parse(json['start'] as String),
  end: DateTime.parse(json['end'] as String),
  venue: json['venue'] as String,
  fee: (json['fee'] as num).toInt(),
  capacity: (json['capacity'] as num).toInt(),
  registered: (json['registered'] as num).toInt(),
  level: json['level'] as String,
  highlights: (json['highlights'] as List<dynamic>?)?.map((e) => e as String).toList() ?? const <String>[],
);

Map<String, dynamic> _$ArenaEventToJson(_ArenaEvent instance) => <String, dynamic>{
  'id': instance.id,
  'title': instance.title,
  'subtitle': instance.subtitle,
  'description': instance.description,
  'cadence': _$EventCadenceEnumMap[instance.cadence]!,
  'sport': _$SportTypeEnumMap[instance.sport]!,
  'start': instance.start.toIso8601String(),
  'end': instance.end.toIso8601String(),
  'venue': instance.venue,
  'fee': instance.fee,
  'capacity': instance.capacity,
  'registered': instance.registered,
  'level': instance.level,
  'highlights': instance.highlights,
};

const _$EventCadenceEnumMap = {EventCadence.daily: 'daily', EventCadence.weekend: 'weekend'};

const _$SportTypeEnumMap = {
  SportType.cricket: 'cricket',
  SportType.football: 'football',
  SportType.badminton: 'badminton',
  SportType.cricketNets: 'cricket_nets',
};
