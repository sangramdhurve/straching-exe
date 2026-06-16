import 'package:flutter/material.dart';

import '../../core/app_state.dart';
import '../../core/constants/app_constants.dart';
import '../../core/theme/app_colors.dart';
import '../../data/content_repository.dart';
import '../../models/routine.dart';
import '../../widgets/body_part_card.dart';
import '../../widgets/responsive.dart';
import '../body_part/body_part_screen.dart';
import '../routine/routine_detail_screen.dart';
import '../search/search_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  String _greeting() {
    final h = DateTime.now().hour;
    if (h < 12) return 'Good morning';
    if (h < 17) return 'Good afternoon';
    return 'Good evening';
  }

  @override
  Widget build(BuildContext context) {
    final repo = ContentRepository.instance;
    final scheme = Theme.of(context).colorScheme;
    final st = AppState.instance;
    final daily = repo
        .dailySuggestionFor(st.propsConfigured ? st.availableProps : null);
    final parts = repo.bodyParts;

    return Scaffold(
      body: SafeArea(
        child: MaxWidth(
          child: ListView(
            padding: const EdgeInsets.fromLTRB(
                AppSpacing.md, AppSpacing.md, AppSpacing.md, AppSpacing.xl),
            children: [
              ListenableBuilder(
                listenable: AppState.instance,
                builder: (context, _) {
                  final streak = AppState.instance.streak;
                  return Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(_greeting(),
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyMedium
                                    ?.copyWith(color: scheme.onSurfaceVariant)),
                            Text('Time to stretch',
                                style:
                                    Theme.of(context).textTheme.headlineSmall),
                          ],
                        ),
                      ),
                      if (streak > 0) _streakChip(context, streak),
                    ],
                  );
                },
              ),
              const SizedBox(height: AppSpacing.lg),
              _searchBar(context),
              const SizedBox(height: AppSpacing.lg),
              if (daily != null) _dailyCard(context, daily),
              const SizedBox(height: AppSpacing.lg),
              Text('Stretch by body part',
                  style: Theme.of(context).textTheme.titleLarge),
              const SizedBox(height: AppSpacing.sm),
              GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate:
                    const SliverGridDelegateWithMaxCrossAxisExtent(
                  maxCrossAxisExtent: 220,
                  mainAxisSpacing: AppSpacing.md,
                  crossAxisSpacing: AppSpacing.md,
                  childAspectRatio: 0.9,
                ),
                itemCount: parts.length,
                itemBuilder: (context, i) {
                  final bp = parts[i];
                  return BodyPartCard(
                    bodyPart: bp,
                    count: repo.countFor(bp.id),
                    tint: AppColors.tints[i % AppColors.tints.length],
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (_) => BodyPartScreen(bodyPart: bp)),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _searchBar(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Material(
      color: scheme.surfaceContainerHighest,
      borderRadius: BorderRadius.circular(AppRadii.button),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: () => Navigator.push(context,
            MaterialPageRoute(builder: (_) => const SearchScreen())),
        child: Padding(
          padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.md, vertical: 14),
          child: Row(
            children: [
              Icon(Icons.search, color: scheme.onSurfaceVariant),
              const SizedBox(width: AppSpacing.sm),
              Text('Search stretches',
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      color: scheme.onSurfaceVariant)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _streakChip(BuildContext c, int streak) => Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: AppColors.accent.withValues(alpha: 0.18),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.local_fire_department,
                color: AppColors.accent, size: 18),
            const SizedBox(width: 4),
            Text('$streak day${streak == 1 ? '' : 's'}',
                style: Theme.of(c).textTheme.labelLarge),
          ],
        ),
      );

  Widget _dailyCard(BuildContext context, Routine daily) {
    final scheme = Theme.of(context).colorScheme;
    return Card(
      color: scheme.primary,
      child: InkWell(
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(
              builder: (_) => RoutineDetailScreen(routine: daily)),
        ),
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.lg),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('TODAY\'S PICK',
                  style: Theme.of(context).textTheme.labelSmall?.copyWith(
                      color: Colors.white70, letterSpacing: 1.2)),
              const SizedBox(height: 6),
              Text(daily.name,
                  style: Theme.of(context)
                      .textTheme
                      .headlineSmall
                      ?.copyWith(color: Colors.white)),
              const SizedBox(height: 4),
              Text(daily.description,
                  style: Theme.of(context)
                      .textTheme
                      .bodyMedium
                      ?.copyWith(color: Colors.white70)),
              const SizedBox(height: AppSpacing.md),
              Row(
                children: [
                  const Icon(Icons.arrow_forward_rounded, color: Colors.white),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      '${daily.minutes} min • ${daily.stretchIds.length} stretches',
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(color: Colors.white),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
