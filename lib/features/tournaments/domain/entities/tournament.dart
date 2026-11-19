import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../../shared/domain/sport_type.dart';

part 'tournament.freezed.dart';
part 'tournament.g.dart';

enum TournamentStatus {
  @JsonValue('open')
  open,
  @JsonValue('closing_soon')
  closingSoon,
  @JsonValue('full')
  full,
  @JsonValue('live')
  live,
}

@freezed
abstract class Tournament with _$Tournament {
  const Tournament._();

  const factory Tournament({
    required String id,
    required String name,
    required String tagline,
    required SportType sport,
    required String format,
    required DateTime startDate,
    required DateTime endDate,
    required DateTime registrationCloses,
    required int entryFee,
    required int prizePool,
    required int teamSize,
    required int maxTeams,
    required int registeredTeams,
    required TournamentStatus status,
    @Default(<String>[]) List<String> rules,
    @Default(<String>[]) List<String> prizes,
  }) = _Tournament;

  factory Tournament.fromJson(Map<String, dynamic> json) => _$TournamentFromJson(json);

  int get slotsLeft => (maxTeams - registeredTeams).clamp(0, maxTeams);
  bool get canRegister => status == TournamentStatus.open || status == TournamentStatus.closingSoon;
}

@freezed
abstract class TournamentRegistration with _$TournamentRegistration {
  const factory TournamentRegistration({
    required String tournamentId,
    required String teamName,
    required String captainName,
    required String captainPhone,
    required int players,
  }) = _TournamentRegistration;

  factory TournamentRegistration.fromJson(Map<String, dynamic> json) => _$TournamentRegistrationFromJson(json);
}
