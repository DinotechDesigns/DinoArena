import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/utils/formatters.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/common.dart';
import '../../../../core/widgets/pressable.dart';
import '../../../facilities/domain/entities/facility.dart';
import '../../../facilities/presentation/providers/facility_providers.dart';
import '../../domain/entities/slot.dart';
import '../providers/booking_providers.dart';
import '../widgets/month_calendar.dart';

const int kBookingWindowDays = 30;

class SlotBookingScreen extends ConsumerWidget {
  const SlotBookingScreen({super.key, required this.facilityId});

  final String facilityId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ref
        .watch(facilityProvider(facilityId))
        .when(
          loading: () => const Scaffold(
            body: Center(child: CircularProgressIndicator(color: AppColors.primaryGreen)),
          ),
          error: (e, _) => Scaffold(
            appBar: const AppTopBar(title: 'Book'),
            body: ErrorView(message: e.toString()),
          ),
          data: (f) => _SlotBookingView(facility: f),
        );
  }
}

class _SlotBookingView extends ConsumerStatefulWidget {
  const _SlotBookingView({required this.facility});

  final Facility facility;

  @override
  ConsumerState<_SlotBookingView> createState() => _SlotBookingViewState();
}

class _SlotBookingViewState extends ConsumerState<_SlotBookingView> {
  final _dates = ScrollController();
  static const _dateItemExtent = 64.0 + 10;

  @override
  void initState() {
    super.initState();
    // Deep links may land here without a draft.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(bookingDraftProvider.notifier).start(widget.facility);
      _scrollToDate(ref.read(bookingDraftProvider).date, animate: false);
    });
  }

  void _scrollToDate(DateTime date, {bool animate = true}) {
    if (!_dates.hasClients) return;
    final index = date.difference(DateTime.now().dateOnly).inDays;
    final target = (index * _dateItemExtent - 40).clamp(0.0, _dates.position.maxScrollExtent);
    animate
        ? _dates.animateTo(target, duration: const Duration(milliseconds: 400), curve: Curves.easeOutCubic)
        : _dates.jumpTo(target);
  }

  Future<void> _openCalendar(DateTime selected) async {
    final today = DateTime.now().dateOnly;
    final picked = await showModalBottomSheet<DateTime>(
      context: context,
      isScrollControlled: true,
      builder: (context) => Padding(
        padding: const EdgeInsets.fromLTRB(AppSpacing.gutter, 0, AppSpacing.gutter, AppSpacing.lg),
        child: SafeArea(
          child: MonthCalendar(
            selected: selected,
            firstDate: today,
            lastDate: today.add(const Duration(days: kBookingWindowDays - 1)),
            onSelected: (d) => Navigator.pop(context, d),
          ),
        ),
      ),
    );
    if (picked != null) {
      ref.read(bookingDraftProvider.notifier).setDate(picked);
      _scrollToDate(picked);
    }
  }

  @override
  void dispose() {
    _dates.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context).textTheme;
    final f = widget.facility;
    final draft = ref.watch(bookingDraftProvider);
    final query = (facility: f, date: draft.date, unit: draft.unit);
    final slots = ref.watch(slotsProvider(query));

    ref.listen(slotsProvider(query), (_, next) {
      final live = next.value;
      if (live == null) return;
      final removed = ref.read(bookingDraftProvider.notifier).reconcile(live);
      if (removed > 0) {
        HapticFeedback.heavyImpact();
        showAppSnack(
          context,
          'Heads up — a slot you picked was just booked by another player.',
          icon: Icons.flash_on_rounded,
        );
      }
    });

    return Scaffold(
      appBar: AppTopBar(
        title: f.name,
        actions: [
          CircleIconButton(
            icon: Icons.calendar_month_rounded,
            tooltip: 'Open calendar',
            onTap: () => _openCalendar(draft.date),
          ),
        ],
      ),
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(AppSpacing.gutter, 4, AppSpacing.gutter, 0),
              child: Row(
                children: [
                  const LiveDot(color: AppColors.primaryGreen),
                  const SizedBox(width: 4),
                  Text('Live availability', style: t.labelMedium?.copyWith(color: AppColors.primaryGreen)),
                  const SizedBox(width: 6),
                  Expanded(
                    child: Text(
                      '· updates as players book',
                      style: t.bodySmall?.copyWith(color: AppColors.textMuted),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: SizedBox(
              height: 96,
              child: ListView.builder(
                controller: _dates,
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.fromLTRB(AppSpacing.gutter, 14, AppSpacing.gutter, 6),
                itemExtent: _dateItemExtent,
                itemCount: kBookingWindowDays,
                itemBuilder: (_, i) {
                  final d = DateTime.now().dateOnly.add(Duration(days: i));
                  return Padding(
                    padding: const EdgeInsets.only(right: 10),
                    child: _DateChip(
                      date: d,
                      selected: d.isSameDay(draft.date),
                      onTap: () => ref.read(bookingDraftProvider.notifier).setDate(d),
                    ),
                  );
                },
              ),
            ),
          ),
          if (f.hasMultipleUnits || f.sports.length > 1)
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(AppSpacing.gutter, 12, AppSpacing.gutter, 0),
                child: f.hasMultipleUnits
                    ? _Segmented(
                        label: 'Choose lane',
                        options: [for (var u = 0; u < f.units; u++) '${f.unitLabel} ${String.fromCharCode(65 + u)}'],
                        selected: draft.unit,
                        onChanged: ref.read(bookingDraftProvider.notifier).setUnit,
                      )
                    : _Segmented(
                        label: 'What are you playing?',
                        options: [for (final s in f.sports) s.label],
                        icons: [for (final s in f.sports) s.icon],
                        selected: draft.sport == null
                            ? 0
                            : f.sports.indexOf(draft.sport!).clamp(0, f.sports.length - 1),
                        onChanged: (i) => ref.read(bookingDraftProvider.notifier).setSport(f.sports[i]),
                      ),
              ),
            ),
          const SliverToBoxAdapter(child: _Legend()),
          ...slots.when(
            loading: () => [
              SliverPadding(
                padding: const EdgeInsets.all(AppSpacing.gutter),
                sliver: SliverGrid.count(
                  crossAxisCount: 3,
                  mainAxisSpacing: 10,
                  crossAxisSpacing: 10,
                  childAspectRatio: 1.45,
                  children: List.generate(12, (_) => const SkeletonBox(height: 60)),
                ),
              ),
            ],
            error: (e, _) => [
              SliverFillRemaining(
                hasScrollBody: false,
                child: ErrorView(message: e.toString(), onRetry: () => ref.invalidate(slotsProvider(query))),
              ),
            ],
            data: (list) => _slotSections(context, list, draft),
          ),
          const SliverToBoxAdapter(child: SizedBox(height: 140)),
        ],
      ),
      bottomNavigationBar: _SelectionBar(draft: draft),
    );
  }

  List<Widget> _slotSections(BuildContext context, List<Slot> list, BookingDraft draft) {
    final upcoming = list.where((s) => s.status != SlotStatus.blocked).toList();
    if (upcoming.isEmpty) {
      return [
        SliverFillRemaining(
          hasScrollBody: false,
          child: EmptyState(
            icon: Icons.nights_stay_rounded,
            title: 'That’s a wrap for today',
            message: 'All of today’s slots have started. Pick another date to keep playing.',
            actionLabel: 'Tomorrow',
            onAction: () =>
                ref.read(bookingDraftProvider.notifier).setDate(DateTime.now().dateOnly.add(const Duration(days: 1))),
          ),
        ),
      ];
    }
    final groups = <(String, IconData, bool Function(int))>[
      ('Morning', Icons.wb_twilight_rounded, (h) => h < 12),
      ('Afternoon', Icons.wb_sunny_rounded, (h) => h >= 12 && h < 17),
      ('Evening', Icons.sports_score_rounded, (h) => h >= 17 && h < 21),
      ('Night · floodlit', Icons.nightlight_round, (h) => h >= 21),
    ];
    final selectedIds = {for (final s in draft.selected) s.id};
    final t = Theme.of(context).textTheme;
    final columns = MediaQuery.sizeOf(context).width >= 600 ? 4 : 3;

    return [
      for (final (label, icon, test) in groups)
        if (upcoming.any((s) => test(s.start.hour))) ...[
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(AppSpacing.gutter, 18, AppSpacing.gutter, 10),
            sliver: SliverToBoxAdapter(
              child: Row(
                children: [
                  Icon(icon, size: 18, color: AppColors.textSecondary),
                  const SizedBox(width: 8),
                  Text(label, style: t.titleSmall),
                  const SizedBox(width: 8),
                  Text(
                    '${upcoming.where((s) => test(s.start.hour) && s.isAvailable).length} open',
                    style: t.bodySmall?.copyWith(color: AppColors.textMuted),
                  ),
                ],
              ),
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.gutter),
            sliver: SliverGrid.count(
              crossAxisCount: columns,
              mainAxisSpacing: 10,
              crossAxisSpacing: 10,
              childAspectRatio: 1.45,
              children: [
                for (final (i, s) in upcoming.where((s) => test(s.start.hour)).indexed)
                  _SlotTile(
                    slot: s,
                    selected: selectedIds.contains(s.id),
                    onTap: () {
                      HapticFeedback.selectionClick();
                      ref.read(bookingDraftProvider.notifier).toggle(s);
                    },
                  ).animate(key: ValueKey('${s.id}-in')).fadeIn(delay: (25 * i).ms, duration: 250.ms),
              ],
            ),
          ),
        ],
    ];
  }
}

class _DateChip extends StatelessWidget {
  const _DateChip({required this.date, required this.selected, required this.onTap});

  final DateTime date;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context).textTheme;
    final isToday = date.isSameDay(DateTime.now());
    return Semantics(
      button: true,
      selected: selected,
      label: Fmt.dateLong(date),
      child: Pressable(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 250),
          curve: Curves.easeOutCubic,
          decoration: BoxDecoration(
            color: selected ? AppColors.primaryDark : AppColors.surface,
            borderRadius: BorderRadius.circular(18),
            border: Border.all(color: selected ? AppColors.primaryDark : AppColors.border),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                isToday ? 'TODAY' : Fmt.dayShort(date).toUpperCase(),
                style: t.labelSmall?.copyWith(
                  fontSize: 10,
                  color: selected ? AppColors.accentLime : (date.isWeekend ? AppColors.warning : AppColors.textMuted),
                ),
              ),
              const SizedBox(height: 2),
              Text(Fmt.dayNum(date), style: t.titleLarge?.copyWith(color: selected ? Colors.white : null)),
              Text(
                Fmt.dateShort(date).split(' ').last,
                style: t.bodySmall?.copyWith(fontSize: 10, color: selected ? Colors.white60 : AppColors.textMuted),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _Segmented extends StatelessWidget {
  const _Segmented({
    required this.label,
    required this.options,
    required this.selected,
    required this.onChanged,
    this.icons,
  });

  final String label;
  final List<String> options;
  final List<IconData>? icons;
  final int selected;
  final ValueChanged<int> onChanged;

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context).textTheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: t.labelMedium?.copyWith(color: AppColors.textSecondary)),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.all(4),
          decoration: BoxDecoration(color: AppColors.surfaceMuted, borderRadius: BorderRadius.circular(16)),
          child: Row(
            children: [
              for (var i = 0; i < options.length; i++)
                Expanded(
                  child: Pressable(
                    onTap: () => onChanged(i),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 220),
                      height: 42,
                      decoration: BoxDecoration(
                        color: i == selected ? AppColors.surface : Colors.transparent,
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: i == selected
                            ? const [BoxShadow(color: Color(0x14101B18), blurRadius: 8, offset: Offset(0, 2))]
                            : null,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          if (icons != null) ...[
                            Icon(
                              icons![i],
                              size: 17,
                              color: i == selected ? AppColors.primaryGreen : AppColors.textMuted,
                            ),
                            const SizedBox(width: 6),
                          ],
                          Text(
                            options[i],
                            style: t.labelLarge?.copyWith(
                              color: i == selected ? AppColors.textPrimary : AppColors.textMuted,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ],
    );
  }
}

class _Legend extends StatelessWidget {
  const _Legend();

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context).textTheme;
    Widget item(Color c, String label, {Color? border}) => Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(
            color: c,
            borderRadius: BorderRadius.circular(4),
            border: border == null ? null : Border.all(color: border),
          ),
        ),
        const SizedBox(width: 5),
        Text(label, style: t.bodySmall?.copyWith(color: AppColors.textSecondary)),
      ],
    );
    return Padding(
      padding: const EdgeInsets.fromLTRB(AppSpacing.gutter, 16, AppSpacing.gutter, 0),
      child: Wrap(
        spacing: 14,
        runSpacing: 8,
        children: [
          item(AppColors.surface, 'Open', border: AppColors.border),
          item(AppColors.primaryDark, 'Selected'),
          item(AppColors.warningSoft, 'Being booked', border: AppColors.warning),
          item(AppColors.surfaceMuted, 'Booked'),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.bolt_rounded, size: 14, color: AppColors.warning),
              Text('Peak', style: t.bodySmall?.copyWith(color: AppColors.textSecondary)),
            ],
          ),
        ],
      ),
    );
  }
}

class _SlotTile extends StatelessWidget {
  const _SlotTile({required this.slot, required this.selected, required this.onTap});

  final Slot slot;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context).textTheme;
    final status = slot.status;
    final (bg, fg, border) = selected
        ? (AppColors.primaryDark, Colors.white, AppColors.primaryDark)
        : switch (status) {
            SlotStatus.available => (AppColors.surface, AppColors.textPrimary, AppColors.border),
            SlotStatus.held => (AppColors.warningSoft, AppColors.textSecondary, AppColors.warning),
            _ => (AppColors.surfaceMuted, AppColors.textMuted, AppColors.surfaceMuted),
          };
    final label =
        '${Fmt.hour(slot.start)}, ${Fmt.money(slot.price)}, '
        '${selected ? 'selected' : switch (status) {
                SlotStatus.available => 'available',
                SlotStatus.held => 'being booked',
                _ => 'booked',
              }}';

    return Semantics(
      button: slot.isAvailable,
      selected: selected,
      label: label,
      excludeSemantics: true,
      child: Pressable(
        onTap: slot.isAvailable ? onTap : null,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOutCubic,
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
          decoration: BoxDecoration(
            color: bg,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: border, width: selected ? 0 : 1.2),
            boxShadow: selected
                ? [
                    BoxShadow(
                      color: AppColors.primaryDark.withValues(alpha: .25),
                      blurRadius: 12,
                      offset: const Offset(0, 5),
                    ),
                  ]
                : null,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      Fmt.hour(slot.start),
                      style: t.titleSmall?.copyWith(
                        color: fg,
                        decoration: status == SlotStatus.booked && !selected ? TextDecoration.lineThrough : null,
                      ),
                    ),
                  ),
                  if (selected)
                    const Icon(
                      Icons.check_circle_rounded,
                      size: 16,
                      color: AppColors.accentLime,
                    ).animate().scale(curve: Curves.easeOutBack, duration: 250.ms)
                  else if (slot.isPeak && slot.isAvailable)
                    const Icon(Icons.bolt_rounded, size: 15, color: AppColors.warning),
                ],
              ),
              const SizedBox(height: 2),
              Text(
                switch (status) {
                  _ when selected => Fmt.money(slot.price),
                  SlotStatus.available => Fmt.money(slot.price),
                  SlotStatus.held => 'Being booked',
                  _ => 'Booked',
                },
                style: t.bodySmall?.copyWith(
                  color: selected ? AppColors.accentLime : (status == SlotStatus.held ? AppColors.warning : fg),
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SelectionBar extends StatelessWidget {
  const _SelectionBar({required this.draft});

  final BookingDraft draft;

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context).textTheme;
    return AnimatedSlide(
      offset: draft.hasSelection ? Offset.zero : const Offset(0, 1.2),
      duration: const Duration(milliseconds: 350),
      curve: Curves.easeOutCubic,
      child: Container(
        margin: EdgeInsets.fromLTRB(16, 0, 16, 12 + MediaQuery.paddingOf(context).bottom),
        padding: const EdgeInsets.fromLTRB(18, 12, 12, 12),
        decoration: BoxDecoration(
          color: AppColors.primaryDark,
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(color: AppColors.primaryDark.withValues(alpha: .3), blurRadius: 24, offset: const Offset(0, 10)),
          ],
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${draft.hours} ${draft.hours == 1 ? 'hour' : 'hours'} · ${Fmt.date(draft.date)}',
                    style: t.bodySmall?.copyWith(color: Colors.white60),
                  ),
                  TweenAnimationBuilder<double>(
                    tween: Tween(end: draft.subtotal.toDouble()),
                    duration: const Duration(milliseconds: 350),
                    builder: (_, v, _) =>
                        Text(Fmt.money(v.round()), style: t.titleLarge?.copyWith(color: Colors.white)),
                  ),
                ],
              ),
            ),
            SizedBox(
              width: 150,
              child: AppButton(
                label: 'Continue',
                height: 50,
                variant: AppButtonVariant.lime,
                trailingIcon: Icons.arrow_forward_rounded,
                onPressed: draft.hasSelection ? () => context.push(Routes.bookingSummary) : null,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
