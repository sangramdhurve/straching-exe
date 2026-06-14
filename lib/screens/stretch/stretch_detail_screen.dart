import 'package:flutter/material.dart';

import '../../core/app_state.dart';
import '../../core/constants/app_constants.dart';
import '../../models/stretch.dart';
import '../../widgets/hold_timer_ring.dart';
import '../../widgets/prop_badge.dart';
import '../../widgets/visual_placeholder.dart';

class StretchDetailScreen extends StatefulWidget {
  final Stretch stretch;
  const StretchDetailScreen({super.key, required this.stretch});

  @override
  State<StretchDetailScreen> createState() => _StretchDetailScreenState();
}

class _StretchDetailScreenState extends State<StretchDetailScreen> {
  late String _level;
  bool _timerVisible = false;

  @override
  void initState() {
    super.initState();
    _level = widget.stretch.level;
  }

  String? get _levelTip {
    if (_level == 'gentle') return widget.stretch.variants['gentle'];
    if (_level == 'deeper') return widget.stretch.variants['deeper'];
    return null;
  }

  String get _levelLabel => _level == 'gentle'
      ? 'Gentle variation'
      : _level == 'deeper'
          ? 'Deeper variation'
          : 'Standard';

  @override
  Widget build(BuildContext context) {
    final s = widget.stretch;
    final scheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: Text(s.name),
        actions: [
          ListenableBuilder(
            listenable: AppState.instance,
            builder: (context, _) {
              final fav = AppState.instance.isFavorite(s.id);
              return IconButton(
                tooltip: fav ? 'Remove from favorites' : 'Add to favorites',
                icon: Icon(fav ? Icons.favorite : Icons.favorite_border,
                    color: fav ? scheme.error : null),
                onPressed: () => AppState.instance.toggleFavorite(s.id),
              );
            },
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(
            AppSpacing.md, 0, AppSpacing.md, AppSpacing.xl),
        children: [
          VisualPlaceholder(stretch: s, height: 220),
          const SizedBox(height: AppSpacing.md),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              _infoPill(context, Icons.timer_outlined, s.durationLabel),
              for (final p in s.props.where((p) => p != 'none'))
                PropBadge(prop: p),
              if (s.targetMuscles.isNotEmpty)
                _infoPill(context, Icons.fitness_center_outlined,
                    s.targetMuscles.join(', ')),
            ],
          ),
          const SizedBox(height: AppSpacing.lg),

          // Hold timer (hero)
          Center(
            child: _timerVisible
                ? HoldTimerRing(
                    key: ValueKey('${s.id}_$_level'),
                    seconds: s.holdSeconds,
                    centerLabel: s.sides == 2 ? 'each side' : 'hold',
                    onComplete: () =>
                        AppState.instance.registerSessionComplete(),
                  )
                : FilledButton.icon(
                    onPressed: () => setState(() => _timerVisible = true),
                    icon: const Icon(Icons.play_arrow),
                    label: Text('Start ${s.holdSeconds}s hold'),
                  ),
          ),
          const SizedBox(height: AppSpacing.lg),

          _levelToggle(context),
          const SizedBox(height: AppSpacing.lg),

          _section(context, 'How to do it'),
          for (int i = 0; i < s.steps.length; i++)
            _step(context, i + 1, s.steps[i]),
          const SizedBox(height: AppSpacing.md),

          _callout(context, Icons.air, 'Breathing', s.breathingCue,
              scheme.primary),
          if (_levelTip != null)
            _callout(context, Icons.tune, _levelLabel, _levelTip!,
                scheme.secondary),
          const SizedBox(height: AppSpacing.md),

          if (s.commonMistakes.isNotEmpty) ...[
            _section(context, 'Common mistakes'),
            for (final m in s.commonMistakes) _bulletLine(context, m),
            const SizedBox(height: AppSpacing.md),
          ],

          if (s.safetyNote.isNotEmpty)
            _callout(context, Icons.health_and_safety_outlined, 'Safety',
                s.safetyNote, scheme.tertiary),
        ],
      ),
    );
  }

  Widget _levelToggle(BuildContext context) {
    return SegmentedButton<String>(
      segments: const [
        ButtonSegment(value: 'gentle', label: Text('Gentle')),
        ButtonSegment(value: 'standard', label: Text('Standard')),
        ButtonSegment(value: 'deeper', label: Text('Deeper')),
      ],
      selected: {_level},
      onSelectionChanged: (sel) => setState(() => _level = sel.first),
      showSelectedIcon: false,
    );
  }

  Widget _infoPill(BuildContext c, IconData icon, String text) {
    final scheme = Theme.of(c).colorScheme;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: scheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: scheme.onSurfaceVariant),
          const SizedBox(width: 5),
          Text(text, style: Theme.of(c).textTheme.bodySmall),
        ],
      ),
    );
  }

  Widget _section(BuildContext c, String title) => Padding(
        padding: const EdgeInsets.only(bottom: AppSpacing.sm),
        child: Text(title, style: Theme.of(c).textTheme.titleLarge),
      );

  Widget _step(BuildContext c, int n, String text) {
    final scheme = Theme.of(c).colorScheme;
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.sm),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 26,
            height: 26,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: scheme.primary.withValues(alpha: 0.14),
              shape: BoxShape.circle,
            ),
            child: Text('$n',
                style: TextStyle(
                    color: scheme.primary, fontWeight: FontWeight.w700)),
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
              child: Padding(
            padding: const EdgeInsets.only(top: 2),
            child: Text(text, style: Theme.of(c).textTheme.bodyLarge),
          )),
        ],
      ),
    );
  }

  Widget _bulletLine(BuildContext c, String text) => Padding(
        padding: const EdgeInsets.only(bottom: 6),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 7, right: 10),
              child: Icon(Icons.circle,
                  size: 6, color: Theme.of(c).colorScheme.onSurfaceVariant),
            ),
            Expanded(child: Text(text, style: Theme.of(c).textTheme.bodyMedium)),
          ],
        ),
      );

  Widget _callout(
      BuildContext c, IconData icon, String title, String body, Color accent) {
    final scheme = Theme.of(c).colorScheme;
    return Container(
      margin: const EdgeInsets.only(bottom: AppSpacing.sm),
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: accent.withValues(alpha: 0.10),
        borderRadius: BorderRadius.circular(AppRadii.button),
        border: Border.all(color: accent.withValues(alpha: 0.25)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: accent, size: 20),
          const SizedBox(width: AppSpacing.sm),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title,
                    style: Theme.of(c)
                        .textTheme
                        .titleSmall
                        ?.copyWith(color: scheme.onSurface)),
                const SizedBox(height: 2),
                Text(body, style: Theme.of(c).textTheme.bodyMedium),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
