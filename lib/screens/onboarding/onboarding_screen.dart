import 'package:flutter/material.dart';

import '../../core/app_state.dart';
import '../../core/constants/app_constants.dart';
import '../home/main_shell.dart';

/// First-run welcome + required health disclaimer.
class OnboardingScreen extends StatelessWidget {
  const OnboardingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.lg),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: AppSpacing.lg),
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
              _bullet(context, Icons.chair_alt_outlined, 'Simple home props',
                  "Chair, wall, table, towel — that's it."),
              _bullet(context, Icons.favorite_outline, 'Safe for all ages',
                  'Gentle and supported options for everyone.'),
              const Spacer(),
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
                        'This app offers general fitness information, not medical '
                        'advice. Move gently and stop if you feel pain. Consult a '
                        'doctor if you have an injury or health condition.',
                        style: Theme.of(context)
                            .textTheme
                            .bodySmall
                            ?.copyWith(color: scheme.onSurfaceVariant),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: AppSpacing.md),
              SizedBox(
                width: double.infinity,
                child: FilledButton(
                  onPressed: () async {
                    await AppState.instance.completeOnboarding();
                    if (context.mounted) {
                      Navigator.of(context).pushReplacement(
                        MaterialPageRoute(builder: (_) => const MainShell()),
                      );
                    }
                  },
                  child: const Text("I understand — let's stretch"),
                ),
              ),
              const SizedBox(height: AppSpacing.sm),
            ],
          ),
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
