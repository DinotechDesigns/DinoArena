import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../../shared/domain/sport_type.dart';

part 'booking.freezed.dart';
part 'booking.g.dart';

/// What the pass grants entry to.
enum BookingKind {
  @JsonValue('slot')
  slot,
  @JsonValue('event')
  event,
  @JsonValue('tournament')
  tournament,
}

enum BookingStatus {
  @JsonValue('confirmed')
  confirmed,
  @JsonValue('pending')
  pending,
  @JsonValue('cancelled')
  cancelled,
  @JsonValue('completed')
  completed,
}

@freezed
abstract class Booking with _$Booking {
  const Booking._();

  const factory Booking({
    required String id,
    required String code,
    required BookingKind kind,
    required String title,
    required String venue,
    required SportType sport,
    required DateTime start,
    required DateTime end,
    required int amountPaid,
    required BookingStatus status,
    required DateTime createdAt,
    String? referenceId,
    String? unitLabel,
    String? paymentId,
    @Default(<String>[]) List<String> slotLabels,
    @Default(1) int players,
  }) = _Booking;

  factory Booking.fromJson(Map<String, dynamic> json) => _$BookingFromJson(json);

  bool get isUpcoming =>
      (status == BookingStatus.confirmed || status == BookingStatus.pending) && end.isAfter(DateTime.now());

  bool get isPast =>
      status == BookingStatus.completed || (status == BookingStatus.confirmed && !end.isAfter(DateTime.now()));

  bool get canCancel => kind == BookingKind.slot && isUpcoming && start.difference(DateTime.now()).inHours >= 2;

  /// Payload encoded in the entry QR. Verified at the venue against the backend.
  String get qrPayload => 'dinoarena://pass/$code?b=$id';
}
