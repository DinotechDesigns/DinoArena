import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/utils/formatters.dart';
import '../../../../core/widgets/common.dart';
import '../../../../core/widgets/pressable.dart';
import '../../../home/presentation/main_shell.dart';
import '../../domain/entities/booking.dart';
import '../providers/booking_providers.dart';
import '../widgets/booking_status_pill.dart';

class MyBookingsScreen extends ConsumerWidget {
  const MyBookingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final t = Theme.of(context).textTheme;
    final bookings = ref.watch(bookingsControllerProvider);

    return DefaultTabController(
      length: 3,
      child: Scaffold(
        body: SafeArea(
          bottom: false,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(AppSpacing.gutter, 16, AppSpacing.gutter, 0),
                child: Text('My bookings', style: t.headlineLarge),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(AppSpacing.gutter, 4, AppSpacing.gutter, 16),
                child: Text(
                  'Your passes for games, events and tournaments',
                  style: t.bodyMedium?.copyWith(color: AppColors.textSecondary),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: AppSpacing.gutter),
                child: Container(
                  height: 48,
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(color: AppColors.surfaceMuted, borderRadius: BorderRadius.circular(100)),
                  child: const TabBar(
                    tabs: [
                      Tab(text: 'Upcoming'),
                      Tab(text: 'Past'),
                      Tab(text: 'Cancelled'),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 8),
              Expanded(
                child: bookings.when(
                  loading: () => ListView.separated(
                    padding: const EdgeInsets.all(AppSpacing.gutter),
                    itemCount: 3,
                    separatorBuilder: (_, _) => const SizedBox(height: 12),
                    itemBuilder: (_, _) => const SkeletonBox(height: 120, radius: AppRadius.lg),
                  ),
                  error: (e, _) => ErrorView(
                    message: e.toString(),
                    onRetry: () => ref.read(bookingsControllerProvider.notifier).refresh(),
                  ),
                  data: (all) {
                    final upcoming = all.where((b) => b.isUpcoming).toList()
                      ..sort((a, b) => a.start.compareTo(b.start));
                    final past = all.where((b) => b.isPast).toList()..sort((a, b) => b.start.compareTo(a.start));
                    final cancelled = all.where((b) => b.status == BookingStatus.cancelled).toList();
                    return TabBarView(
                      children: [
                        _BookingList(
                          bookings: upcoming,
                          empty: EmptyState(
                            icon: Icons.sports_score_rounded,
                            title: 'No upcoming games',
                            message: 'Your next booking will show up here with its QR pass.',
                            actionLabel: 'Book a slot',
                            onAction: () => context.go(Routes.explore),
                          ),
                        ),
                        _BookingList(
                          bookings: past,
                          empty: const EmptyState(
                            icon: Icons.history_rounded,
                            title: 'No past games yet',
                            message: 'Games you’ve played will be listed here.',
                          ),
                        ),
                        _BookingList(
                          bookings: cancelled,
                          empty: const EmptyState(
                            icon: Icons.event_available_rounded,
                            title: 'Nothing cancelled',
                            message: 'Cancelled bookings and refunds appear here.',
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _BookingList extends ConsumerWidget {
  const _BookingList({required this.bookings, required this.empty});

  final List<Booking> bookings;
  final Widget empty;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return RefreshIndicator(
      color: AppColors.primaryGreen,
      onRefresh: () => ref.read(bookingsControllerProvider.notifier).refresh(),
      child: bookings.isEmpty
          ? LayoutBuilder(
              builder: (context, c) => SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                child: SizedBox(height: c.maxHeight, child: empty),
              ),
            )
          : ListView.separated(
              padding: const EdgeInsets.fromLTRB(AppSpacing.gutter, 12, AppSpacing.gutter, kNavClearance),
              itemCount: bookings.length,
              separatorBuilder: (_, _) => const SizedBox(height: 12),
              itemBuilder: (_, i) => _BookingTile(
                booking: bookings[i],
              ).animate().fadeIn(delay: (60 * i).ms, duration: 350.ms).slideY(begin: .12, curve: Curves.easeOutCubic),
            ),
    );
  }
}

class _BookingTile extends StatelessWidget {
  const _BookingTile({required this.booking});

  final Booking booking;

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context).textTheme;
    final b = booking;
    final dimmed = b.status == BookingStatus.cancelled || b.isPast;
    return Pressable(
      onTap: () => context.push(Routes.pass(b.id)),
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(AppRadius.lg),
          border: Border.all(color: AppColors.border),
        ),
        child: IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Container(
                width: 74,
                decoration: BoxDecoration(
                  color: dimmed ? AppColors.surfaceMuted : AppColors.primaryDark,
                  borderRadius: const BorderRadius.horizontal(left: Radius.circular(AppRadius.lg - 1)),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      Fmt.dayShort(b.start).toUpperCase(),
                      style: t.labelSmall?.copyWith(color: dimmed ? AppColors.textMuted : AppColors.accentLime),
                    ),
                    Text(
                      Fmt.dayNum(b.start),
                      style: t.headlineMedium?.copyWith(color: dimmed ? AppColors.textSecondary : Colors.white),
                    ),
                    Text(
                      Fmt.dateShort(b.start).split(' ').last.toUpperCase(),
                      style: t.labelSmall?.copyWith(color: dimmed ? AppColors.textMuted : Colors.white60),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(14),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(
                            switch (b.kind) {
                              BookingKind.slot => b.sport.icon,
                              BookingKind.event => Icons.celebration_rounded,
                              BookingKind.tournament => Icons.emoji_events_rounded,
                            },
                            size: 16,
                            color: AppColors.primaryGreen,
                          ),
                          const SizedBox(width: 6),
                          Text(switch (b.kind) {
                            BookingKind.slot => 'Slot booking',
                            BookingKind.event => 'Event',
                            BookingKind.tournament => 'Tournament',
                          }, style: t.labelSmall?.copyWith(color: AppColors.primaryGreen)),
                          const Spacer(),
                          BookingStatusPill(booking: b),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Text(b.title, style: t.titleSmall, maxLines: 1, overflow: TextOverflow.ellipsis),
                      const SizedBox(height: 4),
                      Text(
                        '${Fmt.timeRange(b.start, b.end)}${b.unitLabel != null ? ' · ${b.unitLabel}' : ''}',
                        style: t.bodySmall?.copyWith(color: AppColors.textSecondary),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Text(b.code, style: t.labelSmall?.copyWith(color: AppColors.textMuted, letterSpacing: 1)),
                          const Spacer(),
                          Text(Fmt.money(b.amountPaid), style: t.titleSmall),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
