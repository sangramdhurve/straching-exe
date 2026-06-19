import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

import '../core/app_state.dart';
import '../models/stretch.dart';
import 'visual_placeholder.dart';

/// Shows a stretch's demonstration. For a `video`-type stretch it plays the
/// looping human demo clip (`assets/visuals/<id>.mp4`) in sync with the hold
/// timer; for everything else it delegates to [VisualPlaceholder] (PNG / GIF).
///
/// Behaviour:
/// - The clip loops, is muted, and is cropped to fill its (square) box.
/// - [playing] binds to the timer: the clip only advances while the hold is
///   running, so the on-screen body matches the real exercise timing. Pause the
///   timer and the demo freezes on the current pose.
/// - The poster frame (`<id>.png`) shows instantly while the video initialises,
///   and is shown *instead* of the video when reduce-motion is on (OS setting or
///   the in-app toggle) — mirroring [VisualPlaceholder]'s gif→png behaviour.
/// - Any load/decoder error falls back to the shared tinted [visualFallback].
///
/// Listens to [AppState] so the in-app reduce-motion toggle takes effect live.
class DemoPlayer extends StatefulWidget {
  final Stretch stretch;

  /// Whether the demo should be advancing right now (typically the timer's
  /// running state). When false, the clip pauses on its current frame.
  final bool playing;

  const DemoPlayer({super.key, required this.stretch, this.playing = true});

  @override
  State<DemoPlayer> createState() => _DemoPlayerState();
}

class _DemoPlayerState extends State<DemoPlayer> {
  VideoPlayerController? _controller;
  bool _initialized = false;
  bool _errored = false;

  bool get _isVideo =>
      widget.stretch.assetType == 'video' &&
      widget.stretch.assetFile.toLowerCase().endsWith('.mp4');

  /// Poster image that accompanies every video clip: same path, `.png`.
  String get _posterPath {
    final f = widget.stretch.assetFile;
    return f.toLowerCase().endsWith('.mp4')
        ? '${f.substring(0, f.length - 4)}.png'
        : f;
  }

  @override
  void initState() {
    super.initState();
    if (_isVideo) _initController();
  }

  Future<void> _initController() async {
    final c = VideoPlayerController.asset(widget.stretch.assetFile);
    _controller = c;
    try {
      await c.initialize();
      await c.setLooping(true);
      await c.setVolume(0);
      if (!mounted) {
        c.dispose();
        return;
      }
      setState(() => _initialized = true);
    } catch (_) {
      if (mounted) setState(() => _errored = true);
    }
  }

  @override
  void didUpdateWidget(covariant DemoPlayer old) {
    super.didUpdateWidget(old);
    // A different stretch reuses this State — rebuild the controller.
    if (old.stretch.id != widget.stretch.id) {
      _controller?.dispose();
      _controller = null;
      _initialized = false;
      _errored = false;
      if (_isVideo) _initController();
    }
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  /// Drive play/pause to match [widget.playing] and reduce-motion. Called
  /// post-frame so we never touch the controller during build.
  void _syncPlayback(bool shouldPlay) {
    final c = _controller;
    if (c == null || !_initialized) return;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted || _controller != c) return;
      if (shouldPlay && !c.value.isPlaying) {
        c.play();
      } else if (!shouldPlay && c.value.isPlaying) {
        c.pause();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    // Non-video stretches keep the existing illustration path untouched.
    if (!_isVideo) return VisualPlaceholder(stretch: widget.stretch);

    return ListenableBuilder(
      listenable: AppState.instance,
      builder: (context, _) {
        final reduceMotion = MediaQuery.of(context).disableAnimations ||
            AppState.instance.reduceMotion;

        if (_errored) {
          return ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: visualFallback(widget.stretch),
          );
        }

        final showVideo = _initialized && !reduceMotion;
        _syncPlayback(showVideo && widget.playing);

        return ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: Stack(
            fit: StackFit.expand,
            children: [
              // Poster: instant, and the sole visual under reduce-motion / while loading.
              Image.asset(
                _posterPath,
                semanticLabel: '${widget.stretch.name} demonstration',
                fit: BoxFit.cover,
                errorBuilder: (context, error, stack) =>
                    visualFallback(widget.stretch),
              ),
              if (showVideo)
                FittedBox(
                  fit: BoxFit.cover,
                  clipBehavior: Clip.hardEdge,
                  child: SizedBox(
                    width: _controller!.value.size.width,
                    height: _controller!.value.size.height,
                    child: VideoPlayer(_controller!),
                  ),
                ),
            ],
          ),
        );
      },
    );
  }
}
