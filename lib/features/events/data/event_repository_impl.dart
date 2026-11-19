import 'package:dio/dio.dart';

import '../../../core/network/api_endpoints.dart';
import '../../../core/network/dio_client.dart';
import '../../../shared/data/mock_catalog.dart';
import '../domain/entities/arena_event.dart';
import '../domain/repositories/event_repository.dart';

class MockEventRepository implements EventRepository {
  @override
  Future<List<ArenaEvent>> getEvents() async {
    await Future.delayed(const Duration(milliseconds: 500));
    return MockCatalog.events()..sort((a, b) => a.start.compareTo(b.start));
  }
}

class RemoteEventRepository implements EventRepository {
  RemoteEventRepository(this._dio);

  final Dio _dio;

  @override
  Future<List<ArenaEvent>> getEvents() => guardApi(() async {
    final res = await _dio.get<List<dynamic>>(ApiEndpoints.events);
    return res.data!.map((e) => ArenaEvent.fromJson(e as Map<String, dynamic>)).toList();
  });
}
