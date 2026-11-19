import '../entities/arena_event.dart';

abstract interface class EventRepository {
  Future<List<ArenaEvent>> getEvents();
}
