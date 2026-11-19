import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/utils/formatters.dart';
import '../../../../core/widgets/common.dart';
import '../../../../core/widgets/pressable.dart';
import '../../domain/entities/arena_event.dart';

class EventCard extends StatelessWidget {
  const EventCard({super.key, required this.event, this.width});

  final ArenaEvent event;
  final double? width;

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context).textTheme;
    final e = event;
    final weekend = e.cadence == EventCadence.weekend;
    return Pressable(
      onTap: () => context.push(Routes.event(e.id)),
      child: Container(
        width: width,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: weekend ? AppColors.primaryDark : AppColors.surface,
          gradient: weekend ? AppColors.darkGradient : null,
          borderRadius: BorderRadius.circular(AppRadius.lg),
          border: weekend ? null : Border.all(color: AppColors.border),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 52,
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  decoration: BoxDecoration(
                    color: weekend ? AppColors.accentLime : AppColors.limeSoft,
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Column(
                    children: [
                      Text(
                        Fmt.dayShort(e.start).toUpperCase(),
                        style: t.labelSmall?.copyWith(color: AppColors.secondaryDark, fontSize: 10),
                      ),
                      Text(
                        Fmt.dayNum(e.start),
                        style: t.titleLarge?.copyWith(color: AppColors.primaryDark, height: 1.1),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Pill(
                        label: weekend ? 'WEEKEND' : 'DAILY',
                        dense: true,
                        color: weekend ? AppColors.accentLime : AppColors.primaryGreen,
                        background: weekend ? Colors.white.withValues(alpha: .1) : null,
                      ),
                      const SizedBox(height: 6),
                      Text(
                        e.title,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: t.titleMedium?.copyWith(color: weekend ? Colors.white : null),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 14),
            Row(
              children: [
                Icon(Icons.schedule_rounded, size: 15, color: weekend ? Colors.white60 : AppColors.textMuted),
                const SizedBox(width: 5),
                Text(
                  Fmt.time(e.start),
                  style: t.bodySmall?.copyWith(color: weekend ? Colors.white70 : AppColors.textSecondary),
                ),
                const SizedBox(width: 12),
                Icon(e.sport.icon, size: 15, color: weekend ? Colors.white60 : AppColors.textMuted),
                const SizedBox(width: 5),
                Expanded(
                  child: Text(
                    e.venue,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: t.bodySmall?.copyWith(color: weekend ? Colors.white70 : AppColors.textSecondary),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: LinearProgressIndicator(
                value: e.fillRatio,
                minHeight: 5,
                backgroundColor: weekend ? Colors.white12 : AppColors.surfaceMuted,
                color: e.isFull ? AppColors.warning : (weekend ? AppColors.accentLime : AppColors.primaryGreen),
              ),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Text(
                  e.isFull ? 'Fully booked' : '${e.spotsLeft} spots left',
                  style: t.labelMedium?.copyWith(
                    color: e.isFull ? AppColors.warning : (weekend ? Colors.white : AppColors.textPrimary),
                  ),
                ),
                const Spacer(),
                Text(
                  Fmt.money(e.fee),
                  style: t.titleMedium?.copyWith(color: weekend ? AppColors.accentLime : AppColors.primaryGreen),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
