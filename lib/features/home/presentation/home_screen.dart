import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../app/router.dart';
import '../../../core/constants/brand.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/utils/formatters.dart';
import '../../../core/widgets/app_button.dart';
import '../../../core/widgets/common.dart';
import '../../../core/widgets/dinoarena_logo.dart';
import '../../../core/widgets/pressable.dart';
import '../../../shared/domain/sport_type.dart';
import '../../auth/presentation/providers/auth_providers.dart';
import '../../booking/domain/entities/booking.dart';
import '../../booking/presentation/providers/booking_providers.dart';
import '../../events/presentation/providers/event_providers.dart';
import '../../events/presentation/widgets/event_card.dart';
import '../../facilities/presentation/providers/facility_providers.dart';
import '../../facilities/presentation/widgets/facility_card.dart';
import '../../notifications/presentation/providers/notification_providers.dart';
import '../../tournaments/domain/entities/tournament.dart';
import '../../tournaments/presentation/providers/tournament_providers.dart';
import 'main_shell.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: AppTheme.darkOverlay,
      child: Scaffold(
        body: RefreshIndicator(
          color: AppColors.primaryGreen,
          onRefresh: () async {
            ref.invalidate(facilitiesProvider);
            ref.invalidate(eventsProvider);
            ref.invalidate(tournamentsProvider);
            await ref.read(bookingsControllerProvider.notifier).refresh();
          },
          child: CustomScrollView(
            slivers: [
              const SliverToBoxAdapter(child: _HomeHeader()),
              const SliverPadding(
                padding: EdgeInsets.fromLTRB(AppSpacing.gutter, 28, AppSpacing.gutter, 0),
                sliver: SliverToBoxAdapter(
                  child: SectionHeader(title: 'Choose your game', subtitle: 'Three arenas, four ways to play'),
                ),
              ),
              const SliverToBoxAdapter(child: _SportPicker()),
              SliverPadding(
                padding: const EdgeInsets.fromLTRB(AppSpacing.gutter, 30, AppSpacing.gutter, 14),
                sliver: SliverToBoxAdapter(
                  child: SectionHeader(
                    title: 'Our arenas',
                    action: 'See all',
                    onAction: () => context.go(Routes.explore),
                  ),
                ),
              ),
              const SliverToBoxAdapter(child: _ArenasRail()),
              SliverPadding(
                padding: const EdgeInsets.fromLTRB(AppSpacing.gutter, 30, AppSpacing.gutter, 14),
                sliver: SliverToBoxAdapter(
                  child: SectionHeader(
                    title: 'Daily & weekend events',
                    action: 'All events',
                    onAction: () => context.go(Routes.compete),
                  ),
                ),
              ),
              const SliverToBoxAdapter(child: _EventsRail()),
              const SliverPadding(
                padding: EdgeInsets.fromLTRB(AppSpacing.gutter, 30, AppSpacing.gutter, 0),
                sliver: SliverToBoxAdapter(child: _TournamentBanner()),
              ),
              const SliverToBoxAdapter(child: _BrandFooter()),
              const SliverToBoxAdapter(child: SizedBox(height: kNavClearance)),
            ],
          ),
        ),
      ),
    );
  }
}

class _HomeHeader extends ConsumerWidget {
  const _HomeHeader();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final t = Theme.of(context).textTheme;
    final user = ref.watch(authControllerProvider).user;
    final unread = ref.watch(unreadCountProvider);
    final next = ref.watch(nextBookingProvider);

    return Container(
      decoration: const BoxDecoration(
        gradient: AppColors.heroGradient,
        borderRadius: BorderRadius.vertical(bottom: Radius.circular(AppRadius.xl + 4)),
      ),
      padding: EdgeInsets.fromLTRB(AppSpacing.gutter, MediaQuery.paddingOf(context).top + 12, AppSpacing.gutter, 22),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const DinoArenaMark(size: 40),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(Fmt.greeting(), style: t.bodySmall?.copyWith(color: Colors.white60)),
                    Text(
                      user?.firstName ?? 'Player',
                      style: t.titleLarge?.copyWith(color: Colors.white),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              CircleIconButton(
                icon: Icons.notifications_none_rounded,
                tooltip: 'Notifications',
                background: Colors.white.withValues(alpha: .1),
                foreground: Colors.white,
                badge: unread,
                onTap: () => context.push(Routes.notifications),
              ),
            ],
          ).animate().fadeIn(duration: 400.ms),
          const SizedBox(height: 22),
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 400),
            child: next == null ? const _PromoHero() : _NextGameHero(booking: next),
          ),
        ],
      ),
    );
  }
}

class _NextGameHero extends StatelessWidget {
  const _NextGameHero({required this.booking});

  final Booking booking;

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context).textTheme;
    return Pressable(
      onTap: () => context.push(Routes.pass(booking.id)),
      child: Container(
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: .07),
          borderRadius: BorderRadius.circular(AppRadius.lg),
          border: Border.all(color: Colors.white12),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const LiveDot(),
                const SizedBox(width: 6),
                Text('YOUR NEXT GAME', style: t.labelSmall?.copyWith(color: AppColors.accentLime, letterSpacing: 1.6)),
                const Spacer(),
                StreamBuilder<int>(
                  stream: Stream.periodic(const Duration(seconds: 30), (i) => i),
                  builder: (context, _) => Pill(
                    label: _countdown(booking.start),
                    color: AppColors.primaryDark,
                    background: AppColors.accentLime,
                    dense: true,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 14),
            Row(
              children: [
                Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(color: AppColors.accentLime, borderRadius: BorderRadius.circular(16)),
                  child: Icon(booking.sport.icon, color: AppColors.primaryDark),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        booking.title,
                        style: t.titleMedium?.copyWith(color: Colors.white),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 3),
                      Text(
                        '${Fmt.date(booking.start)} · ${Fmt.timeRange(booking.start, booking.end)}',
                        style: t.bodySmall?.copyWith(color: Colors.white70),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(14)),
                  child: const Icon(Icons.qr_code_2_rounded, color: AppColors.primaryDark),
                ),
              ],
            ),
          ],
        ),
      ),
    ).animate().fadeIn(delay: 100.ms, duration: 450.ms).slideY(begin: .15, curve: Curves.easeOutCubic);
  }

  static String _countdown(DateTime start) {
    final d = start.difference(DateTime.now());
    if (d.isNegative) return 'Now';
    if (d.inDays > 0) return 'in ${d.inDays}d ${d.inHours % 24}h';
    if (d.inHours > 0) return 'in ${d.inHours}h ${d.inMinutes % 60}m';
    return 'in ${d.inMinutes}m';
  }
}

class _PromoHero extends StatelessWidget {
  const _PromoHero();

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context).textTheme;
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(gradient: AppColors.limeGradient, borderRadius: BorderRadius.circular(AppRadius.lg)),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Floodlights are on.', style: t.headlineSmall?.copyWith(color: AppColors.primaryDark)),
                const SizedBox(height: 6),
                Text(
                  'Use DINO10 for 10% off your first booking.',
                  style: t.bodySmall?.copyWith(color: AppColors.secondaryDark),
                ),
                const SizedBox(height: 14),
                AppButton(
                  label: 'Book a slot',
                  expand: false,
                  height: 44,
                  trailingIcon: Icons.arrow_forward_rounded,
                  onPressed: () => context.go(Routes.explore),
                ),
              ],
            ),
          ),
          const Icon(Icons.sports_cricket_rounded, size: 84, color: AppColors.primaryDark)
              .animate(onPlay: (c) => c.repeat(reverse: true))
              .rotate(begin: -.02, end: .03, duration: 1600.ms, curve: Curves.easeInOut),
        ],
      ),
    ).animate().fadeIn(delay: 100.ms, duration: 450.ms).slideY(begin: .15, curve: Curves.easeOutCubic);
  }
}

class _SportPicker extends ConsumerWidget {
  const _SportPicker();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final t = Theme.of(context).textTheme;
    return Padding(
      padding: const EdgeInsets.fromLTRB(AppSpacing.gutter, 14, AppSpacing.gutter, 0),
      child: Row(
        children: [
          for (final (i, s) in SportType.values.indexed) ...[
            if (i > 0) const SizedBox(width: 10),
            Expanded(
              child: Pressable(
                onTap: () {
                  ref.read(facilitySportFilterProvider.notifier).select(s);
                  context.go(Routes.explore);
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  decoration: BoxDecoration(
                    color: AppColors.surface,
                    borderRadius: BorderRadius.circular(AppRadius.md + 2),
                    border: Border.all(color: AppColors.border),
                  ),
                  child: Column(
                    children: [
                      Container(
                        width: 44,
                        height: 44,
                        decoration: BoxDecoration(color: s.tint.withValues(alpha: .12), shape: BoxShape.circle),
                        child: Icon(s.icon, color: s.tint, size: 22),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        s == SportType.cricket ? 'Cricket' : (s == SportType.cricketNets ? 'Nets' : s.label),
                        style: t.labelMedium,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              ).animate().fadeIn(delay: (80 * i).ms).slideY(begin: .3, curve: Curves.easeOutCubic),
            ),
          ],
        ],
      ),
    );
  }
}

class _ArenasRail extends ConsumerWidget {
  const _ArenasRail();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final facilities = ref.watch(facilitiesProvider);
    return SizedBox(
      height: 238,
      child: facilities.when(
        loading: () => ListView.separated(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.gutter),
          itemCount: 3,
          separatorBuilder: (_, _) => const SizedBox(width: 14),
          itemBuilder: (_, _) => const SkeletonBox(width: 240, height: 238, radius: AppRadius.lg),
        ),
        error: (e, _) => ErrorView(message: e.toString(), onRetry: () => ref.invalidate(facilitiesProvider)),
        data: (list) => ListView.separated(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.gutter),
          itemCount: list.length,
          separatorBuilder: (_, _) => const SizedBox(width: 14),
          itemBuilder: (_, i) => SizedBox(
            width: 240,
            child: FacilityCard(facility: list[i], compact: true),
          ).animate().fadeIn(delay: (90 * i).ms, duration: 400.ms).slideX(begin: .15, curve: Curves.easeOutCubic),
        ),
      ),
    );
  }
}

class _EventsRail extends ConsumerWidget {
  const _EventsRail();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final events = ref.watch(eventsProvider);
    return SizedBox(
      height: 186,
      child: events.when(
        loading: () => ListView.separated(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.gutter),
          itemCount: 2,
          separatorBuilder: (_, _) => const SizedBox(width: 14),
          itemBuilder: (_, _) => const SkeletonBox(width: 280, height: 186, radius: AppRadius.lg),
        ),
        error: (e, _) => ErrorView(message: e.toString(), onRetry: () => ref.invalidate(eventsProvider)),
        data: (list) => ListView.separated(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.gutter),
          itemCount: list.length,
          separatorBuilder: (_, _) => const SizedBox(width: 14),
          itemBuilder: (_, i) => EventCard(
            event: list[i],
            width: 280,
          ).animate().fadeIn(delay: (90 * i).ms, duration: 400.ms).slideX(begin: .15, curve: Curves.easeOutCubic),
        ),
      ),
    );
  }
}

class _TournamentBanner extends ConsumerWidget {
  const _TournamentBanner();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final t = Theme.of(context).textTheme;
    final featured = ref
        .watch(tournamentsProvider)
        .value
        ?.where((x) => x.status == TournamentStatus.open || x.status == TournamentStatus.closingSoon)
        .fold<Tournament?>(null, (best, x) => best == null || x.prizePool > best.prizePool ? x : best);
    if (featured == null) return const SizedBox.shrink();

    return Pressable(
      onTap: () => context.push(Routes.tournament(featured.id)),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(gradient: AppColors.darkGradient, borderRadius: BorderRadius.circular(AppRadius.lg)),
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            Positioned(
              right: -10,
              top: -6,
              child: Icon(Icons.emoji_events_rounded, size: 110, color: AppColors.accentLime.withValues(alpha: .14)),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('COMPETE.', style: t.labelSmall?.copyWith(color: AppColors.accentLime, letterSpacing: 3)),
                const SizedBox(height: 8),
                Text(featured.name, style: t.headlineSmall?.copyWith(color: Colors.white)),
                const SizedBox(height: 4),
                Text(
                  '${Fmt.money(featured.prizePool)} prize pool · ${featured.slotsLeft} team spots left',
                  style: t.bodySmall?.copyWith(color: Colors.white70),
                ),
                const SizedBox(height: 16),
                AppButton(
                  label: 'Register your team',
                  variant: AppButtonVariant.lime,
                  height: 46,
                  expand: false,
                  trailingIcon: Icons.arrow_forward_rounded,
                  onPressed: () => context.push(Routes.tournament(featured.id)),
                ),
              ],
            ),
          ],
        ),
      ),
    ).animate().fadeIn(duration: 500.ms);
  }
}

class _BrandFooter extends StatelessWidget {
  const _BrandFooter();

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context).textTheme;
    return Padding(
      padding: const EdgeInsets.fromLTRB(AppSpacing.gutter, 40, AppSpacing.gutter, 8),
      child: Column(
        children: [
          const Opacity(opacity: .9, child: DinoArenaMark(size: 36, tone: LogoTone.onLight, withBackground: false)),
          const SizedBox(height: 10),
          Text(Brand.tagline, style: t.labelSmall?.copyWith(color: AppColors.textMuted, letterSpacing: 3)),
        ],
      ),
    );
  }
}
