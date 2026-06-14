import 'package:flutter/material.dart';

import '../core/constants/app_constants.dart';
import '../models/stretch.dart';
import 'prop_badge.dart';

/// List row for a single stretch (used in body-part lists and Favorites).
class StretchTile extends StatelessWidget {
  final Stretch stretch;
  final VoidCallback onTap;
  final bool isFavorite;
  final VoidCallback? onFavorite;

  const StretchTile({
    super.key,
    required this.stretch,
    required this.onTap,
    this.isFavorite = false,
    this.onFavorite,
  });

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Card(
      margin: const EdgeInsets.only(bottom: AppSpacing.sm),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.md, vertical: AppSpacing.sm),
        onTap: onTap,
        title: Text(stretch.name, style: Theme.of(context).textTheme.titleMedium),
        subtitle: Padding(
          padding: const EdgeInsets.only(top: 6),
          child: Wrap(
            spacing: 6,
            runSpacing: 6,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              _meta(context, Icons.timer_outlined, stretch.durationLabel),
              for (final p in stretch.props.where((p) => p != 'none'))
                PropBadge(prop: p),
            ],
          ),
        ),
        trailing: onFavorite == null
            ? const Icon(Icons.chevron_right)
            : IconButton(
                icon: Icon(
                  isFavorite ? Icons.favorite : Icons.favorite_border,
                  color: isFavorite ? scheme.error : scheme.onSurfaceVariant,
                ),
                onPressed: onFavorite,
              ),
      ),
    );
  }

  Widget _meta(BuildContext c, IconData icon, String text) => Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: Theme.of(c).colorScheme.onSurfaceVariant),
          const SizedBox(width: 4),
          Text(text, style: Theme.of(c).textTheme.bodySmall),
        ],
      );
}
