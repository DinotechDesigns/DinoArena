import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/widgets/common.dart';
import '../../../../core/widgets/pressable.dart';
import '../../../../shared/domain/sport_type.dart';
import '../../../home/presentation/main_shell.dart';
import '../providers/facility_providers.dart';
import '../widgets/facility_card.dart';

class ExploreScreen extends ConsumerStatefulWidget {
  const ExploreScreen({super.key});

  @override
  ConsumerState<ExploreScreen> createState() => _ExploreScreenState();
}

class _ExploreScreenState extends ConsumerState<ExploreScreen> {
  late final _search = TextEditingController(text: ref.read(facilitySearchProvider));

  @override
  void dispose() {
    _search.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context).textTheme;
    final sport = ref.watch(facilitySportFilterProvider);
    final results = ref.watch(filteredFacilitiesProvider);
    final width = MediaQuery.sizeOf(context).width;
    final columns = width >= 900 ? 3 : (width >= 600 ? 2 : 1);

    return Scaffold(
      body: SafeArea(
        bottom: false,
        child: CustomScrollView(
          keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
          slivers: [
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(AppSpacing.gutter, 16, AppSpacing.gutter, 0),
              sliver: SliverToBoxAdapter(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Explore', style: t.headlineLarge),
                    const SizedBox(height: 4),
                    Text(
                      'Find your arena and check live slots',
                      style: t.bodyMedium?.copyWith(color: AppColors.textSecondary),
                    ),
                    const SizedBox(height: 18),
                    TextField(
                      controller: _search,
                      onChanged: ref.read(facilitySearchProvider.notifier).set,
                      textInputAction: TextInputAction.search,
                      decoration: InputDecoration(
                        hintText: 'Search turf, court, nets…',
                        prefixIcon: const Icon(Icons.search_rounded),
                        suffixIcon: _search.text.isEmpty
                            ? null
                            : IconButton(
                                tooltip: 'Clear search',
                                icon: const Icon(Icons.close_rounded),
                                onPressed: () {
                                  _search.clear();
                                  ref.read(facilitySearchProvider.notifier).set('');
                                },
                              ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: SizedBox(
                height: 64,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.fromLTRB(AppSpacing.gutter, 14, AppSpacing.gutter, 8),
                  children: [
                    _FilterChip(
                      label: 'All',
                      icon: Icons.apps_rounded,
                      selected: sport == null,
                      onTap: () => ref.read(facilitySportFilterProvider.notifier).select(null),
                    ),
                    for (final s in SportType.values)
                      _FilterChip(
                        label: s.label,
                        icon: s.icon,
                        selected: sport == s,
                        onTap: () => ref.read(facilitySportFilterProvider.notifier).select(s),
                      ),
                  ],
                ),
              ),
            ),
            results.when(
              loading: () => SliverPadding(
                padding: const EdgeInsets.all(AppSpacing.gutter),
                sliver: SliverList.separated(
                  itemCount: 3,
                  separatorBuilder: (_, _) => const SizedBox(height: 16),
                  itemBuilder: (_, _) => const SkeletonBox(height: 270, radius: AppRadius.lg),
                ),
              ),
              error: (e, _) => SliverFillRemaining(
                hasScrollBody: false,
                child: ErrorView(message: e.toString(), onRetry: () => ref.invalidate(facilitiesProvider)),
              ),
              data: (list) => list.isEmpty
                  ? const SliverFillRemaining(
                      hasScrollBody: false,
                      child: EmptyState(
                        icon: Icons.search_off_rounded,
                        title: 'No arenas match',
                        message: 'Try a different sport or search term.',
                      ),
                    )
                  : SliverPadding(
                      padding: const EdgeInsets.fromLTRB(AppSpacing.gutter, 8, AppSpacing.gutter, 0),
                      sliver: SliverGrid.builder(
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: columns,
                          mainAxisSpacing: 16,
                          crossAxisSpacing: 16,
                          mainAxisExtent: 268,
                        ),
                        itemCount: list.length,
                        itemBuilder: (_, i) => FacilityCard(facility: list[i])
                            .animate(key: ValueKey('${list[i].id}-$sport'))
                            .fadeIn(delay: (70 * i).ms, duration: 380.ms)
                            .slideY(begin: .12, curve: Curves.easeOutCubic),
                      ),
                    ),
            ),
            const SliverToBoxAdapter(child: SizedBox(height: kNavClearance)),
          ],
        ),
      ),
    );
  }
}

class _FilterChip extends StatelessWidget {
  const _FilterChip({required this.label, required this.icon, required this.selected, required this.onTap});

  final String label;
  final IconData icon;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: Pressable(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 220),
          padding: const EdgeInsets.symmetric(horizontal: 14),
          decoration: BoxDecoration(
            color: selected ? AppColors.primaryDark : AppColors.surface,
            borderRadius: BorderRadius.circular(100),
            border: Border.all(color: selected ? AppColors.primaryDark : AppColors.border),
          ),
          child: Row(
            children: [
              Icon(icon, size: 17, color: selected ? AppColors.accentLime : AppColors.textSecondary),
              const SizedBox(width: 6),
              Text(
                label,
                style: Theme.of(
                  context,
                ).textTheme.labelMedium?.copyWith(color: selected ? Colors.white : AppColors.textPrimary),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
