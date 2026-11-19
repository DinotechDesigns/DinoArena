// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'booking.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Booking _$BookingFromJson(Map<String, dynamic> json) => _Booking(
  id: json['id'] as String,
  code: json['code'] as String,
  kind: $enumDecode(_$BookingKindEnumMap, json['kind']),
  title: json['title'] as String,
  venue: json['venue'] as String,
  sport: $enumDecode(_$SportTypeEnumMap, json['sport']),
  start: DateTime.parse(json['start'] as String),
  end: DateTime.parse(json['end'] as String),
  amountPaid: (json['amount_paid'] as num).toInt(),
  status: $enumDecode(_$BookingStatusEnumMap, json['status']),
  createdAt: DateTime.parse(json['created_at'] as String),
  referenceId: json['reference_id'] as String?,
  unitLabel: json['unit_label'] as String?,
  paymentId: json['payment_id'] as String?,
  slotLabels: (json['slot_labels'] as List<dynamic>?)?.map((e) => e as String).toList() ?? const <String>[],
  players: (json['players'] as num?)?.toInt() ?? 1,
);

Map<String, dynamic> _$BookingToJson(_Booking instance) => <String, dynamic>{
  'id': instance.id,
  'code': instance.code,
  'kind': _$BookingKindEnumMap[instance.kind]!,
  'title': instance.title,
  'venue': instance.venue,
  'sport': _$SportTypeEnumMap[instance.sport]!,
  'start': instance.start.toIso8601String(),
  'end': instance.end.toIso8601String(),
  'amount_paid': instance.amountPaid,
  'status': _$BookingStatusEnumMap[instance.status]!,
  'created_at': instance.createdAt.toIso8601String(),
  'reference_id': ?instance.referenceId,
  'unit_label': ?instance.unitLabel,
  'payment_id': ?instance.paymentId,
  'slot_labels': instance.slotLabels,
  'players': instance.players,
};

const _$BookingKindEnumMap = {
  BookingKind.slot: 'slot',
  BookingKind.event: 'event',
  BookingKind.tournament: 'tournament',
};

const _$SportTypeEnumMap = {
  SportType.cricket: 'cricket',
  SportType.football: 'football',
  SportType.badminton: 'badminton',
  SportType.cricketNets: 'cricket_nets',
};

const _$BookingStatusEnumMap = {
  BookingStatus.confirmed: 'confirmed',
  BookingStatus.pending: 'pending',
  BookingStatus.cancelled: 'cancelled',
  BookingStatus.completed: 'completed',
};
