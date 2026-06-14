import 'package:flutter/material.dart';

import 'core/ad_service.dart';
import 'core/app_state.dart';
import 'core/theme/app_theme.dart';
import 'data/content_repository.dart';
import 'screens/home/main_shell.dart';
import 'screens/onboarding/onboarding_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // Load bundled content + saved user state before first frame.
  await ContentRepository.instance.load();
  await AppState.instance.load();
  // Initialize AdMob (no-op if ads are disabled). Safe to await — it's quick.
  await AdService.instance.init();
  runApp(const StretchHomeApp());
}

class StretchHomeApp extends StatelessWidget {
  const StretchHomeApp({super.key});

  @override
  Widget build(BuildContext context) {
    final state = AppState.instance;
    return ListenableBuilder(
      listenable: state,
      builder: (context, _) {
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
          home: state.onboardingDone
              ? const MainShell()
              : const OnboardingScreen(),
        );
      },
    );
  }
}
