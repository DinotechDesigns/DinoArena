import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/config/app_config.dart';
import '../../../../core/network/dio_client.dart';
import '../../data/notification_repository_impl.dart';
import '../../domain/entities/app_notification.dart';
import '../../domain/repositories/notification_repository.dart';

final notificationRepositoryProvider = Provider<NotificationRepository>(
  (ref) => AppConfig.useMockData ? MockNotificationRepository() : RemoteNotificationRepository(ref.watch(dioProvider)),
);

final notificationsControllerProvider = AsyncNotifierProvider<NotificationsController, List<AppNotification>>(
  NotificationsController.new,
);

class NotificationsController extends AsyncNotifier<List<AppNotification>> {
  @override
  Future<List<AppNotification>> build() => ref.watch(notificationRepositoryProvider).getNotifications();

  /// In-app notification raised by the client (e.g. right after a booking).
  void push({required String title, required String body, required NotificationType type, String? deepLink}) {
    final n = AppNotification(
      id: 'local_${DateTime.now().microsecondsSinceEpoch}',
      title: title,
      body: body,
      type: type,
      createdAt: DateTime.now(),
      deepLink: deepLink,
    );
    state = AsyncData([n, ...?state.value]);
  }

  Future<void> markRead(String id) async {
    state = AsyncData([for (final n in state.value ?? <AppNotification>[]) n.id == id ? n.copyWith(read: true) : n]);
    await ref.read(notificationRepositoryProvider).markRead(id);
  }

  Future<void> markAllRead() async {
    state = AsyncData([for (final n in state.value ?? <AppNotification>[]) n.copyWith(read: true)]);
    await ref.read(notificationRepositoryProvider).markAllRead();
  }
}

final unreadCountProvider = Provider<int>(
  (ref) => ref.watch(notificationsControllerProvider).value?.where((n) => !n.read).length ?? 0,
);
