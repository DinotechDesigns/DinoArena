import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_theme.dart';
import '../../core/widgets/common.dart';
import '../domain/sport_type.dart';
import 'sport_art.dart';

/// Collapsing illustrated header shared by event & tournament detail screens.
class DetailSliverHeader extends StatelessWidget {
  const DetailSliverHeader({
    super.key,
    required this.sport,
    required this.title,
    required this.subtitle,
    this.pills = const [],
  });

  final SportType sport;
  final String title;
  final String subtitle;
  final List<Widget> pills;

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context).textTheme;
    final topPad = MediaQuery.paddingOf(context).top;
    return SliverAppBar(
      expandedHeight: 280,
      pinned: true,
      backgroundColor: AppColors.primaryDark,
      systemOverlayStyle: AppTheme.darkOverlay,
      automaticallyImplyLeading: false,
      titleSpacing: 12,
      title: const AppBackButton(onDark: true),
      flexibleSpace: FlexibleSpaceBar(
        background: SportArt(
          sport: sport,
          child: Padding(
            padding: EdgeInsets.fromLTRB(AppSpacing.gutter, topPad + 64, AppSpacing.gutter, 22),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Wrap(spacing: 8, runSpacing: 8, children: pills),
                const SizedBox(height: 12),
                Text(
                  title,
                  style: t.headlineLarge?.copyWith(color: Colors.white),
                ).animate().fadeIn(duration: 400.ms).slideY(begin: .3, curve: Curves.easeOutCubic),
                const SizedBox(height: 4),
                Text(subtitle, style: t.bodyMedium?.copyWith(color: Colors.white70)),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// Grid of icon + label + value facts.
class FactGrid extends StatelessWidget {
  const FactGrid({super.key, required this.facts});

  final List<(IconData, String, String)> facts;

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context).textTheme;
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppRadius.lg),
        border: Border.all(color: AppColors.border),
      ),
      child: LayoutBuilder(
        builder: (context, c) => Wrap(
          runSpacing: 16,
          children: [
            for (final (icon, label, value) in facts)
              SizedBox(
                width: c.maxWidth / 2,
                child: Row(
                  children: [
                    Container(
                      width: 38,
                      height: 38,
                      decoration: BoxDecoration(color: AppColors.limeSoft, borderRadius: BorderRadius.circular(12)),
                      child: Icon(icon, size: 19, color: AppColors.primaryGreen),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(label, style: t.bodySmall?.copyWith(color: AppColors.textMuted, fontSize: 11)),
                          Text(value, style: t.labelLarge, maxLines: 2, overflow: TextOverflow.ellipsis),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
    ).animate().fadeIn(duration: 350.ms).slideY(begin: .08);
  }
}

class BulletList extends StatelessWidget {
  const BulletList({super.key, required this.items, this.icon = Icons.check_rounded});

  final List<String> items;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context).textTheme;
    return Column(
      children: [
        for (final item in items)
          Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 2),
                  child: Icon(icon, size: 17, color: AppColors.primaryGreen),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(item, style: t.bodyMedium?.copyWith(color: AppColors.textSecondary)),
                ),
              ],
            ),
          ),
      ],
    );
  }
}

class BottomActionBar extends StatelessWidget {
  const BottomActionBar({super.key, required this.child, this.leading});

  final Widget child;
  final Widget? leading;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(AppSpacing.gutter, 14, AppSpacing.gutter, 14 + MediaQuery.paddingOf(context).bottom),
      decoration: const BoxDecoration(
        color: AppColors.surface,
        border: Border(top: BorderSide(color: AppColors.border)),
      ),
      child: Row(
        children: [
          if (leading != null) ...[leading!, const SizedBox(width: 16)],
          Expanded(child: child),
        ],
      ),
    );
  }
}
