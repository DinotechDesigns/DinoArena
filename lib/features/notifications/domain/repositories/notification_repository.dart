import '../entities/app_notification.dart';

abstract interface class NotificationRepository {
  Future<List<AppNotification>> getNotifications();

  Future<void> markAllRead();

  Future<void> markRead(String id);
}
