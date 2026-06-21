import 'package:flutter/material.dart';

import '../../core/constants/app_constants.dart';
import '../../core/theme/app_gradients.dart';
import '../../data/content_repository.dart';
import '../../models/stretch.dart';
import '../../widgets/demo_player.dart';
import '../../widgets/responsive.dart';
import '../../widgets/visual_placeholder.dart';
import '../stretch/stretch_detail_screen.dart';

/// "Clips Library" — a browsable gallery of stretch demonstrations. A featured
/// video plays at the top (our timer-synced DemoPlayer) and every stretch is
/// listed with a poster thumbnail, target, and duration. Watch, learn, repeat.
class ClipsLibraryScreen extends StatelessWidget {
  const ClipsLibraryScreen({super.key});

  /// Still-image path to use as a thumbnail (posters for videos, the
  /// illustration otherwise).
  static String _thumbPath(Stretch s) {
    final f = s.assetFile.toLowerCase();
    if (f.endsWith('.mp4') || f.endsWith('.gif')) {
      return '${s.assetFile.substring(0, s.assetFile.length - 4)}.png';
    }
    return s.assetFile;
  }

  void _open(BuildContext context, Stretch s) => Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => StretchDetailScreen(stretch: s)),
      );

  @override
  Widget build(BuildContext context) {
    final repo = ContentRepository.instance;
    final all = repo.stretches;
    final text = Theme.of(context).textTheme;
    final scheme = Theme.of(context).colorScheme;

    // Feature a real video clip if one exists, else the first stretch.
    final featured = all.firstWhere(
      (s) => s.assetType == 'video',
      orElse: () => all.first,
    );

    return Scaffold(
      body: SafeArea(
        bottom: false,
        child: MaxWidth(
          child: ListView(
            padding: const EdgeInsets.fromLTRB(
                AppSpacing.md, AppSpacing.md, AppSpacing.md, AppSpacing.xxl),
            children: [
              Text('Clips Library', style: text.headlineMedium),
              const SizedBox(height: 4),
              Text(
                'Watch, learn & repeat — your personal guide to every move.',
                style: text.bodyMedium
                    ?.copyWith(color: scheme.onSurfaceVariant),
              ),
              const SizedBox(height: AppSpacing.lg),
              _featured(context, featured),
              const SizedBox(height: AppSpacing.lg),
              Text('All stretches', style: text.titleLarge),
              const SizedBox(height: AppSpacing.sm),
              for (final s in all) _clipRow(context, s),
            ],
          ),
        ),
      ),
    );
  }

  Widget _featured(BuildContext context, Stretch s) {
    final text = Theme.of(context).textTheme;
    return Semantics(
      button: true,
      label: 'Featured: ${s.name}',
      child: ClipRRect(
        borderRadius: BorderRadius.circular(AppRadii.card),
        child: GestureDetector(
          onTap: () => _open(context, s),
          child: AspectRatio(
            aspectRatio: 16 / 10,
            child: Stack(
              fit: StackFit.expand,
              children: [
                DemoPlayer(stretch: s, playing: true),
                const DecoratedBox(
                  decoration: BoxDecoration(gradient: AppGradients.photoScrim),
                ),
                Positioned(
                  left: AppSpacing.md,
                  right: AppSpacing.md,
                  bottom: AppSpacing.md,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text('FEATURED',
                                style: text.labelSmall?.copyWith(
                                    color:
                                        Colors.white.withValues(alpha: 0.85),
                                    letterSpacing: 1.4)),
                            const SizedBox(height: 4),
                            Text(s.name,
                                style: text.headlineSmall?.copyWith(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w700)),
                            const SizedBox(height: 2),
                            Text(s.durationLabel,
                                style: text.bodyMedium?.copyWith(
                                    color: Colors.white
                                        .withValues(alpha: 0.9))),
                          ],
                        ),
                      ),
                      Container(
                        width: 52,
                        height: 52,
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.25),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(Icons.play_arrow_rounded,
                            color: Colors.white, size: 30),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _clipRow(BuildContext context, Stretch s) {
    final text = Theme.of(context).textTheme;
    final scheme = Theme.of(context).colorScheme;
    final isVideo = s.assetType == 'video';
    return Card(
      margin: const EdgeInsets.only(bottom: AppSpacing.sm),
      child: InkWell(
        borderRadius: BorderRadius.circular(AppRadii.card),
        onTap: () => _open(context, s),
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.sm),
          child: Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(AppRadii.button),
                child: SizedBox(
                  width: 64,
                  height: 64,
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      Image.asset(
                        _thumbPath(s),
                        fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) => visualFallback(s),
                      ),
                      if (isVideo)
                        Center(
                          child: Container(
                            width: 26,
                            height: 26,
                            decoration: BoxDecoration(
                              color: Colors.black.withValues(alpha: 0.45),
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(Icons.play_arrow_rounded,
                                color: Colors.white, size: 18),
                          ),
                        ),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(s.name, style: text.titleMedium),
                    const SizedBox(height: 2),
                    Text(
                      s.targetMuscles.isNotEmpty
                          ? s.targetMuscles.join(', ')
                          : s.bodyPart,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: text.bodySmall
                          ?.copyWith(color: scheme.onSurfaceVariant),
                    ),
                    const SizedBox(height: 4),
                    Text(s.durationLabel,
                        style: text.labelMedium?.copyWith(
                            color: scheme.primary,
                            fontWeight: FontWeight.w600)),
                  ],
                ),
              ),
              Icon(Icons.chevron_right_rounded,
                  color: scheme.onSurfaceVariant),
            ],
          ),
        ),
      ),
    );
  }
}
