import 'package:flutter/material.dart';

import '../core/app_state.dart';
import '../core/constants/app_constants.dart';

/// A calendar card showing this month's activity (days with a completed
/// stretch/routine are filled), plus Activity / Streak / This-week stat tiles —
/// the reference's progress panel, on-brand. Listens to [AppState] so it updates
/// the moment a session is logged.
class StreakCalendar extends StatelessWidget {
  const StreakCalendar({super.key});

  static const _weekdayLabels = ['S', 'M', 'T', 'W', 'T', 'F', 'S'];
  static const _monthNames = [
    'January', 'February', 'March', 'April', 'May', 'June',
    'July', 'August', 'September', 'October', 'November', 'December',
  ];

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final text = Theme.of(context).textTheme;

    return ListenableBuilder(
      listenable: AppState.instance,
      builder: (context, _) {
        final st = AppState.instance;
        final now = DateTime.now();
        final daysInMonth = DateTime(now.year, now.month + 1, 0).day;
        final leadingBlanks = DateTime(now.year, now.month, 1).weekday % 7;
        final activeThisMonth = List.generate(daysInMonth, (i) => i + 1)
            .where((d) => st.completedOn(DateTime(now.year, now.month, d)))
            .length;

        final cells = <Widget>[
          for (var i = 0; i < leadingBlanks; i++) const SizedBox.shrink(),
          for (var d = 1; d <= daysInMonth; d++)
            _dayCell(context, d, now, st),
        ];

        return Card(
          child: Padding(
            padding: const EdgeInsets.all(AppSpacing.md),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('${_monthNames[now.month - 1]} ${now.year}',
                    style: text.titleMedium),
                const SizedBox(height: AppSpacing.sm),
                Row(
                  children: [
                    for (final w in _weekdayLabels)
                      Expanded(
                        child: Center(
                          child: Text(w,
                              style: text.labelSmall?.copyWith(
                                  color: scheme.onSurfaceVariant)),
                        ),
                      ),
                  ],
                ),
                const SizedBox(height: 4),
                GridView.count(
                  crossAxisCount: 7,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  mainAxisSpacing: 4,
                  crossAxisSpacing: 4,
                  children: cells,
                ),
                const Divider(height: AppSpacing.lg),
                Row(
                  children: [
                    Expanded(
                        child: _stat(context, '$activeThisMonth',
                            'Active days')),
                    Expanded(
                        child: _stat(context, '${st.streak}', 'Day streak')),
                    Expanded(
                        child: _stat(
                            context, '${st.activeDaysInLast(7)}', 'This week')),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _dayCell(BuildContext c, int day, DateTime now, AppState st) {
    final scheme = Theme.of(c).colorScheme;
    final date = DateTime(now.year, now.month, day);
    final done = st.completedOn(date);
    final isToday = day == now.day;
    return Semantics(
      label: done ? 'Day $day, completed' : 'Day $day',
      child: AspectRatio(
        aspectRatio: 1,
        child: Container(
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: done ? scheme.primary : Colors.transparent,
            shape: BoxShape.circle,
            border: isToday && !done
                ? Border.all(color: scheme.primary, width: 1.5)
                : null,
          ),
          child: Text(
            '$day',
            style: Theme.of(c).textTheme.bodySmall?.copyWith(
                  color: done ? scheme.onPrimary : scheme.onSurface,
                  fontWeight: isToday ? FontWeight.w700 : FontWeight.w400,
                ),
          ),
        ),
      ),
    );
  }

  Widget _stat(BuildContext c, String value, String label) {
    final scheme = Theme.of(c).colorScheme;
    return Column(
      children: [
        Text(value,
            style: Theme.of(c)
                .textTheme
                .headlineSmall
                ?.copyWith(color: scheme.primary, fontWeight: FontWeight.w700)),
        const SizedBox(height: 2),
        Text(label,
            textAlign: TextAlign.center,
            style: Theme.of(c)
                .textTheme
                .bodySmall
                ?.copyWith(color: scheme.onSurfaceVariant)),
      ],
    );
  }
}
