import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsState {
  final ThemeMode themeMode;
  final Locale locale;
  final bool notificationsEnabled;
  final bool notify1hBefore;
  final bool notify24hBefore;

  const SettingsState({
    this.themeMode = ThemeMode.system,
    this.locale = const Locale('el'),
    this.notificationsEnabled = true,
    this.notify1hBefore = true,
    this.notify24hBefore = true,
  });

  SettingsState copyWith({
    ThemeMode? themeMode,
    Locale? locale,
    bool? notificationsEnabled,
    bool? notify1hBefore,
    bool? notify24hBefore,
  }) {
    return SettingsState(
      themeMode: themeMode ?? this.themeMode,
      locale: locale ?? this.locale,
      notificationsEnabled: notificationsEnabled ?? this.notificationsEnabled,
      notify1hBefore: notify1hBefore ?? this.notify1hBefore,
      notify24hBefore: notify24hBefore ?? this.notify24hBefore,
    );
  }
}

class SettingsNotifier extends Notifier<SettingsState> {
  @override
  SettingsState build() {
    _load();
    return const SettingsState();
  }

  Future<void> _load() async {
    final prefs = await SharedPreferences.getInstance();
    final themeName = prefs.getString('themeMode') ?? 'system';
    final langCode = prefs.getString('locale') ?? 'el';
    final notifEnabled = prefs.getBool('notificationsEnabled') ?? true;
    final notify1h = prefs.getBool('notify1hBefore') ?? true;
    final notify24h = prefs.getBool('notify24hBefore') ?? true;

    state = SettingsState(
      themeMode: switch (themeName) {
        'light' => ThemeMode.light,
        'dark' => ThemeMode.dark,
        _ => ThemeMode.system,
      },
      locale: Locale(langCode),
      notificationsEnabled: notifEnabled,
      notify1hBefore: notify1h,
      notify24hBefore: notify24h,
    );
  }

  Future<void> setThemeMode(ThemeMode mode) async {
    state = state.copyWith(themeMode: mode);
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('themeMode', switch (mode) {
      ThemeMode.light => 'light',
      ThemeMode.dark => 'dark',
      ThemeMode.system => 'system',
    });
  }

  Future<void> setLocale(Locale locale) async {
    state = state.copyWith(locale: locale);
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('locale', locale.languageCode);
  }

  void toggleTheme() {
    final next = state.themeMode == ThemeMode.dark
        ? ThemeMode.light
        : ThemeMode.dark;
    setThemeMode(next);
  }

  void toggleLocale() {
    final next = state.locale.languageCode == 'el'
        ? const Locale('en')
        : const Locale('el');
    setLocale(next);
  }

  Future<void> setNotificationsEnabled(bool enabled) async {
    state = state.copyWith(notificationsEnabled: enabled);
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('notificationsEnabled', enabled);
  }

  Future<void> setNotify1hBefore(bool enabled) async {
    state = state.copyWith(notify1hBefore: enabled);
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('notify1hBefore', enabled);
  }

  Future<void> setNotify24hBefore(bool enabled) async {
    state = state.copyWith(notify24hBefore: enabled);
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('notify24hBefore', enabled);
  }
}

final settingsProvider =
    NotifierProvider<SettingsNotifier, SettingsState>(
  SettingsNotifier.new,
);
