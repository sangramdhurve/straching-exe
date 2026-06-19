import 'package:flutter/material.dart';

import '../../core/app_state.dart';
import '../../core/constants/app_constants.dart';
import '../../models/stretch.dart';
import '../../widgets/demo_player.dart';
import '../../widgets/hold_timer_ring.dart';
import '../../widgets/prop_badge.dart';
import '../../widgets/responsive.dart';

class StretchDetailScreen extends StatefulWidget {
  final Stretch stretch;
  const StretchDetailScreen({super.key, required this.stretch});

  @override
  State<StretchDetailScreen> createState() => _StretchDetailScreenState();
}

class _StretchDetailScreenState extends State<StretchDetailScreen> {
  late String _level;
  bool _timerVisible = false;
  // Demo loops as a preview before the hold starts, then follows the timer.
  bool _demoPlaying = true;

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

  /// A short, glanceable form cue shown on the demo — the first clause of the
  /// first step, so the user reads "what to do" without parsing a paragraph.
  String? get _formCue {
    if (widget.stretch.steps.isEmpty) return null;
    final clause =
        widget.stretch.steps.first.split(RegExp(r'[,.;]')).first.trim();
    if (clause.isEmpty) return null;
    return clause.length <= 32 ? clause : '${clause.substring(0, 30).trim()}…';
  }

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
                    color: fav ? scheme.primary : null),
                onPressed: () => AppState.instance.toggleFavorite(s.id),
              );
            },
          ),
        ],
      ),
      body: MaxWidth(
        child: ListView(
        padding: const EdgeInsets.fromLTRB(
            AppSpacing.md, 0, AppSpacing.md, AppSpacing.xl),
        children: [
          // Intensity chooser, above the hero — set how far you go before you start.
          Text('Choose your intensity — go only as far as is comfortable',
              style: Theme.of(context)
                  .textTheme
                  .bodyMedium
                  ?.copyWith(color: scheme.onSurfaceVariant)),
          const SizedBox(height: AppSpacing.sm),
          _levelToggle(context),
          const SizedBox(height: AppSpacing.md),

          // Quick facts.
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
          const SizedBox(height: AppSpacing.md),

          // HERO: watch-and-copy demo with a glanceable form cue, the hold timer
          // right under it, and the breathing cue under that — so a user mid-hold
          // sees the body, the count, and the breath without scrolling.
          Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 380, maxHeight: 380),
              child: AspectRatio(
                aspectRatio: 1,
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    DecoratedBox(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: scheme.shadow.withValues(alpha: 0.12),
                            blurRadius: 18,
                            offset: const Offset(0, 6),
                          ),
                        ],
                      ),
                      child: DemoPlayer(stretch: s, playing: _demoPlaying),
                    ),
                    if (_formCue != null)
                      Positioned(
                        left: AppSpacing.sm,
                        right: AppSpacing.sm,
                        bottom: AppSpacing.sm,
                        child: _formCuePill(context, _formCue!),
                      ),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.md),

          Center(
            child: _timerVisible
                ? HoldTimerRing(
                    key: ValueKey('${s.id}_$_level'),
                    seconds: s.holdSeconds,
                    centerLabel: s.sides == 2 ? 'each side' : 'hold',
                    onComplete: () =>
                        AppState.instance.registerSessionComplete(),
                    onRunningChanged: (running) =>
                        setState(() => _demoPlaying = running),
                  )
                : SizedBox(
                    width: double.infinity,
                    child: FilledButton.icon(
                      style: FilledButton.styleFrom(
                        padding: const EdgeInsets.symmetric(
                            vertical: AppSpacing.md),
                      ),
                      onPressed: () => setState(() => _timerVisible = true),
                      icon: const Icon(Icons.play_arrow),
                      label: Text('Start ${s.holdSeconds}s hold'),
                    ),
                  ),
          ),
          const SizedBox(height: AppSpacing.md),

          if (s.breathingCue.isNotEmpty) _breathingBanner(context, s.breathingCue),
          const SizedBox(height: AppSpacing.lg),

          _section(context, 'How to do it'),
          for (int i = 0; i < s.steps.length; i++)
            _step(context, i + 1, s.steps[i]),
          const SizedBox(height: AppSpacing.md),

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

  /// Caption pill overlaid on the demo: a readable scrim so it stays legible
  /// over any frame, sized for older eyes.
  Widget _formCuePill(BuildContext c, String text) {
    final scheme = Theme.of(c).colorScheme;
    return Container(
      padding:
          const EdgeInsets.symmetric(horizontal: AppSpacing.md, vertical: 8),
      decoration: BoxDecoration(
        color: scheme.surface.withValues(alpha: 0.88),
        borderRadius: BorderRadius.circular(AppRadii.chip),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.accessibility_new_rounded,
              size: 16, color: scheme.primary),
          const SizedBox(width: 6),
          Flexible(
            child: Text(text,
                textAlign: TextAlign.center,
                style: Theme.of(c)
                    .textTheme
                    .titleSmall
                    ?.copyWith(color: scheme.onSurface)),
          ),
        ],
      ),
    );
  }

  /// The breathing cue, sitting directly under the timer in the brand colour so
  /// it's the clear secondary guidance during a hold. Announced to screen readers.
  Widget _breathingBanner(BuildContext c, String cue) {
    final scheme = Theme.of(c).colorScheme;
    return Semantics(
      liveRegion: true,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.air, size: 20, color: scheme.primary),
          const SizedBox(width: AppSpacing.sm),
          Flexible(
            child: Text(cue,
                textAlign: TextAlign.center,
                style: Theme.of(c).textTheme.titleMedium?.copyWith(
                    color: scheme.primary, fontWeight: FontWeight.w600)),
          ),
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
                    color: scheme.onSurface, fontWeight: FontWeight.w700)),
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
