import '../entities/facility.dart';

abstract interface class FacilityRepository {
  Future<List<Facility>> getFacilities();

  Future<Facility> getFacility(String id);
}
