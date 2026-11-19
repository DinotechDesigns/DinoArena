import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/utils/formatters.dart';
import '../../../../core/widgets/common.dart';
import '../../../../core/widgets/pressable.dart';
import '../../../../shared/widgets/sport_art.dart';
import '../../domain/entities/tournament.dart';

extension TournamentStatusUi on TournamentStatus {
  (String, Color) get badge => switch (this) {
    TournamentStatus.open => ('Registrations open', AppColors.accentLime),
    TournamentStatus.closingSoon => ('Closing soon', AppColors.warning),
    TournamentStatus.full => ('Full', Colors.white70),
    TournamentStatus.live => ('Live now', const Color(0xFFFF6B6B)),
  };
}

class TournamentCard extends StatelessWidget {
  const TournamentCard({super.key, required this.tournament});

  final Tournament tournament;

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context).textTheme;
    final tr = tournament;
    final (label, color) = tr.status.badge;
    return Pressable(
      onTap: () => context.push(Routes.tournament(tr.id)),
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(AppRadius.lg),
          border: Border.all(color: AppColors.border),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SizedBox(
              height: 132,
              child: SportArt(
                sport: tr.sport,
                borderRadius: const BorderRadius.vertical(top: Radius.circular(AppRadius.lg - 1)),
                child: Padding(
                  padding: const EdgeInsets.all(14),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Pill(
                            label: label,
                            color: color,
                            background: Colors.black.withValues(alpha: .35),
                            icon: tr.status == TournamentStatus.live ? Icons.circle : null,
                            dense: true,
                          ),
                          const Spacer(),
                          const Icon(Icons.emoji_events_rounded, color: AppColors.accentLime, size: 22),
                        ],
                      ),
                      const Spacer(),
                      Text('PRIZE POOL', style: t.labelSmall?.copyWith(color: Colors.white60, letterSpacing: 1.5)),
                      Text(Fmt.money(tr.prizePool), style: t.headlineSmall?.copyWith(color: Colors.white)),
                    ],
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(14),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(tr.name, style: t.titleMedium),
                  const SizedBox(height: 2),
                  Text(tr.tagline, style: t.bodySmall?.copyWith(color: AppColors.textSecondary)),
                  const SizedBox(height: 12),
                  Wrap(
                    spacing: 14,
                    runSpacing: 6,
                    children: [
                      _meta(context, Icons.event_rounded, Fmt.dateShort(tr.startDate)),
                      _meta(context, Icons.groups_rounded, '${tr.registeredTeams}/${tr.maxTeams} teams'),
                      _meta(context, Icons.payments_outlined, '${Fmt.money(tr.entryFee)} entry'),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _meta(BuildContext context, IconData icon, String text) => Row(
    mainAxisSize: MainAxisSize.min,
    children: [
      Icon(icon, size: 15, color: AppColors.primaryGreen),
      const SizedBox(width: 4),
      Text(text, style: Theme.of(context).textTheme.labelMedium),
    ],
  );
}
