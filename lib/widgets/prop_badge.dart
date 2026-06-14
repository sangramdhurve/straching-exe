import 'package:flutter/material.dart';

/// Small pill showing which household prop a stretch uses (chair, wall, etc.).
class PropBadge extends StatelessWidget {
  final String prop;
  const PropBadge({super.key, required this.prop});

  IconData get _icon {
    switch (prop) {
      case 'chair':
        return Icons.chair_alt_outlined;
      case 'wall':
        return Icons.crop_square_outlined;
      case 'table':
        return Icons.table_restaurant_outlined;
      case 'towel':
        return Icons.dry_cleaning_outlined;
      case 'bag':
        return Icons.shopping_bag_outlined;
      default:
        return Icons.accessibility_new;
    }
  }

  String get _label => prop.isEmpty ? prop : prop[0].toUpperCase() + prop.substring(1);

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: scheme.secondary.withValues(alpha: 0.16),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(_icon, size: 13, color: scheme.secondary),
          const SizedBox(width: 4),
          Text(_label,
              style: TextStyle(fontSize: 11, color: scheme.onSurface)),
        ],
      ),
    );
  }
}
