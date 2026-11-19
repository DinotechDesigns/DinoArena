import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/router.dart';
import '../../../../core/constants/brand.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/utils/formatters.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/common.dart';
import '../../../../shared/widgets/sport_art.dart';
import '../../../booking/presentation/providers/booking_providers.dart';
import '../../domain/entities/facility.dart';
import '../providers/facility_providers.dart';

class FacilityDetailScreen extends ConsumerWidget {
  const FacilityDetailScreen({super.key, required this.facilityId});

  final String facilityId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final async = ref.watch(facilityProvider(facilityId));
    return async.when(
      loading: () => const Scaffold(
        body: Center(child: CircularProgressIndicator(color: AppColors.primaryGreen)),
      ),
      error: (e, _) => Scaffold(
        appBar: const AppTopBar(title: 'Arena'),
        body: ErrorView(message: e.toString(), onRetry: () => ref.invalidate(facilityProvider(facilityId))),
      ),
      data: (f) => _FacilityDetail(facility: f),
    );
  }
}

class _FacilityDetail extends ConsumerWidget {
  const _FacilityDetail({required this.facility});

  final Facility facility;

  IconData _amenityIcon(String a) {
    final s = a.toLowerCase();
    if (s.contains('light')) return Icons.light_mode_rounded;
    if (s.contains('net')) return Icons.grid_4x4_rounded;
    if (s.contains('chang') || s.contains('locker')) return Icons.checkroom_rounded;
    if (s.contains('water')) return Icons.water_drop_rounded;
    if (s.contains('park')) return Icons.local_parking_rounded;
    if (s.contains('score')) return Icons.scoreboard_rounded;
    if (s.contains('machine')) return Icons.precision_manufacturing_rounded;
    if (s.contains('video')) return Icons.videocam_rounded;
    if (s.contains('racket') || s.contains('shuttle')) return Icons.sports_tennis_rounded;
    if (s.contains('air')) return Icons.air_rounded;
    if (s.contains('seat')) return Icons.event_seat_rounded;
    return Icons.check_circle_outline_rounded;
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final t = Theme.of(context).textTheme;
    final f = facility;
    final topPad = MediaQuery.paddingOf(context).top;

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: AppTheme.darkOverlay,
      child: Scaffold(
        body: CustomScrollView(
          slivers: [
            SliverAppBar(
              expandedHeight: 300,
              pinned: true,
              stretch: true,
              backgroundColor: AppColors.primaryDark,
              systemOverlayStyle: AppTheme.darkOverlay,
              automaticallyImplyLeading: false,
              titleSpacing: 12,
              title: const AppBackButton(onDark: true),
              flexibleSpace: FlexibleSpaceBar(
                stretchModes: const [StretchMode.zoomBackground],
                background: SportArt(
                  sport: f.primarySport,
                  child: Padding(
                    padding: EdgeInsets.fromLTRB(AppSpacing.gutter, topPad + 64, AppSpacing.gutter, 22),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Wrap(
                          spacing: 8,
                          children: [
                            for (final s in f.sports)
                              Pill(
                                label: s.label,
                                icon: s.icon,
                                color: AppColors.primaryDark,
                                background: AppColors.accentLime,
                              ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        Text(
                          f.name,
                          style: t.displaySmall?.copyWith(color: Colors.white),
                        ).animate().fadeIn(duration: 400.ms).slideY(begin: .3, curve: Curves.easeOutCubic),
                        const SizedBox(height: 4),
                        Text(f.headline, style: t.bodyLarge?.copyWith(color: Colors.white70)),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(AppSpacing.gutter, 20, AppSpacing.gutter, 0),
              sliver: SliverList.list(
                children: [
                  _QuickFacts(facility: f),
                  const SizedBox(height: 24),
                  Text('About', style: t.titleLarge),
                  const SizedBox(height: 8),
                  Text(f.description, style: t.bodyMedium?.copyWith(color: AppColors.textSecondary)),
                  const SizedBox(height: 24),
                  Text('Pricing', style: t.titleLarge),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: _PriceTile(
                          label: 'Off-peak',
                          hint: 'Weekdays before 6 PM',
                          price: f.pricePerHour,
                          perUnit: f.hasMultipleUnits,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _PriceTile(
                          label: 'Peak',
                          hint: 'Evenings & weekends',
                          price: f.peakPricePerHour,
                          perUnit: f.hasMultipleUnits,
                          highlight: true,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  Text('Amenities', style: t.titleLarge),
                  const SizedBox(height: 12),
                  Wrap(
                    spacing: 10,
                    runSpacing: 10,
                    children: [
                      for (final a in f.amenities)
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                          decoration: BoxDecoration(
                            color: AppColors.surface,
                            borderRadius: BorderRadius.circular(14),
                            border: Border.all(color: AppColors.border),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(_amenityIcon(a), size: 18, color: AppColors.primaryGreen),
                              const SizedBox(width: 8),
                              Text(a, style: t.labelMedium),
                            ],
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  Text('Good to know', style: t.titleLarge),
                  const SizedBox(height: 10),
                  for (final r in f.rules)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 10),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Padding(
                            padding: EdgeInsets.only(top: 3),
                            child: Icon(Icons.check_rounded, size: 16, color: AppColors.primaryGreen),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Text(r, style: t.bodyMedium?.copyWith(color: AppColors.textSecondary)),
                          ),
                        ],
                      ),
                    ),
                  const SizedBox(height: 12),
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: AppColors.surface,
                      borderRadius: BorderRadius.circular(AppRadius.lg),
                      border: Border.all(color: AppColors.border),
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: 46,
                          height: 46,
                          decoration: BoxDecoration(color: AppColors.limeSoft, borderRadius: BorderRadius.circular(14)),
                          child: const Icon(Icons.place_rounded, color: AppColors.primaryGreen),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('${Brand.name} Sports Hub', style: t.titleSmall),
                              Text(Brand.address, style: t.bodySmall?.copyWith(color: AppColors.textSecondary)),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 120),
                ],
              ),
            ),
          ],
        ),
        bottomNavigationBar: _BookBar(facility: f),
      ),
    );
  }
}

class _QuickFacts extends StatelessWidget {
  const _QuickFacts({required this.facility});

  final Facility facility;

  @override
  Widget build(BuildContext context) {
    final f = facility;
    final close = f.closeHour == 24 ? '12 AM' : '${f.closeHour - 12} PM';
    final items = [
      (Icons.star_rounded, f.rating.toStringAsFixed(1), '${f.reviewCount} reviews'),
      (Icons.schedule_rounded, '${f.openHour} AM', 'to $close'),
      (Icons.straighten_rounded, f.dimensions.split(' ').first, f.surface.split(' ').last),
      (Icons.groups_rounded, '${f.maxPlayers}', f.hasMultipleUnits ? 'per lane' : 'players'),
    ];
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppRadius.lg),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        children: [
          for (final (i, (icon, v, l)) in items.indexed) ...[
            if (i > 0) Container(width: 1, height: 36, color: AppColors.border),
            Expanded(
              child: Column(
                children: [
                  Icon(icon, size: 18, color: AppColors.primaryGreen),
                  const SizedBox(height: 6),
                  Text(v, style: Theme.of(context).textTheme.titleSmall),
                  Text(
                    l,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(color: AppColors.textMuted, fontSize: 11),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    ).animate().fadeIn(duration: 400.ms).slideY(begin: .1);
  }
}

class _PriceTile extends StatelessWidget {
  const _PriceTile({
    required this.label,
    required this.hint,
    required this.price,
    required this.perUnit,
    this.highlight = false,
  });

  final String label;
  final String hint;
  final int price;
  final bool perUnit;
  final bool highlight;

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context).textTheme;
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: highlight ? AppColors.primaryDark : AppColors.surface,
        borderRadius: BorderRadius.circular(AppRadius.lg),
        border: highlight ? null : Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: t.labelMedium?.copyWith(color: highlight ? AppColors.accentLime : AppColors.primaryGreen)),
          const SizedBox(height: 6),
          Text.rich(
            TextSpan(
              children: [
                TextSpan(
                  text: Fmt.money(price),
                  style: t.headlineSmall?.copyWith(color: highlight ? Colors.white : null),
                ),
                TextSpan(
                  text: perUnit ? ' /lane·hr' : ' /hr',
                  style: t.bodySmall?.copyWith(color: highlight ? Colors.white60 : AppColors.textMuted),
                ),
              ],
            ),
          ),
          const SizedBox(height: 4),
          Text(hint, style: t.bodySmall?.copyWith(color: highlight ? Colors.white60 : AppColors.textSecondary)),
        ],
      ),
    );
  }
}

class _BookBar extends ConsumerWidget {
  const _BookBar({required this.facility});

  final Facility facility;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final t = Theme.of(context).textTheme;
    return Container(
      padding: EdgeInsets.fromLTRB(AppSpacing.gutter, 14, AppSpacing.gutter, 14 + MediaQuery.paddingOf(context).bottom),
      decoration: const BoxDecoration(
        color: AppColors.surface,
        border: Border(top: BorderSide(color: AppColors.border)),
      ),
      child: Row(
        children: [
          Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Starting from', style: t.bodySmall?.copyWith(color: AppColors.textMuted)),
              Text.rich(
                TextSpan(
                  children: [
                    TextSpan(text: Fmt.money(facility.pricePerHour), style: t.titleLarge),
                    TextSpan(
                      text: ' /hr',
                      style: t.bodySmall?.copyWith(color: AppColors.textMuted),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(width: 16),
          Expanded(
            child: AppButton(
              label: 'Check live slots',
              icon: Icons.bolt_rounded,
              variant: AppButtonVariant.dark,
              onPressed: () {
                ref.read(bookingDraftProvider.notifier).start(facility);
                context.push(Routes.book(facility.id));
              },
            ),
          ),
        ],
      ),
    );
  }
}
