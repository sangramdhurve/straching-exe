import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../core/app_state.dart';
import '../../core/constants/app_constants.dart';
import '../../widgets/responsive.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final state = AppState.instance;
    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: ListenableBuilder(
        listenable: state,
        builder: (context, _) => MaxWidth(
          child: ListView(
          padding: const EdgeInsets.all(AppSpacing.md),
          children: [
            _label(context, 'Display'),
            SwitchListTile(
              secondary: const Icon(Icons.format_size),
              title: const Text('Large text'),
              subtitle: const Text('Bigger, easier-to-read text'),
              value: state.largeText,
              onChanged: state.setLargeText,
            ),
            SwitchListTile(
              secondary: const Icon(Icons.motion_photos_paused_outlined),
              title: const Text('Reduce motion'),
              subtitle: const Text('Show still images instead of animations'),
              value: state.reduceMotion,
              onChanged: state.setReduceMotion,
            ),
            ListTile(
              leading: const Icon(Icons.brightness_6_outlined),
              title: const Text('Theme'),
              subtitle: Text(_themeLabel(state.themeMode)),
              trailing: const Icon(Icons.chevron_right),
              onTap: () => _pickTheme(context, state),
            ),
            const Divider(height: AppSpacing.xl),
            _label(context, 'Personalize'),
            ListTile(
              leading: const Icon(Icons.chair_alt_outlined),
              title: const Text('Home props'),
              subtitle: Text(_propsSummary(state)),
              trailing: const Icon(Icons.chevron_right),
              onTap: () => _editProps(context, state),
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
              subtitle: const Text('Opens in your browser'),
              onTap: () => _openUrl(context, Links.privacyPolicy),
            ),
            ListTile(
              leading: const Icon(Icons.feedback_outlined),
              title: const Text('Send feedback'),
              subtitle: const Text('support@garibaitservices.com'),
              onTap: () => _openUrl(context,
                  'mailto:support@garibaitservices.com?subject=StretchHome%20feedback'),
            ),
            const ListTile(
              leading: Icon(Icons.info_outline),
              title: Text('Version'),
              subtitle: Text('StretchHome 0.1.0 (MVP)'),
            ),
          ],
        ),
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

  static const _propLabels = <String, String>{
    'chair': 'Chair',
    'wall': 'Wall',
    'table': 'Table',
    'towel': 'Towel',
    'bag': 'Bag',
  };

  static const _propIcons = <String, IconData>{
    'chair': Icons.chair_alt_outlined,
    'wall': Icons.crop_square_outlined,
    'table': Icons.table_restaurant_outlined,
    'towel': Icons.dry_cleaning_outlined,
    'bag': Icons.shopping_bag_outlined,
  };

  String _propsSummary(AppState s) {
    if (s.availableProps.isEmpty) return 'Floor only';
    if (s.availableProps.length == _propLabels.length) return 'All props';
    final names = _propLabels.keys
        .where(s.availableProps.contains)
        .map((p) => _propLabels[p]!)
        .toList();
    return names.join(', ');
  }

  void _editProps(BuildContext context, AppState state) {
    final selected = {...state.availableProps};
    showModalBottomSheet(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setSheet) => SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(AppSpacing.lg),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('What do you have nearby?',
                    style: Theme.of(ctx).textTheme.titleMedium),
                const SizedBox(height: 2),
                Text('Floor stretches are always included.',
                    style: Theme.of(ctx).textTheme.bodySmall?.copyWith(
                        color: Theme.of(ctx).colorScheme.onSurfaceVariant)),
                const SizedBox(height: AppSpacing.md),
                Wrap(
                  spacing: AppSpacing.sm,
                  runSpacing: AppSpacing.sm,
                  children: [
                    for (final e in _propLabels.entries)
                      FilterChip(
                        avatar: Icon(_propIcons[e.key],
                            size: 18,
                            color: selected.contains(e.key)
                                ? Theme.of(ctx).colorScheme.onSecondaryContainer
                                : Theme.of(ctx).colorScheme.onSurfaceVariant),
                        label: Text(e.value),
                        selected: selected.contains(e.key),
                        onSelected: (sel) => setSheet(() {
                          if (sel) {
                            selected.add(e.key);
                          } else {
                            selected.remove(e.key);
                          }
                        }),
                      ),
                  ],
                ),
                const SizedBox(height: AppSpacing.lg),
                SizedBox(
                  width: double.infinity,
                  child: FilledButton(
                    onPressed: () {
                      state.setAvailableProps(selected);
                      Navigator.pop(ctx);
                    },
                    child: const Text('Save'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

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

  Future<void> _openUrl(BuildContext context, String url) async {
    bool ok = false;
    try {
      ok = await launchUrl(Uri.parse(url),
          mode: LaunchMode.externalApplication);
    } catch (_) {
      ok = false;
    }
    if (!ok && context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Couldn't open that link.")),
      );
    }
  }
}
