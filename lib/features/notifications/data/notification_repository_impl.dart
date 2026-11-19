import 'package:dio/dio.dart';

import '../../../core/network/api_endpoints.dart';
import '../../../core/network/dio_client.dart';
import '../../../shared/data/mock_catalog.dart';
import '../domain/entities/app_notification.dart';
import '../domain/repositories/notification_repository.dart';

class MockNotificationRepository implements NotificationRepository {
  @override
  Future<List<AppNotification>> getNotifications() async {
    await Future.delayed(const Duration(milliseconds: 350));
    return MockCatalog.notifications();
  }

  @override
  Future<void> markAllRead() async {}

  @override
  Future<void> markRead(String id) async {}
}

class RemoteNotificationRepository implements NotificationRepository {
  RemoteNotificationRepository(this._dio);

  final Dio _dio;

  @override
  Future<List<AppNotification>> getNotifications() => guardApi(() async {
    final res = await _dio.get<List<dynamic>>(ApiEndpoints.notifications);
    return res.data!.map((e) => AppNotification.fromJson(e as Map<String, dynamic>)).toList();
  });

  @override
  Future<void> markAllRead() => guardApi(() => _dio.post<void>(ApiEndpoints.markNotificationsRead));

  @override
  Future<void> markRead(String id) => guardApi(
    () => _dio.post<void>(
      ApiEndpoints.markNotificationsRead,
      data: {
        'ids': [id],
      },
    ),
  );
}
