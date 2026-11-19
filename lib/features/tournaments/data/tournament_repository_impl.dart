import 'package:dio/dio.dart';

import '../../../core/network/api_endpoints.dart';
import '../../../core/network/dio_client.dart';
import '../../../shared/data/mock_catalog.dart';
import '../domain/entities/tournament.dart';
import '../domain/repositories/tournament_repository.dart';

class MockTournamentRepository implements TournamentRepository {
  final _registered = <String>{};

  @override
  Future<List<Tournament>> getTournaments() async {
    await Future.delayed(const Duration(milliseconds: 500));
    return [
      for (final t in MockCatalog.tournaments())
        _registered.contains(t.id) ? t.copyWith(registeredTeams: t.registeredTeams + 1) : t,
    ];
  }

  @override
  Future<String> register(TournamentRegistration registration) async {
    await Future.delayed(const Duration(milliseconds: 400));
    _registered.add(registration.tournamentId);
    return 'reg_${DateTime.now().millisecondsSinceEpoch}';
  }
}

class RemoteTournamentRepository implements TournamentRepository {
  RemoteTournamentRepository(this._dio);

  final Dio _dio;

  @override
  Future<List<Tournament>> getTournaments() => guardApi(() async {
    final res = await _dio.get<List<dynamic>>(ApiEndpoints.tournaments);
    return res.data!.map((e) => Tournament.fromJson(e as Map<String, dynamic>)).toList();
  });

  @override
  Future<String> register(TournamentRegistration registration) => guardApi(() async {
    final res = await _dio.post<Map<String, dynamic>>(
      ApiEndpoints.tournamentRegister(registration.tournamentId),
      data: registration.toJson(),
    );
    return res.data!['id'] as String;
  });
}
