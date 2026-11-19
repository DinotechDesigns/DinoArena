import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/utils/formatters.dart';
import '../../../core/widgets/common.dart';
import '../../../core/widgets/pressable.dart';
import '../domain/entities/app_notification.dart';
import 'providers/notification_providers.dart';

class NotificationsScreen extends ConsumerWidget {
  const NotificationsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final async = ref.watch(notificationsControllerProvider);
    final unread = ref.watch(unreadCountProvider);

    return Scaffold(
      appBar: AppTopBar(
        title: 'Notifications',
        actions: [
          if (unread > 0)
            TextButton(
              onPressed: ref.read(notificationsControllerProvider.notifier).markAllRead,
              child: const Text('Mark all read'),
            ),
        ],
      ),
      body: async.when(
        loading: () => ListView.separated(
          padding: const EdgeInsets.all(AppSpacing.gutter),
          itemCount: 5,
          separatorBuilder: (_, _) => const SizedBox(height: 10),
          itemBuilder: (_, _) => const SkeletonBox(height: 86),
        ),
        error: (e, _) =>
            ErrorView(message: e.toString(), onRetry: () => ref.invalidate(notificationsControllerProvider)),
        data: (list) {
          if (list.isEmpty) {
            return const EmptyState(
              icon: Icons.notifications_off_outlined,
              title: 'All quiet',
              message: 'Booking updates, event reminders and offers will appear here.',
            );
          }
          final today = list.where((n) => n.createdAt.isSameDay(DateTime.now())).toList();
          final earlier = list.where((n) => !n.createdAt.isSameDay(DateTime.now())).toList();
          var index = 0;
          Widget tile(AppNotification n) => _NotificationTile(
            notification: n,
          ).animate().fadeIn(delay: (50 * index++).ms, duration: 300.ms).slideX(begin: .05);
          return RefreshIndicator(
            color: AppColors.primaryGreen,
            onRefresh: () => ref.refresh(notificationsControllerProvider.future),
            child: ListView(
              padding: const EdgeInsets.fromLTRB(AppSpacing.gutter, 4, AppSpacing.gutter, 40),
              children: [
                if (today.isNotEmpty) ...[const _GroupLabel('Today'), for (final n in today) tile(n)],
                if (earlier.isNotEmpty) ...[const _GroupLabel('Earlier'), for (final n in earlier) tile(n)],
              ],
            ),
          );
        },
      ),
    );
  }
}

class _GroupLabel extends StatelessWidget {
  const _GroupLabel(this.label);

  final String label;

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.fromLTRB(4, 16, 4, 10),
    child: Text(
      label.toUpperCase(),
      style: Theme.of(context).textTheme.labelSmall?.copyWith(color: AppColors.textMuted, letterSpacing: 1.4),
    ),
  );
}

class _NotificationTile extends ConsumerWidget {
  const _NotificationTile({required this.notification});

  final AppNotification notification;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final t = Theme.of(context).textTheme;
    final n = notification;
    final (icon, color) = switch (n.type) {
      NotificationType.booking => (Icons.confirmation_number_rounded, AppColors.primaryGreen),
      NotificationType.payment => (Icons.payments_rounded, AppColors.info),
      NotificationType.event => (Icons.celebration_rounded, const Color(0xFF8E5BD0)),
      NotificationType.tournament => (Icons.emoji_events_rounded, AppColors.warning),
      NotificationType.promo => (Icons.local_offer_rounded, AppColors.secondaryDark),
    };
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Pressable(
        onTap: () {
          ref.read(notificationsControllerProvider.notifier).markRead(n.id);
          if (n.deepLink != null) context.push(n.deepLink!);
        },
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: n.read ? AppColors.surface : AppColors.limeSoft.withValues(alpha: .6),
            borderRadius: BorderRadius.circular(AppRadius.md + 2),
            border: Border.all(color: n.read ? AppColors.border : AppColors.accentLime),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 42,
                height: 42,
                decoration: BoxDecoration(color: color.withValues(alpha: .12), borderRadius: BorderRadius.circular(13)),
                child: Icon(icon, color: color, size: 21),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(child: Text(n.title, style: t.titleSmall)),
                        Text(
                          Fmt.relative(n.createdAt),
                          style: t.bodySmall?.copyWith(color: AppColors.textMuted, fontSize: 11),
                        ),
                      ],
                    ),
                    const SizedBox(height: 3),
                    Text(n.body, style: t.bodySmall?.copyWith(color: AppColors.textSecondary)),
                  ],
                ),
              ),
              if (!n.read) ...[
                const SizedBox(width: 8),
                Container(
                  margin: const EdgeInsets.only(top: 6),
                  width: 8,
                  height: 8,
                  decoration: const BoxDecoration(color: AppColors.primaryGreen, shape: BoxShape.circle),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
