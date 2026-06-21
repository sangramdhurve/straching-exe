import 'package:flutter/material.dart';

import '../core/constants/app_constants.dart';

class FloatingNavItem {
  final IconData icon;
  final IconData selectedIcon;
  final String label;
  const FloatingNavItem(
      {required this.icon, required this.selectedIcon, required this.label});
}

/// A floating capsule bottom-nav (the reference look): a rounded, shadowed pill
/// where the active tab expands into a filled primary capsule with icon + label,
/// and inactive tabs are icon-only. Content scrolls under it (use
/// `Scaffold(extendBody: true)`).
///
/// Accessibility: each tab is a 48dp Semantics button reporting its selected
/// state; the whole bar scales down (never overflows) at large text.
class FloatingNavBar extends StatelessWidget {
  final int index;
  final ValueChanged<int> onTap;
  final List<FloatingNavItem> items;

  const FloatingNavBar({
    super.key,
    required this.index,
    required this.onTap,
    required this.items,
  });

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return SafeArea(
      top: false,
      child: Container(
        margin: const EdgeInsets.fromLTRB(
            AppSpacing.md, 0, AppSpacing.md, AppSpacing.sm),
        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 6),
        decoration: BoxDecoration(
          color: scheme.surface,
          borderRadius: BorderRadius.circular(AppRadii.chip),
          boxShadow: [
            BoxShadow(
              color: scheme.shadow.withValues(alpha: 0.16),
              blurRadius: 20,
              offset: const Offset(0, 6),
            ),
          ],
          border: Border.all(color: scheme.outlineVariant.withValues(alpha: 0.5)),
        ),
        child: FittedBox(
          fit: BoxFit.scaleDown,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              for (var i = 0; i < items.length; i++)
                _NavPill(
                  item: items[i],
                  selected: i == index,
                  onTap: () => onTap(i),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class _NavPill extends StatelessWidget {
  final FloatingNavItem item;
  final bool selected;
  final VoidCallback onTap;
  const _NavPill(
      {required this.item, required this.selected, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final text = Theme.of(context).textTheme;
    return Semantics(
      button: true,
      selected: selected,
      label: item.label,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppRadii.chip),
        child: AnimatedContainer(
          duration: AppDurations.fast,
          curve: Curves.easeOutCubic,
          height: 48,
          padding: EdgeInsets.symmetric(horizontal: selected ? 16 : 14),
          margin: const EdgeInsets.symmetric(horizontal: 2),
          decoration: BoxDecoration(
            color: selected ? scheme.primary : Colors.transparent,
            borderRadius: BorderRadius.circular(AppRadii.chip),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(selected ? item.selectedIcon : item.icon,
                  size: 24,
                  color:
                      selected ? scheme.onPrimary : scheme.onSurfaceVariant),
              if (selected) ...[
                const SizedBox(width: 8),
                Text(item.label,
                    style: text.labelLarge?.copyWith(
                        color: scheme.onPrimary, fontWeight: FontWeight.w600)),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
