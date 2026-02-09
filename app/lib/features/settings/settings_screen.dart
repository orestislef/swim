import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:swim_college_app/core/l10n/generated/app_localizations.dart';
import '../../services/notification_service.dart';
import 'settings_provider.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final settings = ref.watch(settingsProvider);
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(title: Text(l10n.settings)),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Notifications
          Card(
            child: SwitchListTile(
              secondary: Icon(
                settings.notificationsEnabled
                    ? Icons.notifications_active
                    : Icons.notifications_off,
                color: theme.colorScheme.primary,
              ),
              title: Text(l10n.notifications),
              subtitle: Text(l10n.notificationsDescription),
              value: settings.notificationsEnabled,
              onChanged: (enabled) {
                ref
                    .read(settingsProvider.notifier)
                    .setNotificationsEnabled(enabled);
                if (!enabled) {
                  NotificationService().cancelAll();
                }
              },
            ),
          ),
          const SizedBox(height: 8),

          // Theme
          Card(
            child: SwitchListTile(
              secondary: Icon(
                settings.themeMode == ThemeMode.dark
                    ? Icons.dark_mode
                    : Icons.light_mode,
                color: theme.colorScheme.primary,
              ),
              title: Text(l10n.darkMode),
              value: settings.themeMode == ThemeMode.dark,
              onChanged: (_) =>
                  ref.read(settingsProvider.notifier).toggleTheme(),
            ),
          ),
          const SizedBox(height: 8),

          // Language
          Card(
            child: ListTile(
              leading:
                  Icon(Icons.language, color: theme.colorScheme.primary),
              title: Text(l10n.language),
              trailing: SegmentedButton<String>(
                segments: [
                  ButtonSegment(
                    value: 'el',
                    label: Text(l10n.greek),
                  ),
                  ButtonSegment(
                    value: 'en',
                    label: Text(l10n.english),
                  ),
                ],
                selected: {settings.locale.languageCode},
                onSelectionChanged: (selected) {
                  ref
                      .read(settingsProvider.notifier)
                      .setLocale(Locale(selected.first));
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
