import 'dart:math' as math;

import 'package:flutter/material.dart';

/// The hero component: a circular countdown ring for holding a stretch.
/// Tap to pause/resume. Calls [onComplete] when the hold finishes.
class HoldTimerRing extends StatefulWidget {
  final int seconds;
  final VoidCallback? onComplete;
  final String? centerLabel;
  final bool autoStart;

  const HoldTimerRing({
    super.key,
    required this.seconds,
    this.onComplete,
    this.centerLabel,
    this.autoStart = true,
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
      });
    if (widget.autoStart) _c.forward();
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
        if (_c.isCompleted) {
          _c.forward(from: 0);
        } else {
          _c.forward();
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return AnimatedBuilder(
      animation: _c,
      builder: (context, _) {
        final remaining = (widget.seconds * (1 - _c.value)).ceil();
        return GestureDetector(
          onTap: _toggle,
          child: SizedBox(
            width: 232,
            height: 232,
            child: CustomPaint(
              painter: _RingPainter(
                progress: _c.value,
                color: scheme.primary,
                track: scheme.primary.withValues(alpha: 0.14),
              ),
              child: Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      '$remaining',
                      style: Theme.of(context)
                          .textTheme
                          .displaySmall
                          ?.copyWith(fontSize: 66, color: scheme.onSurface),
                    ),
                    Text(
                      widget.centerLabel ?? 'seconds',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: scheme.onSurfaceVariant),
                    ),
                    const SizedBox(height: 6),
                    Icon(
                      _c.isAnimating ? Icons.pause_rounded : Icons.play_arrow_rounded,
                      color: scheme.primary,
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

class _RingPainter extends CustomPainter {
  final double progress; // 0 -> 1 elapsed
  final Color color;
  final Color track;
  _RingPainter({
    required this.progress,
    required this.color,
    required this.track,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = size.center(Offset.zero);
    final radius = size.width / 2 - 12;

    final trackPaint = Paint()
      ..color = track
      ..style = PaintingStyle.stroke
      ..strokeWidth = 14
      ..strokeCap = StrokeCap.round;
    final progPaint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 14
      ..strokeCap = StrokeCap.round;

    canvas.drawCircle(center, radius, trackPaint);
    // Arc shrinks clockwise as the hold counts down.
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
      old.progress != progress || old.color != color;
}
