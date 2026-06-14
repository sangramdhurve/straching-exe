import 'package:flutter/material.dart';

import '../../core/app_state.dart';
import '../../core/constants/app_constants.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final state = AppState.instance;
    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: ListenableBuilder(
        listenable: state,
        builder: (context, _) => ListView(
          padding: const EdgeInsets.all(AppSpacing.md),
          children: [
            _label(context, 'Display'),
            SwitchListTile(
              title: const Text('Large text'),
              subtitle: const Text('Bigger, easier-to-read text'),
              value: state.largeText,
              onChanged: state.setLargeText,
            ),
            ListTile(
              leading: const Icon(Icons.brightness_6_outlined),
              title: const Text('Theme'),
              subtitle: Text(_themeLabel(state.themeMode)),
              trailing: const Icon(Icons.chevron_right),
              onTap: () => _pickTheme(context, state),
            ),
            const Divider(height: AppSpacing.xl),
            _label(context, 'About & legal'),
            ListTile(
              leading: const Icon(Icons.health_and_safety_outlined),
              title: const Text('Health disclaimer'),
              onTap: () => _showDisclaimer(context),
            ),
            ListTile(
              leading: const Icon(Icons.privacy_tip_outlined),
              title: const Text('Privacy policy'),
              subtitle: const Text('Required before adding ads'),
              onTap: () => _showPrivacyNote(context),
            ),
            const ListTile(
              leading: Icon(Icons.info_outline),
              title: Text('Version'),
              subtitle: Text('StretchHome 0.1.0 (MVP)'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _label(BuildContext c, String t) => Padding(
        padding: const EdgeInsets.only(
            left: AppSpacing.sm, top: AppSpacing.sm, bottom: AppSpacing.xs),
        child: Text(t,
            style: Theme.of(c).textTheme.labelLarge?.copyWith(
                color: Theme.of(c).colorScheme.primary)),
      );

  String _themeLabel(ThemeMode m) => switch (m) {
        ThemeMode.light => 'Light',
        ThemeMode.dark => 'Dark',
        ThemeMode.system => 'System default',
      };

  void _pickTheme(BuildContext context, AppState state) {
    showModalBottomSheet(
      context: context,
      builder: (ctx) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            for (final m in ThemeMode.values)
              ListTile(
                title: Text(_themeLabel(m)),
                trailing: state.themeMode == m
                    ? Icon(Icons.check,
                        color: Theme.of(ctx).colorScheme.primary)
                    : null,
                onTap: () {
                  state.setThemeMode(m);
                  Navigator.pop(ctx);
                },
              ),
          ],
        ),
      ),
    );
  }

  void _showDisclaimer(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Health disclaimer'),
        content: const Text(
          'StretchHome offers general fitness information, not medical advice. '
          'Move gently and within a comfortable range. Stop immediately if you '
          'feel pain, dizziness, or discomfort. Consult a healthcare provider '
          'before starting if you are pregnant, recovering from injury, or have '
          'any medical condition.',
        ),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: const Text('Got it')),
        ],
      ),
    );
  }

  void _showPrivacyNote(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Privacy policy'),
        content: const Text(
          'Host your privacy policy online and link it here (use url_launcher). '
          'A public policy is required by Google Play, the App Store, and AdMob '
          'before you ship ads. See CLAUDE.md → "Before launch" for the steps.',
        ),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: const Text('Close')),
        ],
      ),
    );
  }
}
