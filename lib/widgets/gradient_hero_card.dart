import 'package:flutter/material.dart';

import '../core/constants/app_constants.dart';
import '../core/theme/app_gradients.dart';

/// The "fresh look" hero card: a teal gradient panel with an optional big
/// numeral, a heading, a sub-line, and a circular call-to-action button —
/// the premium pattern from the reference, on-brand.
///
/// All focal text is white, bold, and large (passes WCAG AA on the teal
/// gradient); a faint scrim deepens the panel so text stays legible.
class GradientHeroCard extends StatelessWidget {
  final String? eyebrow; // small overline, e.g. "TODAY'S PICK"
  final String title;
  final String? subtitle;
  final String? bigNumber; // e.g. "8"
  final String? bigNumberLabel; // e.g. "min"
  final IconData ctaIcon;
  final IconData? leadingIcon; // shown instead of a number, when set
  final Gradient gradient;
  final VoidCallback onTap;
  final String? semanticLabel;

  const GradientHeroCard({
    super.key,
    this.eyebrow,
    required this.title,
    this.subtitle,
    this.bigNumber,
    this.bigNumberLabel,
    this.ctaIcon = Icons.arrow_outward_rounded,
    this.leadingIcon,
    this.gradient = AppGradients.hero,
    required this.onTap,
    this.semanticLabel,
  });

  @override
  Widget build(BuildContext context) {
    final text = Theme.of(context).textTheme;
    return Semantics(
      button: true,
      label: semanticLabel ?? title,
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(AppRadii.card),
        clipBehavior: Clip.antiAlias,
        child: Ink(
          decoration: BoxDecoration(
            gradient: gradient,
            borderRadius: BorderRadius.circular(AppRadii.card),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFF177F72).withValues(alpha: 0.30),
                blurRadius: 22,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: InkWell(
            onTap: onTap,
            child: DecoratedBox(
              // Faint scrim to deepen the lighter end of the gradient for text.
              decoration: BoxDecoration(
                color: Colors.black.withValues(alpha: 0.06),
                borderRadius: BorderRadius.circular(AppRadii.card),
              ),
              child: Padding(
                padding: const EdgeInsets.all(AppSpacing.lg),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (eyebrow != null) ...[
                      Text(eyebrow!,
                          style: text.labelSmall?.copyWith(
                              color: Colors.white.withValues(alpha: 0.85),
                              letterSpacing: 1.4,
                              fontWeight: FontWeight.w600)),
                      const SizedBox(height: AppSpacing.sm),
                    ],
                    if (bigNumber != null)
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.baseline,
                        textBaseline: TextBaseline.alphabetic,
                        children: [
                          Text(bigNumber!,
                              style: text.displayMedium?.copyWith(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w700,
                                  height: 1.0)),
                          if (bigNumberLabel != null) ...[
                            const SizedBox(width: 6),
                            Padding(
                              padding: const EdgeInsets.only(bottom: 4),
                              child: Text(bigNumberLabel!,
                                  style: text.titleMedium?.copyWith(
                                      color: Colors.white
                                          .withValues(alpha: 0.9))),
                            ),
                          ],
                        ],
                      )
                    else if (leadingIcon != null)
                      Icon(leadingIcon, color: Colors.white, size: 34),
                    if (bigNumber != null || leadingIcon != null)
                      const SizedBox(height: AppSpacing.sm),
                    Text(title,
                        style: text.headlineSmall?.copyWith(
                            color: Colors.white, fontWeight: FontWeight.w700)),
                    if (subtitle != null) ...[
                      const SizedBox(height: 4),
                      Text(subtitle!,
                          style: text.bodyMedium?.copyWith(
                              color: Colors.white.withValues(alpha: 0.92))),
                    ],
                    const SizedBox(height: AppSpacing.md),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Container(
                          width: 48,
                          height: 48,
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.22),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(ctaIcon, color: Colors.white, size: 24),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
