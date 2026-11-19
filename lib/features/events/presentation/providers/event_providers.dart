import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/config/app_config.dart';
import '../../../../core/network/dio_client.dart';
import '../../data/event_repository_impl.dart';
import '../../domain/entities/arena_event.dart';
import '../../domain/repositories/event_repository.dart';

final eventRepositoryProvider = Provider<EventRepository>(
  (ref) => AppConfig.useMockData ? MockEventRepository() : RemoteEventRepository(ref.watch(dioProvider)),
);

final eventsProvider = FutureProvider<List<ArenaEvent>>((ref) => ref.watch(eventRepositoryProvider).getEvents());

final eventProvider = Provider.family<AsyncValue<ArenaEvent>, String>(
  (ref, id) => ref.watch(eventsProvider).whenData((list) => list.firstWhere((e) => e.id == id)),
);
