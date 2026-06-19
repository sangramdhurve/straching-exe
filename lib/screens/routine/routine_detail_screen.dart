import 'package:flutter/material.dart';

import '../../core/constants/app_constants.dart';
import '../../data/content_repository.dart';
import '../../models/routine.dart';
import '../../widgets/stretch_tile.dart';
import '../stretch/stretch_detail_screen.dart';
import 'routine_player_screen.dart';

/// Preview a routine — see the stretches before starting it.
class RoutineDetailScreen extends StatelessWidget {
  final Routine routine;
  const RoutineDetailScreen({super.key, required this.routine});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final stretches = ContentRepository.instance.stretchesForRoutine(routine);

    return Scaffold(
      appBar: AppBar(title: Text(routine.name)),
      body: Column(
        children: [
          Expanded(
            child: ListView(
              padding: const EdgeInsets.fromLTRB(
                  AppSpacing.md, AppSpacing.sm, AppSpacing.md, AppSpacing.md),
              children: [
                Text(routine.description,
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        color: scheme.onSurfaceVariant)),
                const SizedBox(height: AppSpacing.md),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    _pill(context, Icons.timer_outlined, '${routine.minutes} min'),
                    _pill(context, Icons.format_list_numbered,
                        '${stretches.length} stretches'),
                    _pill(context, Icons.signal_cellular_alt_outlined,
                        _levelLabel(routine.level)),
                  ],
                ),
                const SizedBox(height: AppSpacing.lg),
                Text('In this routine',
                    style: Theme.of(context).textTheme.titleLarge),
                const SizedBox(height: AppSpacing.sm),
                for (final s in stretches)
                  StretchTile(
                    stretch: s,
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (_) => StretchDetailScreen(stretch: s)),
                    ),
                  ),
              ],
            ),
          ),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(AppSpacing.md),
              child: SizedBox(
                width: double.infinity,
                child: FilledButton.icon(
                  onPressed: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (_) => RoutinePlayerScreen(routine: routine)),
                  ),
                  icon: const Icon(Icons.play_arrow),
                  label: Text('Start • ${routine.minutes} min'),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _levelLabel(String l) => l == 'gentle'
      ? 'Gentle'
      : l == 'deeper'
          ? 'Deeper'
          : 'All levels';

  Widget _pill(BuildContext c, IconData icon, String text) {
    final scheme = Theme.of(c).colorScheme;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: scheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 15, color: scheme.onSurfaceVariant),
          const SizedBox(width: 6),
          Text(text, style: Theme.of(c).textTheme.labelLarge),
        ],
      ),
    );
  }
}
