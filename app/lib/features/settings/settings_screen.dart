import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:swim_college_app/core/l10n/generated/app_localizations.dart';
import '../../services/notification_service.dart';
import '../dashboard/dashboard_provider.dart';
import 'settings_provider.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  void _reschedule(WidgetRef ref) {
    final settings = ref.read(settingsProvider);
    final bookings = ref.read(dashboardProvider).bookings;
    if (settings.notificationsEnabled) {
      NotificationService().scheduleBookingReminders(
        bookings,
        notify24h: settings.notify24hBefore,
        notify1h: settings.notify1hBefore,
      );
    }
  }

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
            child: Column(
              children: [
                SwitchListTile(
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
                    } else {
                      _reschedule(ref);
                    }
                  },
                ),
                if (settings.notificationsEnabled) ...[
                  const Divider(height: 1),
                  SwitchListTile(
                    contentPadding:
                        const EdgeInsets.only(left: 56, right: 16),
                    title: Text(l10n.notification24h),
                    value: settings.notify24hBefore,
                    onChanged: (enabled) {
                      ref
                          .read(settingsProvider.notifier)
                          .setNotify24hBefore(enabled);
                      _reschedule(ref);
                    },
                  ),
                  const Divider(height: 1),
                  SwitchListTile(
                    contentPadding:
                        const EdgeInsets.only(left: 56, right: 16),
                    title: Text(l10n.notification1h),
                    value: settings.notify1hBefore,
                    onChanged: (enabled) {
                      ref
                          .read(settingsProvider.notifier)
                          .setNotify1hBefore(enabled);
                      _reschedule(ref);
                    },
                  ),
                ],
              ],
            ),
          ),
          const SizedBox(height: 8),

          // Theme
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(
                        settings.themeMode == ThemeMode.dark
                            ? Icons.dark_mode
                            : settings.themeMode == ThemeMode.light
                                ? Icons.light_mode
                                : Icons.brightness_auto,
                        color: theme.colorScheme.primary,
                      ),
                      const SizedBox(width: 16),
                      Text(l10n.theming, style: theme.textTheme.bodyLarge),
                    ],
                  ),
                  const SizedBox(height: 12),
                  SizedBox(
                    width: double.infinity,
                    child: SegmentedButton<ThemeMode>(
                      segments: [
                        ButtonSegment(
                          value: ThemeMode.system,
                          label: Text(l10n.themeSystem),
                        ),
                        ButtonSegment(
                          value: ThemeMode.light,
                          label: Text(l10n.themeLight),
                        ),
                        ButtonSegment(
                          value: ThemeMode.dark,
                          label: Text(l10n.themeDark),
                        ),
                      ],
                      selected: {settings.themeMode},
                      onSelectionChanged: (selected) {
                        ref
                            .read(settingsProvider.notifier)
                            .setThemeMode(selected.first);
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 8),

          // Language
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(Icons.language, color: theme.colorScheme.primary),
                      const SizedBox(width: 16),
                      Text(l10n.language, style: theme.textTheme.bodyLarge),
                    ],
                  ),
                  const SizedBox(height: 12),
                  SizedBox(
                    width: double.infinity,
                    child: SegmentedButton<String>(
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
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
