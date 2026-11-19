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
import '../../../../shared/widgets/detail_header.dart';
import '../../domain/entities/tournament.dart';
import '../providers/tournament_providers.dart';
import '../widgets/tournament_card.dart';

class TournamentDetailScreen extends ConsumerWidget {
  const TournamentDetailScreen({super.key, required this.tournamentId});

  final String tournamentId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final t = Theme.of(context).textTheme;
    return ref
        .watch(tournamentProvider(tournamentId))
        .when(
          loading: () => const Scaffold(
            body: Center(child: CircularProgressIndicator(color: AppColors.primaryGreen)),
          ),
          error: (e, _) => Scaffold(
            appBar: const AppTopBar(title: 'Tournament'),
            body: ErrorView(message: e.toString()),
          ),
          data: (tr) {
            final (label, color) = tr.status.badge;
            return Scaffold(
              body: CustomScrollView(
                slivers: [
                  DetailSliverHeader(
                    sport: tr.sport,
                    title: tr.name,
                    subtitle: tr.tagline,
                    pills: [
                      Pill(label: label, color: color, background: Colors.black.withValues(alpha: .35)),
                      Pill(
                        label: tr.sport.label,
                        icon: tr.sport.icon,
                        color: AppColors.primaryDark,
                        background: AppColors.accentLime,
                      ),
                    ],
                  ),
                  SliverPadding(
                    padding: const EdgeInsets.fromLTRB(AppSpacing.gutter, 20, AppSpacing.gutter, 40),
                    sliver: SliverList.list(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            gradient: AppColors.limeGradient,
                            borderRadius: BorderRadius.circular(AppRadius.lg),
                          ),
                          child: Row(
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'PRIZE POOL',
                                      style: t.labelSmall?.copyWith(color: AppColors.secondaryDark, letterSpacing: 2),
                                    ),
                                    TweenAnimationBuilder<double>(
                                      tween: Tween(begin: 0, end: tr.prizePool.toDouble()),
                                      duration: const Duration(milliseconds: 1100),
                                      curve: Curves.easeOutCubic,
                                      builder: (_, v, _) => Text(
                                        Fmt.money(v.round()),
                                        style: t.displaySmall?.copyWith(color: AppColors.primaryDark),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const Icon(
                                Icons.emoji_events_rounded,
                                size: 56,
                                color: AppColors.primaryDark,
                              ).animate().scale(curve: Curves.easeOutBack, duration: 600.ms),
                            ],
                          ),
                        ),
                        const SizedBox(height: 16),
                        FactGrid(
                          facts: [
                            (
                              Icons.event_rounded,
                              'Dates',
                              '${Fmt.dateShort(tr.startDate)} – ${Fmt.dateShort(tr.endDate)}',
                            ),
                            (Icons.account_tree_rounded, 'Format', tr.format),
                            (
                              Icons.groups_rounded,
                              'Squad size',
                              tr.teamSize == 1 ? 'Individual' : '${tr.teamSize} players',
                            ),
                            (
                              Icons.payments_rounded,
                              'Entry fee',
                              '${Fmt.money(tr.entryFee)} ${tr.teamSize == 1 ? '' : '/ team'}',
                            ),
                            (Icons.how_to_reg_rounded, 'Entries close', Fmt.date(tr.registrationCloses)),
                            (Icons.leaderboard_rounded, 'Teams', '${tr.registeredTeams} of ${tr.maxTeams}'),
                          ],
                        ),
                        const SizedBox(height: 24),
                        Text('Prizes', style: t.titleLarge),
                        const SizedBox(height: 12),
                        BulletList(items: tr.prizes, icon: Icons.military_tech_rounded),
                        const SizedBox(height: 16),
                        Text('Rules', style: t.titleLarge),
                        const SizedBox(height: 12),
                        BulletList(items: tr.rules, icon: Icons.rule_rounded),
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
                    Text('${tr.slotsLeft} spots left', style: t.bodySmall?.copyWith(color: AppColors.textMuted)),
                    Text(Fmt.money(tr.entryFee), style: t.titleLarge),
                  ],
                ),
                child: AppButton(
                  label: switch (tr.status) {
                    TournamentStatus.live => 'Tournament in progress',
                    TournamentStatus.full => 'Registrations full',
                    _ => tr.teamSize == 1 ? 'Register now' : 'Register team',
                  },
                  icon: tr.canRegister ? Icons.how_to_reg_rounded : null,
                  variant: AppButtonVariant.dark,
                  onPressed: tr.canRegister ? () => context.push(Routes.tournamentRegister(tr.id)) : null,
                ),
              ),
            );
          },
        );
  }
}
