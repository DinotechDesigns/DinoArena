import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/config/app_config.dart';
import '../../../../core/network/dio_client.dart';
import '../../../../shared/domain/sport_type.dart';
import '../../data/facility_repository_impl.dart';
import '../../domain/entities/facility.dart';
import '../../domain/repositories/facility_repository.dart';

final facilityRepositoryProvider = Provider<FacilityRepository>(
  (ref) => AppConfig.useMockData ? MockFacilityRepository() : RemoteFacilityRepository(ref.watch(dioProvider)),
);

final facilitiesProvider = FutureProvider<List<Facility>>(
  (ref) => ref.watch(facilityRepositoryProvider).getFacilities(),
);

final facilityProvider = FutureProvider.family<Facility, String>((ref, id) async {
  final all = ref.watch(facilitiesProvider).value;
  final cached = all?.where((f) => f.id == id).firstOrNull;
  return cached ?? ref.watch(facilityRepositoryProvider).getFacility(id);
});

/// Discovery filters.
final facilitySportFilterProvider = NotifierProvider<SportFilter, SportType?>(SportFilter.new);
final facilitySearchProvider = NotifierProvider<SearchQuery, String>(SearchQuery.new);

class SportFilter extends Notifier<SportType?> {
  @override
  SportType? build() => null;

  void select(SportType? sport) => state = state == sport ? null : sport;
}

class SearchQuery extends Notifier<String> {
  @override
  String build() => '';

  void set(String q) => state = q;
}

final filteredFacilitiesProvider = Provider<AsyncValue<List<Facility>>>((ref) {
  final sport = ref.watch(facilitySportFilterProvider);
  final query = ref.watch(facilitySearchProvider).trim().toLowerCase();
  return ref
      .watch(facilitiesProvider)
      .whenData(
        (list) => list.where((f) {
          final matchesSport = sport == null || f.sports.contains(sport);
          final matchesQuery =
              query.isEmpty ||
              f.name.toLowerCase().contains(query) ||
              f.headline.toLowerCase().contains(query) ||
              f.sports.any((s) => s.label.toLowerCase().contains(query));
          return matchesSport && matchesQuery;
        }).toList(),
      );
});
