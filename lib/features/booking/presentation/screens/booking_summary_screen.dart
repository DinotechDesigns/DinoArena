import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/utils/formatters.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/common.dart';
import '../../../../shared/widgets/sport_art.dart';
import '../../../payment/domain/entities/payment.dart';
import '../../../payment/presentation/providers/checkout_providers.dart';
import '../../data/booking_repository_impl.dart';
import '../../domain/entities/booking.dart';
import '../../domain/pricing.dart';
import '../providers/booking_providers.dart';

class BookingSummaryScreen extends ConsumerStatefulWidget {
  const BookingSummaryScreen({super.key});

  @override
  ConsumerState<BookingSummaryScreen> createState() => _BookingSummaryScreenState();
}

class _BookingSummaryScreenState extends ConsumerState<BookingSummaryScreen> {
  final _coupon = TextEditingController();
  String? _couponError;

  @override
  void dispose() {
    _coupon.dispose();
    super.dispose();
  }

  void _applyCoupon() {
    final ok = ref.read(bookingDraftProvider.notifier).applyCoupon(_coupon.text);
    setState(() => _couponError = ok ? null : 'That code isn’t valid. Try DINO10.');
    if (ok) FocusScope.of(context).unfocus();
  }

  void _proceed(BookingDraft draft) {
    final f = draft.facility!;
    final slots = draft.sortedSlots;
    final price = draft.price;
    final sport = draft.sport ?? f.primarySport;
    ref
        .read(checkoutControllerProvider.notifier)
        .begin(
          CheckoutRequest(
            kind: BookingKind.slot,
            title: '${sport.label} · ${f.name}',
            subtitle: '${Fmt.date(draft.date)} · ${draft.slotLabels.join(', ')}',
            venue: f.name,
            sport: sport,
            start: slots.first.start,
            end: slots.last.end,
            players: draft.players,
            unitLabel: unitName(f, draft.unit),
            referenceId: f.id,
            slotIds: [for (final s in slots) s.id],
            slotLabels: draft.slotLabels,
            lineItems: [
              LineItem(label: '${draft.hours} × 1 hr slot', amount: price.subtotal),
              if (price.discount > 0) LineItem(label: 'Coupon ${price.couponCode}', amount: -price.discount),
              LineItem(label: 'GST (18%)', amount: price.tax),
            ],
            total: price.total,
          ),
        );
    context.push(Routes.checkout);
  }

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context).textTheme;
    final draft = ref.watch(bookingDraftProvider);
    final f = draft.facility;
    if (f == null || !draft.hasSelection) {
      return Scaffold(
        appBar: const AppTopBar(title: 'Booking summary'),
        body: EmptyState(
          icon: Icons.event_busy_rounded,
          title: 'No slots selected',
          message: 'Pick one or more slots to see your summary.',
          actionLabel: 'Back to slots',
          onAction: () => context.pop(),
        ),
      );
    }
    final price = draft.price;
    final sport = draft.sport ?? f.primarySport;

    return Scaffold(
      appBar: const AppTopBar(title: 'Booking summary'),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(AppSpacing.gutter, 8, AppSpacing.gutter, 140),
        children: [
          // Venue card
          Container(
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(AppRadius.lg),
              border: Border.all(color: AppColors.border),
            ),
            child: Row(
              children: [
                SizedBox(
                  width: 96,
                  height: 104,
                  child: SportArt(
                    sport: sport,
                    borderRadius: const BorderRadius.horizontal(left: Radius.circular(AppRadius.lg - 1)),
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Pill(label: sport.label, icon: sport.icon, dense: true),
                      const SizedBox(height: 6),
                      Text(f.name, style: t.titleMedium),
                      Text(
                        '${unitName(f, draft.unit)} · ${f.headline}',
                        style: t.bodySmall?.copyWith(color: AppColors.textSecondary),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 10),
              ],
            ),
          ).animate().fadeIn(duration: 350.ms).slideY(begin: .1),
          const SizedBox(height: 16),
          _Card(
            title: 'When',
            trailing: TextButton(onPressed: () => context.pop(), child: const Text('Edit')),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Icon(Icons.event_rounded, size: 18, color: AppColors.primaryGreen),
                    const SizedBox(width: 8),
                    Text(Fmt.dateLong(draft.date), style: t.labelLarge),
                  ],
                ),
                const SizedBox(height: 12),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    for (final s in draft.sortedSlots)
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                        decoration: BoxDecoration(
                          color: AppColors.primaryDark,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(Fmt.timeRange(s.start, s.end), style: t.labelMedium?.copyWith(color: Colors.white)),
                            if (s.isPeak) ...[
                              const SizedBox(width: 6),
                              const Icon(Icons.bolt_rounded, size: 14, color: AppColors.accentLime),
                            ],
                          ],
                        ),
                      ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          _Card(
            title: 'Players',
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    'Up to ${f.maxPlayers} ${f.hasMultipleUnits ? 'per lane' : 'on ${f.unitLabel.toLowerCase()}'}',
                    style: t.bodyMedium?.copyWith(color: AppColors.textSecondary),
                  ),
                ),
                _Stepper(
                  value: draft.players,
                  onChanged: ref.read(bookingDraftProvider.notifier).setPlayers,
                  min: 1,
                  max: f.maxPlayers,
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          _Card(
            title: 'Offers',
            child: price.couponCode != null
                ? Row(
                    children: [
                      const Icon(Icons.local_offer_rounded, color: AppColors.primaryGreen),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          '${price.couponCode} applied · you save ${Fmt.money(price.discount)}',
                          style: t.labelLarge,
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          _coupon.clear();
                          ref.read(bookingDraftProvider.notifier).removeCoupon();
                        },
                        child: const Text('Remove'),
                      ),
                    ],
                  ).animate().fadeIn().scale(begin: const Offset(.97, .97))
                : Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: TextField(
                          controller: _coupon,
                          textCapitalization: TextCapitalization.characters,
                          onSubmitted: (_) => _applyCoupon(),
                          decoration: InputDecoration(
                            hintText: 'Coupon code',
                            errorText: _couponError,
                            prefixIcon: const Icon(Icons.local_offer_outlined),
                            isDense: true,
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      SizedBox(
                        width: 92,
                        child: AppButton(
                          label: 'Apply',
                          height: 52,
                          variant: AppButtonVariant.outline,
                          onPressed: _applyCoupon,
                        ),
                      ),
                    ],
                  ),
          ),
          const SizedBox(height: 16),
          _Card(
            title: 'Price details',
            child: Column(
              children: [
                InfoRow(label: '${draft.hours} × 1 hr slot', value: Fmt.money(price.subtotal)),
                if (price.discount > 0)
                  InfoRow(
                    label: 'Coupon discount',
                    value: '– ${Fmt.money(price.discount)}',
                    valueColor: AppColors.primaryGreen,
                  ),
                InfoRow(label: 'GST (${(PriceBreakdown.gstRate * 100).round()}%)', value: Fmt.money(price.tax)),
                const Padding(padding: EdgeInsets.symmetric(vertical: 8), child: DashedLine()),
                InfoRow(label: 'Total payable', value: Fmt.money(price.total), bold: true),
              ],
            ),
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(color: AppColors.limeSoft, borderRadius: BorderRadius.circular(AppRadius.md)),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Icon(Icons.verified_user_rounded, color: AppColors.primaryGreen, size: 20),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    'Free cancellation up to 2 hours before your slot. Refunds go back to your original payment method.',
                    style: t.bodySmall?.copyWith(color: AppColors.secondaryDark),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: Container(
        padding: EdgeInsets.fromLTRB(
          AppSpacing.gutter,
          14,
          AppSpacing.gutter,
          14 + MediaQuery.paddingOf(context).bottom,
        ),
        decoration: const BoxDecoration(
          color: AppColors.surface,
          border: Border(top: BorderSide(color: AppColors.border)),
        ),
        child: AppButton(
          label: 'Proceed to pay ${Fmt.money(price.total)}',
          icon: Icons.lock_rounded,
          onPressed: () => _proceed(draft),
        ),
      ),
    );
  }
}

class _Card extends StatelessWidget {
  const _Card({required this.title, required this.child, this.trailing});

  final String title;
  final Widget child;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppRadius.lg),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: 36,
            child: Row(
              children: [
                Expanded(child: Text(title, style: Theme.of(context).textTheme.titleSmall)),
                ?trailing,
              ],
            ),
          ),
          const SizedBox(height: 6),
          child,
        ],
      ),
    );
  }
}

class _Stepper extends StatelessWidget {
  const _Stepper({required this.value, required this.onChanged, required this.min, required this.max});

  final int value;
  final ValueChanged<int> onChanged;
  final int min;
  final int max;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(color: AppColors.surfaceMuted, borderRadius: BorderRadius.circular(100)),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          IconButton(
            tooltip: 'Fewer players',
            onPressed: value > min ? () => onChanged(value - 1) : null,
            icon: const Icon(Icons.remove_rounded),
          ),
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 200),
            transitionBuilder: (c, a) => ScaleTransition(scale: a, child: c),
            child: SizedBox(
              key: ValueKey(value),
              width: 28,
              child: Text('$value', textAlign: TextAlign.center, style: Theme.of(context).textTheme.titleMedium),
            ),
          ),
          IconButton(
            tooltip: 'More players',
            onPressed: value < max ? () => onChanged(value + 1) : null,
            icon: const Icon(Icons.add_rounded),
          ),
        ],
      ),
    );
  }
}
