import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/config/app_config.dart';
import '../../../../core/network/dio_client.dart';
import '../../data/tournament_repository_impl.dart';
import '../../domain/entities/tournament.dart';
import '../../domain/repositories/tournament_repository.dart';

final tournamentRepositoryProvider = Provider<TournamentRepository>(
  (ref) => AppConfig.useMockData ? MockTournamentRepository() : RemoteTournamentRepository(ref.watch(dioProvider)),
);

final tournamentsProvider = FutureProvider<List<Tournament>>(
  (ref) => ref.watch(tournamentRepositoryProvider).getTournaments(),
);

final tournamentProvider = Provider.family<AsyncValue<Tournament>, String>(
  (ref, id) => ref.watch(tournamentsProvider).whenData((list) => list.firstWhere((t) => t.id == id)),
);
