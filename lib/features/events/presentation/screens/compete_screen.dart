import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/widgets/common.dart';
import '../../../../core/widgets/pressable.dart';
import '../../../home/presentation/main_shell.dart';
import '../../../tournaments/presentation/providers/tournament_providers.dart';
import '../../../tournaments/presentation/widgets/tournament_card.dart';
import '../../domain/entities/arena_event.dart';
import '../providers/event_providers.dart';
import '../widgets/event_card.dart';

/// "Compete" tab: daily & weekend events plus tournaments.
class CompeteScreen extends StatelessWidget {
  const CompeteScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context).textTheme;
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        body: SafeArea(
          bottom: false,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(AppSpacing.gutter, 16, AppSpacing.gutter, 0),
                child: Text('Compete', style: t.headlineLarge),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(AppSpacing.gutter, 4, AppSpacing.gutter, 16),
                child: Text(
                  'Daily games, weekend mixers and DinoArena tournaments',
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
                      Tab(text: 'Events'),
                      Tab(text: 'Tournaments'),
                    ],
                  ),
                ),
              ),
              const Expanded(child: TabBarView(children: [_EventsTab(), _TournamentsTab()])),
            ],
          ),
        ),
      ),
    );
  }
}

class _EventsTab extends ConsumerStatefulWidget {
  const _EventsTab();

  @override
  ConsumerState<_EventsTab> createState() => _EventsTabState();
}

class _EventsTabState extends ConsumerState<_EventsTab> with AutomaticKeepAliveClientMixin {
  EventCadence? _cadence;

  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final events = ref.watch(eventsProvider);
    return events.when(
      loading: () => ListView.separated(
        padding: const EdgeInsets.all(AppSpacing.gutter),
        itemCount: 3,
        separatorBuilder: (_, _) => const SizedBox(height: 12),
        itemBuilder: (_, _) => const SkeletonBox(height: 170, radius: AppRadius.lg),
      ),
      error: (e, _) => ErrorView(message: e.toString(), onRetry: () => ref.invalidate(eventsProvider)),
      data: (all) {
        final list = _cadence == null ? all : all.where((e) => e.cadence == _cadence).toList();
        return RefreshIndicator(
          color: AppColors.primaryGreen,
          onRefresh: () => ref.refresh(eventsProvider.future),
          child: ListView(
            padding: const EdgeInsets.fromLTRB(AppSpacing.gutter, 16, AppSpacing.gutter, kNavClearance),
            children: [
              Row(
                children: [
                  for (final (label, value) in [
                    ('All', null),
                    ('Daily', EventCadence.daily),
                    ('Weekend', EventCadence.weekend),
                  ])
                    Padding(
                      padding: const EdgeInsets.only(right: 8),
                      child: Pressable(
                        onTap: () => setState(() => _cadence = value),
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 9),
                          decoration: BoxDecoration(
                            color: _cadence == value ? AppColors.primaryDark : AppColors.surface,
                            borderRadius: BorderRadius.circular(100),
                            border: Border.all(color: _cadence == value ? AppColors.primaryDark : AppColors.border),
                          ),
                          child: Text(
                            label,
                            style: Theme.of(context).textTheme.labelMedium?.copyWith(
                              color: _cadence == value ? Colors.white : AppColors.textPrimary,
                            ),
                          ),
                        ),
                      ),
                    ),
                ],
              ),
              const SizedBox(height: 16),
              for (final (i, e) in list.indexed)
                Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: EventCard(event: e)
                      .animate(key: ValueKey('${e.id}$_cadence'))
                      .fadeIn(delay: (60 * i).ms, duration: 350.ms)
                      .slideY(begin: .1, curve: Curves.easeOutCubic),
                ),
            ],
          ),
        );
      },
    );
  }
}

class _TournamentsTab extends ConsumerWidget {
  const _TournamentsTab();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tournaments = ref.watch(tournamentsProvider);
    return tournaments.when(
      loading: () => ListView.separated(
        padding: const EdgeInsets.all(AppSpacing.gutter),
        itemCount: 2,
        separatorBuilder: (_, _) => const SizedBox(height: 12),
        itemBuilder: (_, _) => const SkeletonBox(height: 250, radius: AppRadius.lg),
      ),
      error: (e, _) => ErrorView(message: e.toString(), onRetry: () => ref.invalidate(tournamentsProvider)),
      data: (list) => RefreshIndicator(
        color: AppColors.primaryGreen,
        onRefresh: () => ref.refresh(tournamentsProvider.future),
        child: ListView.separated(
          padding: const EdgeInsets.fromLTRB(AppSpacing.gutter, 16, AppSpacing.gutter, kNavClearance),
          itemCount: list.length,
          separatorBuilder: (_, _) => const SizedBox(height: 14),
          itemBuilder: (_, i) => TournamentCard(
            tournament: list[i],
          ).animate().fadeIn(delay: (70 * i).ms, duration: 350.ms).slideY(begin: .1, curve: Curves.easeOutCubic),
        ),
      ),
    );
  }
}
