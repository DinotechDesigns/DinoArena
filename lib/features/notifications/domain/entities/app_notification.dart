import 'package:freezed_annotation/freezed_annotation.dart';

part 'app_notification.freezed.dart';
part 'app_notification.g.dart';

enum NotificationType {
  @JsonValue('booking')
  booking,
  @JsonValue('payment')
  payment,
  @JsonValue('event')
  event,
  @JsonValue('tournament')
  tournament,
  @JsonValue('promo')
  promo,
}

@freezed
abstract class AppNotification with _$AppNotification {
  const factory AppNotification({
    required String id,
    required String title,
    required String body,
    required NotificationType type,
    required DateTime createdAt,
    @Default(false) bool read,
    String? deepLink,
  }) = _AppNotification;

  factory AppNotification.fromJson(Map<String, dynamic> json) => _$AppNotificationFromJson(json);
}
