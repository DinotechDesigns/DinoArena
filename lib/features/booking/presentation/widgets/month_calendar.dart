import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/utils/formatters.dart';
import '../../../../core/widgets/common.dart';

/// Lightweight month calendar for picking a booking date.
class MonthCalendar extends StatefulWidget {
  const MonthCalendar({
    super.key,
    required this.selected,
    required this.firstDate,
    required this.lastDate,
    required this.onSelected,
  });

  final DateTime selected;
  final DateTime firstDate;
  final DateTime lastDate;
  final ValueChanged<DateTime> onSelected;

  @override
  State<MonthCalendar> createState() => _MonthCalendarState();
}

class _MonthCalendarState extends State<MonthCalendar> {
  late DateTime _month = DateTime(widget.selected.year, widget.selected.month);

  bool get _canPrev => _month.isAfter(DateTime(widget.firstDate.year, widget.firstDate.month));
  bool get _canNext => _month.isBefore(DateTime(widget.lastDate.year, widget.lastDate.month));

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context).textTheme;
    final daysInMonth = DateUtils.getDaysInMonth(_month.year, _month.month);
    final leading = (_month.weekday - 1) % 7; // Monday-first
    final today = DateTime.now().dateOnly;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          children: [
            Text(Fmt.monthYear(_month), style: t.titleLarge),
            const Spacer(),
            CircleIconButton(
              icon: Icons.chevron_left_rounded,
              tooltip: 'Previous month',
              size: 38,
              onTap: _canPrev ? () => setState(() => _month = DateTime(_month.year, _month.month - 1)) : null,
            ),
            const SizedBox(width: 8),
            CircleIconButton(
              icon: Icons.chevron_right_rounded,
              tooltip: 'Next month',
              size: 38,
              onTap: _canNext ? () => setState(() => _month = DateTime(_month.year, _month.month + 1)) : null,
            ),
          ],
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            for (final d in const ['M', 'T', 'W', 'T', 'F', 'S', 'S'])
              Expanded(
                child: Center(
                  child: Text(d, style: t.labelMedium?.copyWith(color: AppColors.textMuted)),
                ),
              ),
          ],
        ),
        const SizedBox(height: 8),
        AnimatedSwitcher(
          duration: const Duration(milliseconds: 250),
          child: GridView.builder(
            key: ValueKey(_month),
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 7,
              mainAxisSpacing: 6,
              crossAxisSpacing: 6,
            ),
            itemCount: leading + daysInMonth,
            itemBuilder: (context, i) {
              if (i < leading) return const SizedBox.shrink();
              final day = DateTime(_month.year, _month.month, i - leading + 1);
              final enabled = !day.isBefore(widget.firstDate.dateOnly) && !day.isAfter(widget.lastDate.dateOnly);
              final selected = day.isSameDay(widget.selected);
              final isToday = day.isSameDay(today);
              return Semantics(
                button: enabled,
                selected: selected,
                label: Fmt.dateLong(day),
                child: InkWell(
                  borderRadius: BorderRadius.circular(14),
                  onTap: enabled ? () => widget.onSelected(day) : null,
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    decoration: BoxDecoration(
                      color: selected ? AppColors.primaryDark : (isToday ? AppColors.limeSoft : Colors.transparent),
                      borderRadius: BorderRadius.circular(14),
                    ),
                    alignment: Alignment.center,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          '${day.day}',
                          style: t.titleSmall?.copyWith(
                            color: selected
                                ? Colors.white
                                : (enabled ? AppColors.textPrimary : AppColors.textMuted.withValues(alpha: .5)),
                          ),
                        ),
                        if (day.isWeekend && enabled)
                          Container(
                            margin: const EdgeInsets.only(top: 2),
                            width: 4,
                            height: 4,
                            decoration: BoxDecoration(
                              color: selected ? AppColors.accentLime : AppColors.warning,
                              shape: BoxShape.circle,
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ),
        const SizedBox(height: 10),
        Row(
          children: [
            Container(
              width: 6,
              height: 6,
              decoration: const BoxDecoration(color: AppColors.warning, shape: BoxShape.circle),
            ),
            const SizedBox(width: 6),
            Text('Weekend · peak pricing all day', style: t.bodySmall?.copyWith(color: AppColors.textSecondary)),
          ],
        ),
      ],
    );
  }
}
