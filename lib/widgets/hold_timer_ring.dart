import 'dart:math' as math;

import 'package:flutter/material.dart';

/// The hero component: a circular countdown ring for holding a stretch.
/// Tap the ring (or the Pause button) to pause/resume.
/// Calls [onComplete] when the hold finishes; [onSkip] (if given) renders a Skip button.
///
/// The ring sizes itself to the available width (clamped), so it never overflows
/// a small phone and isn't lost on a tablet. The centre label scales down to fit,
/// so large accessibility text can't push it out of the circle.
///
/// Accessibility: the ring is a live region announcing the remaining time (~every 5s),
/// and the Restart / Pause / Skip controls are labeled, focusable buttons (≥48dp).
class HoldTimerRing extends StatefulWidget {
  final int seconds;
  final VoidCallback? onComplete;
  final VoidCallback? onSkip;
  final String? centerLabel;
  final bool autoStart;

  /// Fires with `true` when the countdown is running and `false` when it pauses
  /// or completes. Lets a synced demo clip play/pause in time with the hold.
  final ValueChanged<bool>? onRunningChanged;

  const HoldTimerRing({
    super.key,
    required this.seconds,
    this.onComplete,
    this.onSkip,
    this.centerLabel,
    this.autoStart = true,
    this.onRunningChanged,
  });

  @override
  State<HoldTimerRing> createState() => _HoldTimerRingState();
}

class _HoldTimerRingState extends State<HoldTimerRing>
    with SingleTickerProviderStateMixin {
  late final AnimationController _c;

  @override
  void initState() {
    super.initState();
    _c = AnimationController(
      vsync: this,
      duration: Duration(seconds: widget.seconds),
    )..addStatusListener((s) {
        if (s == AnimationStatus.completed) widget.onComplete?.call();
        _notifyRunning();
      });
    if (widget.autoStart) {
      _c.forward();
      // Report initial running state after the first frame (callback may setState).
      WidgetsBinding.instance.addPostFrameCallback((_) => _notifyRunning());
    }
  }

  /// Tell the parent whether the countdown is currently running, so a synced
  /// demo clip can play/pause with it. `stop()` doesn't emit a status change,
  /// so we also call this explicitly from the pause/restart handlers.
  void _notifyRunning() {
    if (mounted) widget.onRunningChanged?.call(_c.isAnimating);
  }

  @override
  void dispose() {
    _c.dispose();
    super.dispose();
  }

  void _toggle() {
    setState(() {
      if (_c.isAnimating) {
        _c.stop();
      } else {
        _c.isCompleted ? _c.forward(from: 0) : _c.forward();
      }
    });
    _notifyRunning();
  }

  void _restart() {
    setState(() => _c.forward(from: 0));
    _notifyRunning();
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return LayoutBuilder(
      builder: (context, constraints) {
        final maxW = constraints.maxWidth.isFinite ? constraints.maxWidth : 320.0;
        final side = maxW.clamp(160.0, 280.0).toDouble();
        final stroke = (side * 0.06).clamp(10.0, 18.0).toDouble();
        final digitSize = side * 0.30;
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            AnimatedBuilder(
              animation: _c,
              builder: (context, _) {
                final remaining = (widget.seconds * (1 - _c.value)).ceil();
                // Announce in ~5s steps so the screen reader isn't chatty.
                final announce =
                    remaining <= 5 ? remaining : (remaining / 5).round() * 5;
                return Semantics(
                  container: true,
                  liveRegion: true,
                  label: 'Hold timer',
                  value: '$announce seconds remaining',
                  hint: _c.isAnimating
                      ? 'Double tap to pause'
                      : 'Double tap to resume',
                  onTap: _toggle,
                  child: GestureDetector(
                    onTap: _toggle,
                    child: SizedBox(
                      width: side,
                      height: side,
                      child: CustomPaint(
                        painter: _RingPainter(
                          progress: _c.value,
                          color: scheme.primary,
                          track: scheme.primary.withValues(alpha: 0.14),
                          strokeWidth: stroke,
                        ),
                        child: Padding(
                          padding: EdgeInsets.all(stroke + side * 0.12),
                          child: Center(
                            child: FittedBox(
                              fit: BoxFit.scaleDown,
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    '$remaining',
                                    style: Theme.of(context)
                                        .textTheme
                                        .displaySmall
                                        ?.copyWith(
                                            fontSize: digitSize,
                                            height: 1.0,
                                            color: scheme.onSurface),
                                  ),
                                  Text(
                                    widget.centerLabel ?? 'seconds',
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyMedium
                                        ?.copyWith(
                                            color: scheme.onSurfaceVariant),
                                  ),
                                  const SizedBox(height: 6),
                                  Icon(
                                    _c.isAnimating
                                        ? Icons.pause_rounded
                                        : Icons.play_arrow_rounded,
                                    color: scheme.primary,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
            const SizedBox(height: 16),
            // Labeled, focusable controls (switch-access / screen-reader friendly).
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  tooltip: 'Restart',
                  onPressed: _restart,
                  icon: const Icon(Icons.replay_rounded),
                ),
                const SizedBox(width: 8),
                AnimatedBuilder(
                  animation: _c,
                  builder: (context, _) => IconButton.filledTonal(
                    tooltip: _c.isAnimating ? 'Pause' : 'Resume',
                    onPressed: _toggle,
                    iconSize: 30,
                    // Primary control gets a larger 56dp target (design system §8.2).
                    style: IconButton.styleFrom(
                      minimumSize: const Size(56, 56),
                    ),
                    icon: Icon(_c.isAnimating
                        ? Icons.pause_rounded
                        : Icons.play_arrow_rounded),
                  ),
                ),
                if (widget.onSkip != null) ...[
                  const SizedBox(width: 8),
                  IconButton(
                    tooltip: 'Skip',
                    onPressed: widget.onSkip,
                    icon: const Icon(Icons.skip_next_rounded),
                  ),
                ],
              ],
            ),
          ],
        );
      },
    );
  }
}

class _RingPainter extends CustomPainter {
  final double progress; // 0 -> 1 elapsed
  final Color color;
  final Color track;
  final double strokeWidth;
  _RingPainter({
    required this.progress,
    required this.color,
    required this.track,
    required this.strokeWidth,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = size.center(Offset.zero);
    final radius = size.width / 2 - strokeWidth * 0.8;

    final trackPaint = Paint()
      ..color = track
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;
    final progPaint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;

    canvas.drawCircle(center, radius, trackPaint);
    final sweep = 2 * math.pi * (1 - progress);
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      -math.pi / 2,
      sweep,
      false,
      progPaint,
    );
  }

  @override
  bool shouldRepaint(covariant _RingPainter old) =>
      old.progress != progress ||
      old.color != color ||
      old.strokeWidth != strokeWidth;
}
