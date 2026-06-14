import 'package:flutter/material.dart';

import '../../core/constants/app_constants.dart';
import '../../data/content_repository.dart';
import '../../models/routine.dart';
import 'routine_player_screen.dart';

/// Browse all guided routines.
class RoutinesScreen extends StatelessWidget {
  const RoutinesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final routines = ContentRepository.instance.routines;
    return Scaffold(
      appBar: AppBar(title: const Text('Routines')),
      body: ListView.builder(
        padding: const EdgeInsets.all(AppSpacing.md),
        itemCount: routines.length,
        itemBuilder: (context, i) => _RoutineCard(routine: routines[i]),
      ),
    );
  }
}

class _RoutineCard extends StatelessWidget {
  final Routine routine;
  const _RoutineCard({required this.routine});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Card(
      margin: const EdgeInsets.only(bottom: AppSpacing.md),
      child: InkWell(
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(
              builder: (_) => RoutinePlayerScreen(routine: routine)),
        ),
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.md),
          child: Row(
            children: [
              Container(
                width: 52,
                height: 52,
                decoration: BoxDecoration(
                  color: scheme.primary.withValues(alpha: 0.14),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Icon(Icons.play_arrow_rounded,
                    color: scheme.primary, size: 30),
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(routine.name,
                        style: Theme.of(context).textTheme.titleMedium),
                    const SizedBox(height: 2),
                    Text(routine.description,
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: scheme.onSurfaceVariant)),
                    const SizedBox(height: 6),
                    Text(
                      '${routine.minutes} min • ${routine.stretchIds.length} stretches',
                      style: Theme.of(context).textTheme.labelMedium?.copyWith(
                          color: scheme.primary),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
