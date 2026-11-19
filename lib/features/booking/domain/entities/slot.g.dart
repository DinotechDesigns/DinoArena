// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'slot.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Slot _$SlotFromJson(Map<String, dynamic> json) => _Slot(
  id: json['id'] as String,
  facilityId: json['facility_id'] as String,
  unit: (json['unit'] as num).toInt(),
  start: DateTime.parse(json['start'] as String),
  end: DateTime.parse(json['end'] as String),
  price: (json['price'] as num).toInt(),
  status: $enumDecode(_$SlotStatusEnumMap, json['status']),
  isPeak: json['is_peak'] as bool? ?? false,
);

Map<String, dynamic> _$SlotToJson(_Slot instance) => <String, dynamic>{
  'id': instance.id,
  'facility_id': instance.facilityId,
  'unit': instance.unit,
  'start': instance.start.toIso8601String(),
  'end': instance.end.toIso8601String(),
  'price': instance.price,
  'status': _$SlotStatusEnumMap[instance.status]!,
  'is_peak': instance.isPeak,
};

const _$SlotStatusEnumMap = {
  SlotStatus.available: 'available',
  SlotStatus.booked: 'booked',
  SlotStatus.held: 'held',
  SlotStatus.blocked: 'blocked',
};
