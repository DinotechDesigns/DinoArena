import '../entities/tournament.dart';

abstract interface class TournamentRepository {
  Future<List<Tournament>> getTournaments();

  /// Registers a team; returns the registration id.
  Future<String> register(TournamentRegistration registration);
}
