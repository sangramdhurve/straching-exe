import 'dart:async';
import 'dart:ui' show PlatformDispatcher;

import 'package:flutter/material.dart';

import 'core/ad_service.dart';
import 'core/app_state.dart';
import 'core/theme/app_theme.dart';
import 'data/content_repository.dart';
import 'screens/home/main_shell.dart';
import 'screens/onboarding/onboarding_screen.dart';

void main() {
  // Run inside a guarded zone so no stray async error can hard-crash the app.
  runZonedGuarded<Future<void>>(() async {
    WidgetsFlutterBinding.ensureInitialized();

    // Surface framework + platform errors instead of dying to a blank screen.
    FlutterError.onError = FlutterError.presentError;
    PlatformDispatcher.instance.onError = (error, stack) {
      debugPrint('Uncaught platform error: $error\n$stack');
      return true; // handled — don't crash the process
    };

    // Render UI immediately. Content + saved state load inside _Bootstrap (with
    // a loader and a retry screen), so a slow/failed load never blanks the app.
    runApp(const StretchHomeApp());

    // AdMob is initialized AFTER the first frame and never awaited here. On some
    // real devices the native ads SDK can throw/hang on init; keeping it off the
    // startup path means the app still opens even if ads can't initialize.
    unawaited(AdService.instance.init());
  }, (error, stack) {
    debugPrint('Uncaught zone error: $error\n$stack');
  });
}

class StretchHomeApp extends StatelessWidget {
  const StretchHomeApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: AppState.instance,
      builder: (context, _) {
        final state = AppState.instance;
        return MaterialApp(
          title: 'StretchHome',
          debugShowCheckedModeBanner: false,
          theme: AppTheme.light(),
          darkTheme: AppTheme.dark(),
          themeMode: state.themeMode,
          // Accessibility: never shrink below 1.3x when large-text mode is on,
          // while still respecting larger system settings.
          builder: (context, child) => MediaQuery.withClampedTextScaling(
            minScaleFactor: state.largeText ? 1.3 : 1.0,
            child: child ?? const SizedBox.shrink(),
          ),
          home: const _Bootstrap(),
        );
      },
    );
  }
}

/// Loads bundled content + saved state with a spinner, and shows a friendly
/// retry screen if loading ever fails (e.g. a release asset issue) — instead
/// of crashing before the first frame.
class _Bootstrap extends StatefulWidget {
  const _Bootstrap();

  @override
  State<_Bootstrap> createState() => _BootstrapState();
}

class _BootstrapState extends State<_Bootstrap> {
  late Future<void> _future;

  @override
  void initState() {
    super.initState();
    _future = _load();
  }

  Future<void> _load() async {
    await ContentRepository.instance.load();
    await AppState.instance.load();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<void>(
      future: _future,
      builder: (context, snap) {
        if (snap.connectionState != ConnectionState.done) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }
        if (snap.hasError) {
          return _StartupError(
            onRetry: () => setState(() => _future = _load()),
          );
        }
        return AppState.instance.onboardingDone
            ? const MainShell()
            : const OnboardingScreen();
      },
    );
  }
}

class _StartupError extends StatelessWidget {
  final VoidCallback onRetry;
  const _StartupError({required this.onRetry});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(32),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.spa_outlined, size: 56, color: scheme.primary),
                const SizedBox(height: 16),
                Text('We couldn’t get things ready',
                    style: Theme.of(context).textTheme.titleLarge,
                    textAlign: TextAlign.center),
                const SizedBox(height: 8),
                Text(
                  'Please try again in a moment.',
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: scheme.onSurfaceVariant),
                ),
                const SizedBox(height: 24),
                FilledButton(onPressed: onRetry, child: const Text('Try again')),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
