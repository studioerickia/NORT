import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../config/shared_preferences_provider.dart';

const _themeModePrefsKey = 'theme_mode';

class ThemeModeController extends StateNotifier<ThemeMode> {
  ThemeModeController(this._prefs) : super(_readInitial(_prefs));

  final SharedPreferences _prefs;

  static ThemeMode _readInitial(SharedPreferences prefs) {
    final saved = prefs.getString(_themeModePrefsKey);
    return switch (saved) {
      'light' => ThemeMode.light,
      'dark' => ThemeMode.dark,
      _ => ThemeMode.system,
    };
  }

  Future<void> setThemeMode(ThemeMode mode) async {
    state = mode;
    await _prefs.setString(_themeModePrefsKey, mode.name);
  }
}

final themeModeProvider = StateNotifierProvider<ThemeModeController, ThemeMode>((ref) {
  final prefs = ref.watch(sharedPreferencesProvider);
  return ThemeModeController(prefs);
});