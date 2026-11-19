import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../../shared/domain/sport_type.dart';

part 'facility.freezed.dart';
part 'facility.g.dart';

enum FacilityKind {
  @JsonValue('box_turf')
  boxTurf,
  @JsonValue('badminton_court')
  badmintonCourt,
  @JsonValue('practice_nets')
  practiceNets,
}

@freezed
abstract class Facility with _$Facility {
  const Facility._();

  const factory Facility({
    required String id,
    required String name,
    required String headline,
    required FacilityKind kind,
    required List<SportType> sports,
    required String description,
    required int pricePerHour,
    required int peakPricePerHour,
    required double rating,
    required int reviewCount,
    required int openHour,
    required int closeHour,
    required String surface,
    required String dimensions,
    required int maxPlayers,
    @Default(1) int units,
    @Default('Court') String unitLabel,
    @Default(<String>[]) List<String> amenities,
    @Default(<String>[]) List<String> rules,
    @Default(false) bool featured,
    String? badge,
  }) = _Facility;

  factory Facility.fromJson(Map<String, dynamic> json) => _$FacilityFromJson(json);

  SportType get primarySport => sports.first;
  bool get hasMultipleUnits => units > 1;

  /// Evening (6 PM onwards) and weekend slots are charged at peak rates.
  bool isPeak(DateTime start) =>
      start.hour >= 18 || start.weekday == DateTime.saturday || start.weekday == DateTime.sunday;

  int priceFor(DateTime start) => isPeak(start) ? peakPricePerHour : pricePerHour;
}
