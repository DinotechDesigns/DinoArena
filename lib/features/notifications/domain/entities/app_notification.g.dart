// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_notification.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_AppNotification _$AppNotificationFromJson(Map<String, dynamic> json) => _AppNotification(
  id: json['id'] as String,
  title: json['title'] as String,
  body: json['body'] as String,
  type: $enumDecode(_$NotificationTypeEnumMap, json['type']),
  createdAt: DateTime.parse(json['created_at'] as String),
  read: json['read'] as bool? ?? false,
  deepLink: json['deep_link'] as String?,
);

Map<String, dynamic> _$AppNotificationToJson(_AppNotification instance) => <String, dynamic>{
  'id': instance.id,
  'title': instance.title,
  'body': instance.body,
  'type': _$NotificationTypeEnumMap[instance.type]!,
  'created_at': instance.createdAt.toIso8601String(),
  'read': instance.read,
  'deep_link': ?instance.deepLink,
};

const _$NotificationTypeEnumMap = {
  NotificationType.booking: 'booking',
  NotificationType.payment: 'payment',
  NotificationType.event: 'event',
  NotificationType.tournament: 'tournament',
  NotificationType.promo: 'promo',
};
