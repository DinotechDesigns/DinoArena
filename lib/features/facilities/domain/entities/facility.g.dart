// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'facility.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Facility _$FacilityFromJson(Map<String, dynamic> json) => _Facility(
  id: json['id'] as String,
  name: json['name'] as String,
  headline: json['headline'] as String,
  kind: $enumDecode(_$FacilityKindEnumMap, json['kind']),
  sports: (json['sports'] as List<dynamic>).map((e) => $enumDecode(_$SportTypeEnumMap, e)).toList(),
  description: json['description'] as String,
  pricePerHour: (json['price_per_hour'] as num).toInt(),
  peakPricePerHour: (json['peak_price_per_hour'] as num).toInt(),
  rating: (json['rating'] as num).toDouble(),
  reviewCount: (json['review_count'] as num).toInt(),
  openHour: (json['open_hour'] as num).toInt(),
  closeHour: (json['close_hour'] as num).toInt(),
  surface: json['surface'] as String,
  dimensions: json['dimensions'] as String,
  maxPlayers: (json['max_players'] as num).toInt(),
  units: (json['units'] as num?)?.toInt() ?? 1,
  unitLabel: json['unit_label'] as String? ?? 'Court',
  amenities: (json['amenities'] as List<dynamic>?)?.map((e) => e as String).toList() ?? const <String>[],
  rules: (json['rules'] as List<dynamic>?)?.map((e) => e as String).toList() ?? const <String>[],
  featured: json['featured'] as bool? ?? false,
  badge: json['badge'] as String?,
);

Map<String, dynamic> _$FacilityToJson(_Facility instance) => <String, dynamic>{
  'id': instance.id,
  'name': instance.name,
  'headline': instance.headline,
  'kind': _$FacilityKindEnumMap[instance.kind]!,
  'sports': instance.sports.map((e) => _$SportTypeEnumMap[e]!).toList(),
  'description': instance.description,
  'price_per_hour': instance.pricePerHour,
  'peak_price_per_hour': instance.peakPricePerHour,
  'rating': instance.rating,
  'review_count': instance.reviewCount,
  'open_hour': instance.openHour,
  'close_hour': instance.closeHour,
  'surface': instance.surface,
  'dimensions': instance.dimensions,
  'max_players': instance.maxPlayers,
  'units': instance.units,
  'unit_label': instance.unitLabel,
  'amenities': instance.amenities,
  'rules': instance.rules,
  'featured': instance.featured,
  'badge': ?instance.badge,
};

const _$FacilityKindEnumMap = {
  FacilityKind.boxTurf: 'box_turf',
  FacilityKind.badmintonCourt: 'badminton_court',
  FacilityKind.practiceNets: 'practice_nets',
};

const _$SportTypeEnumMap = {
  SportType.cricket: 'cricket',
  SportType.football: 'football',
  SportType.badminton: 'badminton',
  SportType.cricketNets: 'cricket_nets',
};
