import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/utils/formatters.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/common.dart';
import '../../../../shared/widgets/detail_header.dart';
import '../../../booking/domain/entities/booking.dart';
import '../../../payment/domain/entities/payment.dart';
import '../../../payment/presentation/providers/checkout_providers.dart';
import '../../domain/entities/arena_event.dart';
import '../providers/event_providers.dart';

class EventDetailScreen extends ConsumerWidget {
  const EventDetailScreen({super.key, required this.eventId});

  final String eventId;

  void _join(BuildContext context, WidgetRef ref, ArenaEvent e) {
    ref
        .read(checkoutControllerProvider.notifier)
        .begin(
          CheckoutRequest(
            kind: BookingKind.event,
            title: e.title,
            subtitle: '${Fmt.date(e.start)} · ${Fmt.timeRange(e.start, e.end)} · ${e.venue}',
            venue: e.venue,
            sport: e.sport,
            start: e.start,
            end: e.end,
            referenceId: e.id,
            lineItems: [LineItem(label: 'Entry · 1 player (incl. taxes)', amount: e.fee)],
            total: e.fee,
          ),
        );
    context.push(Routes.checkout);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final t = Theme.of(context).textTheme;
    return ref
        .watch(eventProvider(eventId))
        .when(
          loading: () => const Scaffold(
            body: Center(child: CircularProgressIndicator(color: AppColors.primaryGreen)),
          ),
          error: (e, _) => Scaffold(
            appBar: const AppTopBar(title: 'Event'),
            body: ErrorView(message: e.toString()),
          ),
          data: (e) => Scaffold(
            body: CustomScrollView(
              slivers: [
                DetailSliverHeader(
                  sport: e.sport,
                  title: e.title,
                  subtitle: e.subtitle,
                  pills: [
                    Pill(
                      label: e.cadence == EventCadence.weekend ? 'WEEKEND EVENT' : 'DAILY EVENT',
                      color: AppColors.primaryDark,
                      background: AppColors.accentLime,
                    ),
                    Pill(label: e.level, color: Colors.white, background: Colors.white.withValues(alpha: .15)),
                  ],
                ),
                SliverPadding(
                  padding: const EdgeInsets.fromLTRB(AppSpacing.gutter, 20, AppSpacing.gutter, 40),
                  sliver: SliverList.list(
                    children: [
                      FactGrid(
                        facts: [
                          (Icons.event_rounded, 'Date', Fmt.date(e.start)),
                          (Icons.schedule_rounded, 'Time', Fmt.timeRange(e.start, e.end)),
                          (Icons.place_rounded, 'Venue', e.venue),
                          (e.sport.icon, 'Sport', e.sport.label),
                        ],
                      ),
                      const SizedBox(height: 20),
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: AppColors.surface,
                          borderRadius: BorderRadius.circular(AppRadius.lg),
                          border: Border.all(color: AppColors.border),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Text('${e.registered} going', style: t.titleSmall),
                                const Spacer(),
                                Text(
                                  e.isFull ? 'Fully booked' : '${e.spotsLeft} of ${e.capacity} spots left',
                                  style: t.labelMedium?.copyWith(
                                    color: e.isFull ? AppColors.warning : AppColors.primaryGreen,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 10),
                            TweenAnimationBuilder<double>(
                              tween: Tween(begin: 0, end: e.fillRatio),
                              duration: const Duration(milliseconds: 900),
                              curve: Curves.easeOutCubic,
                              builder: (_, v, _) => ClipRRect(
                                borderRadius: BorderRadius.circular(6),
                                child: LinearProgressIndicator(
                                  value: v,
                                  minHeight: 8,
                                  backgroundColor: AppColors.surfaceMuted,
                                  color: e.isFull ? AppColors.warning : AppColors.primaryGreen,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 24),
                      Text('About this event', style: t.titleLarge),
                      const SizedBox(height: 8),
                      Text(e.description, style: t.bodyMedium?.copyWith(color: AppColors.textSecondary)),
                      const SizedBox(height: 24),
                      Text('What’s included', style: t.titleLarge),
                      const SizedBox(height: 12),
                      BulletList(items: e.highlights, icon: Icons.bolt_rounded),
                    ],
                  ),
                ),
              ],
            ),
            bottomNavigationBar: BottomActionBar(
              leading: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Per player', style: t.bodySmall?.copyWith(color: AppColors.textMuted)),
                  Text(Fmt.money(e.fee), style: t.titleLarge),
                ],
              ),
              child: e.isFull
                  ? AppButton(
                      label: 'Join waitlist',
                      variant: AppButtonVariant.outline,
                      icon: Icons.notifications_active_outlined,
                      onPressed: () => showAppSnack(
                        context,
                        'You’re on the waitlist. We’ll notify you if a spot opens.',
                        icon: Icons.notifications_active_rounded,
                      ),
                    )
                  : AppButton(label: 'Join event', icon: Icons.bolt_rounded, onPressed: () => _join(context, ref, e)),
            ),
          ),
        );
  }
}
