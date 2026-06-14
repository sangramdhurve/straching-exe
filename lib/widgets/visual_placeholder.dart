import 'package:flutter/material.dart';

import '../core/theme/app_colors.dart';
import '../models/body_part.dart';
import '../models/stretch.dart';

/// Shows the stretch's illustration if present, otherwise a friendly
/// tinted placeholder. This lets the app run before real visuals are added —
/// drop a PNG at [Stretch.assetFile] and it appears automatically.
class VisualPlaceholder extends StatelessWidget {
  final Stretch stretch;
  final double? height;
  const VisualPlaceholder({super.key, required this.stretch, this.height});

  @override
  Widget build(BuildContext context) {
    final bp = BodyPart.byId(stretch.bodyPartId);
    final tint =
        AppColors.tints[stretch.id.hashCode.abs() % AppColors.tints.length];

    return ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: Image.asset(
        stretch.assetFile,
        height: height,
        width: double.infinity,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stack) => Container(
          height: height,
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
  }
}
