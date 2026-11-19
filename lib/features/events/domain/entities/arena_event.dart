import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../../shared/domain/sport_type.dart';

part 'arena_event.freezed.dart';
part 'arena_event.g.dart';

enum EventCadence {
  @JsonValue('daily')
  daily,
  @JsonValue('weekend')
  weekend,
}

@freezed
abstract class ArenaEvent with _$ArenaEvent {
  const ArenaEvent._();

  const factory ArenaEvent({
    required String id,
    required String title,
    required String subtitle,
    required String description,
    required EventCadence cadence,
    required SportType sport,
    required DateTime start,
    required DateTime end,
    required String venue,
    required int fee,
    required int capacity,
    required int registered,
    required String level,
    @Default(<String>[]) List<String> highlights,
  }) = _ArenaEvent;

  factory ArenaEvent.fromJson(Map<String, dynamic> json) => _$ArenaEventFromJson(json);

  int get spotsLeft => (capacity - registered).clamp(0, capacity);
  bool get isFull => spotsLeft == 0;
  double get fillRatio => capacity == 0 ? 1 : registered / capacity;
}
