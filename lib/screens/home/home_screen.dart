import 'package:flutter/material.dart';

import '../../core/app_state.dart';
import '../../core/constants/app_constants.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_gradients.dart';
import '../../data/content_repository.dart';
import '../../models/routine.dart';
import '../../widgets/body_part_card.dart';
import '../../widgets/gradient_hero_card.dart';
import '../../widgets/responsive.dart';
import '../body_part/body_part_screen.dart';
import '../routine/routine_detail_screen.dart';
import '../search/search_screen.dart';
import 'main_shell.dart';

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
                            Text('Let\'s loosen up',
                                style:
                                    Theme.of(context).textTheme.headlineSmall),
                            const SizedBox(height: 2),
                            Text(
                                'Gentle stretches for every body — go at your own pace',
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyMedium
                                    ?.copyWith(color: scheme.onSurfaceVariant)),
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
              if (daily != null) _todaysPickHero(context, daily),
              const SizedBox(height: AppSpacing.md),
              _statsStrip(context),
              const SizedBox(height: AppSpacing.lg),
              Text('Stretch by body part',
                  style: Theme.of(context).textTheme.titleLarge),
              const SizedBox(height: AppSpacing.sm),
              GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                // Fixed-height tiles that GROW with the text scale, so long
                // section names wrap without clipping in large-text mode.
                gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                  maxCrossAxisExtent: 220,
                  mainAxisSpacing: AppSpacing.md,
                  crossAxisSpacing: AppSpacing.md,
                  mainAxisExtent: 168 +
                      90 *
                          (MediaQuery.textScalerOf(context).scale(1) - 1)
                              .clamp(0.0, 1.5),
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
              const SizedBox(height: AppSpacing.lg),
              _browseClipsBanner(context),
            ],
          ),
        ),
      ),
    );
  }

  /// The premium gradient "Today's pick" hero — big minute count + ↗ start.
  Widget _todaysPickHero(BuildContext context, Routine daily) {
    return GradientHeroCard(
      eyebrow: "TODAY'S PICK",
      bigNumber: '${daily.minutes}',
      bigNumberLabel: 'min',
      title: daily.name,
      subtitle: daily.description,
      semanticLabel: "Today's pick: ${daily.name}, ${daily.minutes} minutes",
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => RoutineDetailScreen(routine: daily)),
      ),
    );
  }

  /// Compact activity dashboard (Days / Streak / This week) from real history.
  Widget _statsStrip(BuildContext context) {
    return ListenableBuilder(
      listenable: AppState.instance,
      builder: (context, _) {
        final st = AppState.instance;
        return Row(
          children: [
            Expanded(
                child: _statTile(context, '${st.completedDates.length}',
                    'Days active')),
            const SizedBox(width: AppSpacing.sm),
            Expanded(
                child: _statTile(context, '${st.streak}', 'Day streak')),
            const SizedBox(width: AppSpacing.sm),
            Expanded(
                child: _statTile(
                    context, '${st.activeDaysInLast(7)}', 'This week')),
          ],
        );
      },
    );
  }

  Widget _statTile(BuildContext context, String value, String label) {
    final scheme = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.symmetric(
          vertical: AppSpacing.md, horizontal: AppSpacing.sm),
      decoration: BoxDecoration(
        color: scheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(AppRadii.button),
      ),
      child: Column(
        children: [
          Text(value,
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  color: scheme.primary, fontWeight: FontWeight.w700)),
          const SizedBox(height: 2),
          Text(label,
              textAlign: TextAlign.center,
              style: Theme.of(context)
                  .textTheme
                  .bodySmall
                  ?.copyWith(color: scheme.onSurfaceVariant)),
        ],
      ),
    );
  }

  /// Gradient banner that jumps to the Clips Library tab.
  Widget _browseClipsBanner(BuildContext context) {
    return GradientHeroCard(
      gradient: AppGradients.cool,
      leadingIcon: Icons.play_circle_outline,
      title: 'Clips Library',
      subtitle: 'Watch real demos — learn every move at your pace.',
      ctaIcon: Icons.arrow_forward_rounded,
      semanticLabel: 'Open the Clips Library',
      onTap: () => ShellNavigator.of(context)?.go(2),
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

}
