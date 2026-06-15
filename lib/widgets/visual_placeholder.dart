import 'package:flutter/material.dart';

import '../core/app_state.dart';
import '../core/theme/app_colors.dart';
import '../models/body_part.dart';
import '../models/stretch.dart';

/// Shows the stretch's illustration if present, otherwise a friendly
/// tinted placeholder. Fills its parent — wrap it in a sized/aspect-ratio box.
/// The illustrations are square (1:1), so give it a square box to avoid cropping.
///
/// Accessibility: provides a screen-reader label, and when reduced motion is on
/// (OS setting or in-app toggle) it shows the static PNG instead of an animated GIF.
/// Listens to AppState so the in-app toggle takes effect immediately.
class VisualPlaceholder extends StatelessWidget {
  final Stretch stretch;
  const VisualPlaceholder({super.key, required this.stretch});

  @override
  Widget build(BuildContext context) {
    final bp = BodyPart.byId(stretch.bodyPartId);
    final tint =
        AppColors.tints[stretch.id.hashCode.abs() % AppColors.tints.length];

    return ListenableBuilder(
      listenable: AppState.instance,
      builder: (context, _) {
        final reduceMotion = MediaQuery.of(context).disableAnimations ||
            AppState.instance.reduceMotion;
        var path = stretch.assetFile;
        if (reduceMotion && path.toLowerCase().endsWith('.gif')) {
          path = '${path.substring(0, path.length - 4)}.png';
        }

        return ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: Image.asset(
            path,
            semanticLabel: '${stretch.name} demonstration',
            width: double.infinity,
            height: double.infinity,
            fit: BoxFit.cover,
            errorBuilder: (context, error, stack) => Container(
              color: tint,
              alignment: Alignment.center,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(bp?.icon ?? Icons.self_improvement,
                      size: 56, color: AppColors.primaryDark),
                  const SizedBox(height: 8),
                  Text(
                    'Visual coming soon',
                    style: TextStyle(
                      color: AppColors.primaryDark.withValues(alpha: 0.8),
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
