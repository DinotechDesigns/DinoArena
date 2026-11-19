import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/config/app_config.dart';
import '../../../core/network/api_endpoints.dart';
import '../../../core/network/dio_client.dart';

abstract interface class SupportRepository {
  /// Returns the ticket reference.
  Future<String> submitTicket({required String topic, required String message});
}

class MockSupportRepository implements SupportRepository {
  @override
  Future<String> submitTicket({required String topic, required String message}) async {
    await Future.delayed(const Duration(milliseconds: 900));
    return 'DA-${DateTime.now().millisecondsSinceEpoch % 1000000}';
  }
}

class RemoteSupportRepository implements SupportRepository {
  RemoteSupportRepository(this._dio);

  final Dio _dio;

  @override
  Future<String> submitTicket({required String topic, required String message}) => guardApi(() async {
    final res = await _dio.post<Map<String, dynamic>>(
      ApiEndpoints.supportTickets,
      data: {'topic': topic, 'message': message},
    );
    return res.data!['reference'] as String;
  });
}

final supportRepositoryProvider = Provider<SupportRepository>(
  (ref) => AppConfig.useMockData ? MockSupportRepository() : RemoteSupportRepository(ref.watch(dioProvider)),
);
