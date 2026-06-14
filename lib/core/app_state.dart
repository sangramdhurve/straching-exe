import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'constants/app_constants.dart';

/// App-wide user state, persisted on-device with shared_preferences.
/// Favorites, accessibility, theme, and a simple daily streak.
class AppState extends ChangeNotifier {
  AppState._();
  static final AppState instance = AppState._();

  SharedPreferences? _prefs;
  final Set<String> _favorites = {};
  bool _largeText = false;
  ThemeMode _themeMode = ThemeMode.system;
  int _streak = 0;
  bool onboardingDone = false;

  Set<String> get favorites => _favorites;
  bool get largeText => _largeText;
  ThemeMode get themeMode => _themeMode;
  int get streak => _streak;

  Future<void> load() async {
    _prefs = await SharedPreferences.getInstance();
    final p = _prefs!;
    onboardingDone = p.getBool(PrefKeys.onboardingDone) ?? false;
    _favorites
      ..clear()
      ..addAll(p.getStringList(PrefKeys.favorites) ?? const []);
    _largeText = p.getBool(PrefKeys.largeText) ?? false;
    _themeMode = _parseTheme(p.getString(PrefKeys.themeMode));
    _streak = p.getInt(PrefKeys.streakCount) ?? 0;
    notifyListeners();
  }

  bool isFavorite(String id) => _favorites.contains(id);

  Future<void> toggleFavorite(String id) async {
    if (!_favorites.add(id)) _favorites.remove(id);
    await _prefs?.setStringList(PrefKeys.favorites, _favorites.toList());
    notifyListeners();
  }

  Future<void> setLargeText(bool v) async {
    _largeText = v;
    await _prefs?.setBool(PrefKeys.largeText, v);
    notifyListeners();
  }

  Future<void> setThemeMode(ThemeMode m) async {
    _themeMode = m;
    await _prefs?.setString(PrefKeys.themeMode, m.name);
    notifyListeners();
  }

  Future<void> completeOnboarding() async {
    onboardingDone = true;
    await _prefs?.setBool(PrefKeys.onboardingDone, true);
    notifyListeners();
  }

  /// Call when a stretch/routine is completed; advances the daily streak once per day.
  Future<void> registerSessionComplete() async {
    final today = DateTime.now();
    final todayStr = '${today.year}-${today.month}-${today.day}';
    final last = _prefs?.getString(PrefKeys.lastStretchDate);
    if (last == todayStr) return; // already counted today

    final yesterday = today.subtract(const Duration(days: 1));
    final yStr = '${yesterday.year}-${yesterday.month}-${yesterday.day}';
    _streak = (last == yStr) ? _streak + 1 : 1;

    await _prefs?.setInt(PrefKeys.streakCount, _streak);
    await _prefs?.setString(PrefKeys.lastStretchDate, todayStr);
    notifyListeners();
  }

  ThemeMode _parseTheme(String? s) {
    switch (s) {
      case 'light':
        return ThemeMode.light;
      case 'dark':
        return ThemeMode.dark;
      default:
        return ThemeMode.system;
    }
  }
}
