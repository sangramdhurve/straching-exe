import 'package:flutter/material.dart';

import '../../core/app_state.dart';
import '../../core/constants/app_constants.dart';
import '../home/main_shell.dart';

/// First-run welcome, a quick "what do you have at home?" step (personalizes
/// the daily pick), and the required health disclaimer.
class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  /// Props the user can toggle. "Floor / nothing" is always available, so it
  /// isn't listed here. Most homes have these, so start them on.
  final Set<String> _props = {'chair', 'wall', 'table', 'towel'};

  static const _propChoices = <String, ({IconData icon, String label})>{
    'chair': (icon: Icons.chair_alt_outlined, label: 'Chair'),
    'wall': (icon: Icons.crop_square_outlined, label: 'Wall'),
    'table': (icon: Icons.table_restaurant_outlined, label: 'Table'),
    'towel': (icon: Icons.dry_cleaning_outlined, label: 'Towel'),
    'bag': (icon: Icons.shopping_bag_outlined, label: 'Bag'),
  };

  Future<void> _finish() async {
    await AppState.instance.setAvailableProps(_props);
    await AppState.instance.completeOnboarding();
    if (mounted) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => const MainShell()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(AppSpacing.lg, AppSpacing.lg,
                    AppSpacing.lg, AppSpacing.md),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: 72,
                      height: 72,
                      decoration: BoxDecoration(
                        color: scheme.primary,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: const Icon(Icons.self_improvement,
                          color: Colors.white, size: 40),
                    ),
                    const SizedBox(height: AppSpacing.lg),
                    Text('Welcome to StretchHome',
                        style: Theme.of(context).textTheme.headlineMedium),
                    const SizedBox(height: AppSpacing.sm),
                    Text(
                      'Gentle, guided full-body stretches you can do at home — '
                      'using just a chair, a wall, or nothing at all. Free, for every age.',
                      style: Theme.of(context)
                          .textTheme
                          .bodyLarge
                          ?.copyWith(color: scheme.onSurfaceVariant),
                    ),
                    const SizedBox(height: AppSpacing.xl),
                    _bullet(context, Icons.spa_outlined, 'Stretching only',
                        'No equipment, no gym — just feel looser.'),
                    _bullet(context, Icons.favorite_outline,
                        'Safe for all ages',
                        'Gentle and supported options for everyone.'),
                    const SizedBox(height: AppSpacing.lg),

                    // ---- Personalization: what do you have nearby? ----
                    Text('What do you have nearby?',
                        style: Theme.of(context).textTheme.titleMedium),
                    const SizedBox(height: 2),
                    Text(
                      "We'll tailor your daily pick. Floor stretches are always "
                      'included. You can change this anytime.',
                      style: Theme.of(context)
                          .textTheme
                          .bodySmall
                          ?.copyWith(color: scheme.onSurfaceVariant),
                    ),
                    const SizedBox(height: AppSpacing.md),
                    Wrap(
                      spacing: AppSpacing.sm,
                      runSpacing: AppSpacing.sm,
                      children: [
                        for (final entry in _propChoices.entries)
                          FilterChip(
                            avatar: Icon(entry.value.icon,
                                size: 18,
                                color: _props.contains(entry.key)
                                    ? scheme.onSecondaryContainer
                                    : scheme.onSurfaceVariant),
                            label: Text(entry.value.label),
                            selected: _props.contains(entry.key),
                            onSelected: (sel) => setState(() {
                              if (sel) {
                                _props.add(entry.key);
                              } else {
                                _props.remove(entry.key);
                              }
                            }),
                          ),
                      ],
                    ),
                    const SizedBox(height: AppSpacing.lg),

                    Container(
                      padding: const EdgeInsets.all(AppSpacing.md),
                      decoration: BoxDecoration(
                        color: scheme.surfaceContainerHighest,
                        borderRadius: BorderRadius.circular(AppRadii.button),
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Icon(Icons.health_and_safety_outlined,
                              color: scheme.primary),
                          const SizedBox(width: AppSpacing.sm),
                          Expanded(
                            child: Text(
                              'This app offers general fitness information, not '
                              'medical advice. Move gently and stop if you feel '
                              'pain. Consult a doctor if you have an injury or '
                              'health condition.',
                              style: Theme.of(context)
                                  .textTheme
                                  .bodySmall
                                  ?.copyWith(color: scheme.onSurfaceVariant),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(
                  AppSpacing.lg, 0, AppSpacing.lg, AppSpacing.md),
              child: SizedBox(
                width: double.infinity,
                child: FilledButton(
                  onPressed: _finish,
                  child: const Text("I understand — let's stretch"),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _bullet(BuildContext c, IconData icon, String title, String sub) =>
      Padding(
        padding: const EdgeInsets.only(bottom: AppSpacing.md),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, color: Theme.of(c).colorScheme.primary),
            const SizedBox(width: AppSpacing.md),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: Theme.of(c).textTheme.titleMedium),
                  Text(sub,
                      style: Theme.of(c).textTheme.bodySmall?.copyWith(
                          color: Theme.of(c).colorScheme.onSurfaceVariant)),
                ],
              ),
            ),
          ],
        ),
      );
}
