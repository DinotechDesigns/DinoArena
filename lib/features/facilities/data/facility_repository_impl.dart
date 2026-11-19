import 'package:dio/dio.dart';

import '../../../core/network/api_endpoints.dart';
import '../../../core/network/api_exception.dart';
import '../../../core/network/dio_client.dart';
import '../../../shared/data/mock_catalog.dart';
import '../domain/entities/facility.dart';
import '../domain/repositories/facility_repository.dart';

class MockFacilityRepository implements FacilityRepository {
  @override
  Future<List<Facility>> getFacilities() async {
    await Future.delayed(const Duration(milliseconds: 450));
    return MockCatalog.facilities;
  }

  @override
  Future<Facility> getFacility(String id) async {
    await Future.delayed(const Duration(milliseconds: 200));
    return MockCatalog.facilities.firstWhere(
      (f) => f.id == id,
      orElse: () => throw const ApiException('Facility not found', statusCode: 404),
    );
  }
}

class RemoteFacilityRepository implements FacilityRepository {
  RemoteFacilityRepository(this._dio);

  final Dio _dio;

  @override
  Future<List<Facility>> getFacilities() => guardApi(() async {
    final res = await _dio.get<List<dynamic>>(ApiEndpoints.facilities);
    return res.data!.map((e) => Facility.fromJson(e as Map<String, dynamic>)).toList();
  });

  @override
  Future<Facility> getFacility(String id) => guardApi(() async {
    final res = await _dio.get<Map<String, dynamic>>(ApiEndpoints.facility(id));
    return Facility.fromJson(res.data!);
  });
}
