import 'package:flutter/material.dart';

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
/// with a short rest between segments. NO ads ever appear here.
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
  }

  void _onSegmentDone() {
    if (_i >= _segments.length - 1) {
      setState(() => _done = true);
      AppState.instance.registerSessionComplete();
    } else {
      setState(() => _resting = true);
    }
  }

  void _onRestDone() => setState(() {
        _resting = false;
        _i++;
      });

  void _skip() => _resting ? _onRestDone() : _onSegmentDone();

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

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.lg),
          child: Column(
            children: [
              Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () => Navigator.pop(context),
                  ),
                  Expanded(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: LinearProgressIndicator(
                        value: progress,
                        minHeight: 8,
                        backgroundColor: scheme.surfaceContainerHighest,
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
                VisualPlaceholder(stretch: s, height: 170),
                const SizedBox(height: AppSpacing.lg),
                HoldTimerRing(
                  key: ValueKey('seg_$_i'),
                  seconds: s.holdSeconds,
                  centerLabel: seg.label,
                  onComplete: _onSegmentDone,
                ),
                const SizedBox(height: AppSpacing.md),
                Text(s.breathingCue,
                    textAlign: TextAlign.center,
                    style: Theme.of(context)
                        .textTheme
                        .bodyMedium
                        ?.copyWith(color: scheme.onSurfaceVariant)),
              ] else ...[
                Text('Rest', style: Theme.of(context).textTheme.headlineSmall),
                const SizedBox(height: 4),
                Text('Next: ${_segments[_i + 1].stretch.name}',
                    textAlign: TextAlign.center,
                    style: Theme.of(context)
                        .textTheme
                        .titleMedium
                        ?.copyWith(color: scheme.onSurfaceVariant)),
                const SizedBox(height: AppSpacing.lg),
                HoldTimerRing(
                  key: ValueKey('rest_$_i'),
                  seconds: AppDurations.restBetweenSeconds,
                  centerLabel: 'Rest',
                  onComplete: _onRestDone,
                ),
              ],
              const Spacer(),
              OutlinedButton.icon(
                onPressed: _skip,
                icon: const Icon(Icons.skip_next),
                label: Text(_resting ? 'Skip rest' : 'Next'),
              ),
            ],
          ),
        ),
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
              Icon(Icons.check_circle, color: scheme.tertiary, size: 96),
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
              // NOTE: This post-routine moment is the right place for an
              // OPTIONAL interstitial/rewarded ad later (see CLAUDE.md).
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
