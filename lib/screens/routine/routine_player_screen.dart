import 'package:flutter/material.dart';

import '../../core/ad_service.dart';
import '../../core/app_state.dart';
import '../../core/constants/app_constants.dart';
import '../../data/content_repository.dart';
import '../../models/routine.dart';
import '../../models/stretch.dart';
import '../../widgets/hold_timer_ring.dart';
import '../../widgets/visual_placeholder.dart';

class _Segment {
  final Stretch stretch;
  final String label;
  _Segment(this.stretch, this.label);
}

/// Full-screen guided player that auto-advances through a routine,
/// with a short rest between segments. NO ads ever appear here — the only
/// (optional, frequency-capped) ad fires after the completion screen renders.
class RoutinePlayerScreen extends StatefulWidget {
  final Routine routine;
  const RoutinePlayerScreen({super.key, required this.routine});

  @override
  State<RoutinePlayerScreen> createState() => _RoutinePlayerScreenState();
}

class _RoutinePlayerScreenState extends State<RoutinePlayerScreen> {
  final List<_Segment> _segments = [];
  int _i = 0;
  bool _resting = false;
  bool _done = false;

  @override
  void initState() {
    super.initState();
    final stretches =
        ContentRepository.instance.stretchesForRoutine(widget.routine);
    for (final s in stretches) {
      if (s.sides == 2) {
        _segments.add(_Segment(s, 'Right side'));
        _segments.add(_Segment(s, 'Left side'));
      } else {
        _segments.add(_Segment(s, 'Hold'));
      }
    }
    AdService.instance.preloadInterstitial();
  }

  void _onSegmentDone() {
    if (_i >= _segments.length - 1) {
      setState(() => _done = true);
      AppState.instance.registerSessionComplete();
      // Let the "Nicely done!" screen paint first, then (maybe) show the ad.
      Future.delayed(const Duration(milliseconds: 400),
          AdService.instance.onRoutineComplete);
    } else {
      setState(() => _resting = true);
    }
  }

  void _onRestDone() => setState(() {
        _resting = false;
        _i++;
      });

  Future<bool> _confirmExit() async {
    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Leave routine?'),
        content:
            const Text("Your progress in this routine won't be saved."),
        actions: [
          TextButton(
              autofocus: true,
              onPressed: () => Navigator.pop(ctx, false),
              child: const Text('Keep going')),
          FilledButton(
              onPressed: () => Navigator.pop(ctx, true),
              child: const Text('Leave')),
        ],
      ),
    );
    return ok ?? false;
  }

  Future<void> _handleExit() async {
    if (await _confirmExit() && mounted) {
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_segments.isEmpty) {
      return Scaffold(
        appBar: AppBar(),
        body: const Center(child: Text('This routine has no stretches yet.')),
      );
    }
    if (_done) return _completion(context);

    final scheme = Theme.of(context).colorScheme;
    final seg = _segments[_i];
    final s = seg.stretch;
    final progress = (_i + 1) / _segments.length;

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) async {
        if (didPop) return;
        if (await _confirmExit() && mounted) Navigator.of(context).pop();
      },
      child: Scaffold(
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(AppSpacing.lg),
            child: Column(
              children: [
                Row(
                  children: [
                    IconButton(
                      tooltip: 'Exit routine',
                      icon: const Icon(Icons.close),
                      onPressed: _handleExit,
                    ),
                    Expanded(
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: LinearProgressIndicator(
                          value: progress,
                          minHeight: 8,
                          backgroundColor: scheme.surfaceContainerHighest,
                          semanticsLabel: 'Routine progress',
                          semanticsValue: '${_i + 1} of ${_segments.length}',
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Text('${_i + 1}/${_segments.length}'),
                  ],
                ),
                const Spacer(),
                if (!_resting) ...[
                  Text(s.name,
                      style: Theme.of(context).textTheme.headlineSmall,
                      textAlign: TextAlign.center),
                  const SizedBox(height: 4),
                  Text(seg.label,
                      style: Theme.of(context)
                          .textTheme
                          .titleMedium
                          ?.copyWith(color: scheme.primary)),
                  const SizedBox(height: AppSpacing.lg),
                  ConstrainedBox(
                    constraints:
                        const BoxConstraints(maxWidth: 200, maxHeight: 200),
                    child: AspectRatio(
                      aspectRatio: 1,
                      child: VisualPlaceholder(stretch: s),
                    ),
                  ),
                  const SizedBox(height: AppSpacing.lg),
                  HoldTimerRing(
                    key: ValueKey('seg_$_i'),
                    seconds: s.holdSeconds,
                    centerLabel: seg.label,
                    onComplete: _onSegmentDone,
                    onSkip: _onSegmentDone,
                  ),
                  const SizedBox(height: AppSpacing.md),
                  Text(s.breathingCue,
                      textAlign: TextAlign.center,
                      style: Theme.of(context)
                          .textTheme
                          .bodyMedium
                          ?.copyWith(color: scheme.onSurfaceVariant)),
                ] else ...[
                  Text('Rest',
                      style: Theme.of(context).textTheme.headlineSmall),
                  const SizedBox(height: 4),
                  Text('Next: ${_segments[_i + 1].stretch.name}',
                      textAlign: TextAlign.center,
                      style: Theme.of(context)
                          .textTheme
                          .titleMedium
                          ?.copyWith(color: scheme.onSurfaceVariant)),
                  const SizedBox(height: AppSpacing.md),
                  ConstrainedBox(
                    constraints:
                        const BoxConstraints(maxWidth: 130, maxHeight: 130),
                    child: AspectRatio(
                      aspectRatio: 1,
                      child: VisualPlaceholder(
                          stretch: _segments[_i + 1].stretch),
                    ),
                  ),
                  const SizedBox(height: AppSpacing.lg),
                  HoldTimerRing(
                    key: ValueKey('rest_$_i'),
                    seconds: AppDurations.restBetweenSeconds,
                    centerLabel: 'Rest',
                    onComplete: _onRestDone,
                    onSkip: _onRestDone,
                  ),
                ],
                const Spacer(),
              ],
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
                ?.copyWith(color: scheme.primary)),
        Text(label,
            style: Theme.of(c)
                .textTheme
                .bodySmall
                ?.copyWith(color: scheme.onSurfaceVariant)),
      ],
    );
  }

  /// A one-shot "bloom": a soft glow ring expands behind the check while the
  /// check scales up. Honors reduce-motion (renders the final frame instantly).
  Widget _bloomCheck(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final reduce = MediaQuery.of(context).disableAnimations ||
        AppState.instance.reduceMotion;
    return ExcludeSemantics(
      child: TweenAnimationBuilder<double>(
        tween: Tween(begin: reduce ? 1.0 : 0.0, end: 1.0),
        duration: reduce ? Duration.zero : const Duration(milliseconds: 700),
        curve: Curves.easeOutBack,
        builder: (context, t, _) {
          final tc = t.clamp(0.0, 1.0);
          return SizedBox(
            width: 150,
            height: 150,
            child: Stack(
              alignment: Alignment.center,
              children: [
                Container(
                  width: 150 * tc,
                  height: 150 * tc,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: RadialGradient(
                      colors: [
                        scheme.tertiary.withValues(alpha: 0.28 * (1 - tc)),
                        scheme.tertiary.withValues(alpha: 0.0),
                      ],
                    ),
                  ),
                ),
                Transform.scale(
                  scale: 0.6 + 0.4 * tc,
                  child: Icon(Icons.check_circle,
                      color: scheme.tertiary, size: 96),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _completion(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.lg),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Center(child: _bloomCheck(context)),
              const SizedBox(height: AppSpacing.md),
              Text('Nicely done!',
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.headlineMedium),
              const SizedBox(height: AppSpacing.sm),
              Text(
                'You finished "${widget.routine.name}". Your body thanks you.',
                textAlign: TextAlign.center,
                style: Theme.of(context)
                    .textTheme
                    .bodyLarge
                    ?.copyWith(color: scheme.onSurfaceVariant),
              ),
              const SizedBox(height: AppSpacing.xl),
              ListenableBuilder(
                listenable: AppState.instance,
                builder: (context, _) => Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _stat(context, '${widget.routine.stretchIds.length}',
                        'stretches'),
                    _stat(context, '${widget.routine.minutes}', 'minutes'),
                    _stat(
                        context,
                        '${AppState.instance.streak}',
                        AppState.instance.streak == 1
                            ? 'day — nice start!'
                            : 'day streak'),
                  ],
                ),
              ),
              const SizedBox(height: AppSpacing.xl),
              FilledButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Done'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
