import 'package:freezed_annotation/freezed_annotation.dart';

part 'slot.freezed.dart';
part 'slot.g.dart';

enum SlotStatus {
  @JsonValue('available')
  available,
  @JsonValue('booked')
  booked,
  @JsonValue('held')
  held,
  @JsonValue('blocked')
  blocked,
}

@freezed
abstract class Slot with _$Slot {
  const Slot._();

  const factory Slot({
    required String id,
    required String facilityId,
    required int unit,
    required DateTime start,
    required DateTime end,
    required int price,
    required SlotStatus status,
    @Default(false) bool isPeak,
  }) = _Slot;

  factory Slot.fromJson(Map<String, dynamic> json) => _$SlotFromJson(json);

  bool get isAvailable => status == SlotStatus.available;
}
