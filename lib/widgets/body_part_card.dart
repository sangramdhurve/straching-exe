import 'package:flutter/material.dart';

import '../core/constants/app_constants.dart';
import '../models/body_part.dart';

/// Tappable card for a body-part section on the Home grid.
class BodyPartCard extends StatelessWidget {
  final BodyPart bodyPart;
  final int count;
  final Color tint;
  final VoidCallback onTap;

  const BodyPartCard({
    super.key,
    required this.bodyPart,
    required this.count,
    required this.tint,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Card(
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.md),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 48,
                height: 48,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: tint,
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Image.asset(
                  'assets/icons/bodyparts/${bodyPart.id}.png',
                  width: 34,
                  height: 34,
                  excludeFromSemantics: true,
                  errorBuilder: (_, __, ___) =>
                      Icon(bodyPart.icon, color: scheme.primary),
                ),
              ),
              const SizedBox(height: AppSpacing.md),
              Text(
                bodyPart.name,
                style: Theme.of(context).textTheme.titleMedium,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 2),
              Text(
                '$count ${count == 1 ? 'stretch' : 'stretches'}',
                style: Theme.of(context)
                    .textTheme
                    .bodySmall
                    ?.copyWith(color: scheme.onSurfaceVariant),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
