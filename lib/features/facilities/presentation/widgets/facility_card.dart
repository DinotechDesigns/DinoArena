import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/utils/formatters.dart';
import '../../../../core/widgets/common.dart';
import '../../../../core/widgets/pressable.dart';
import '../../../../shared/widgets/sport_art.dart';
import '../../domain/entities/facility.dart';

class FacilityCard extends StatelessWidget {
  const FacilityCard({super.key, required this.facility, this.compact = false});

  final Facility facility;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context).textTheme;
    final f = facility;
    return Pressable(
      onTap: () => context.push(Routes.facility(f.id)),
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(AppRadius.lg),
          border: Border.all(color: AppColors.border),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: compact ? 128 : 168,
              child: SportArt(
                sport: f.primarySport,
                borderRadius: const BorderRadius.vertical(top: Radius.circular(AppRadius.lg - 1)),
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          if (f.badge != null)
                            Pill(
                              label: f.badge!,
                              color: AppColors.primaryDark,
                              background: AppColors.accentLime,
                              dense: true,
                            ),
                          const Spacer(),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              color: Colors.black.withValues(alpha: .35),
                              borderRadius: BorderRadius.circular(100),
                            ),
                            child: Row(
                              children: [
                                const Icon(Icons.star_rounded, size: 14, color: AppColors.accentLime),
                                const SizedBox(width: 3),
                                Text(f.rating.toStringAsFixed(1), style: t.labelSmall?.copyWith(color: Colors.white)),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const Spacer(),
                      Wrap(
                        spacing: 6,
                        children: [
                          for (final s in f.sports)
                            Container(
                              padding: const EdgeInsets.all(6),
                              decoration: BoxDecoration(
                                color: Colors.white.withValues(alpha: .14),
                                shape: BoxShape.circle,
                              ),
                              child: Icon(s.icon, size: 16, color: Colors.white),
                            ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(14, 12, 14, compact ? 12 : 14),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(f.name, style: t.titleMedium, maxLines: 1, overflow: TextOverflow.ellipsis),
                  const SizedBox(height: 2),
                  Text(
                    f.headline,
                    style: t.bodySmall?.copyWith(color: AppColors.textSecondary),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      Text.rich(
                        TextSpan(
                          children: [
                            TextSpan(text: Fmt.money(f.pricePerHour), style: t.titleMedium),
                            TextSpan(
                              text: f.hasMultipleUnits ? ' /lane·hr' : ' /hr',
                              style: t.bodySmall?.copyWith(color: AppColors.textMuted),
                            ),
                          ],
                        ),
                      ),
                      const Spacer(),
                      if (!compact)
                        Text(
                          '${f.openHour} AM – ${f.closeHour == 24 ? '12 AM' : '${f.closeHour - 12} PM'}',
                          style: t.labelSmall?.copyWith(color: AppColors.textSecondary),
                        ),
                      if (compact)
                        Container(
                          padding: const EdgeInsets.all(6),
                          decoration: const BoxDecoration(color: AppColors.primaryDark, shape: BoxShape.circle),
                          child: const Icon(Icons.arrow_outward_rounded, size: 14, color: AppColors.accentLime),
                        ),
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
}
