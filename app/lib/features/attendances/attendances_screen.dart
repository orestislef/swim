import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:swim_college_app/core/l10n/generated/app_localizations.dart';
import '../../core/date_utils.dart' as du;
import '../../core/widgets/loading_widget.dart';
import '../../core/widgets/empty_state.dart';
import '../../core/widgets/error_state.dart';
import '../../data/models/attendance.dart';
import '../dashboard/dashboard_provider.dart';
import '../settings/settings_provider.dart';

final attendancesProvider = FutureProvider<List<Attendance>>((ref) {
  return ref.watch(dataRepositoryProvider).getAttendances();
});

class AttendancesScreen extends ConsumerWidget {
  const AttendancesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final asyncData = ref.watch(attendancesProvider);
    final theme = Theme.of(context);
    final locale = ref.watch(settingsProvider).locale.languageCode;

    return Scaffold(
      appBar: AppBar(title: Text(l10n.attendanceHistory)),
      body: RefreshIndicator(
        onRefresh: () => ref.refresh(attendancesProvider.future),
        child: asyncData.when(
          loading: () => const ShimmerAttendances(),
          error: (e, _) => ListView(children: [
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.6,
              child: ErrorState(
                message: e.toString(),
                onRetry: () => ref.invalidate(attendancesProvider),
              ),
            )
          ]),
          data: (attendances) {
            if (attendances.isEmpty) {
              return ListView(children: [
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.6,
                  child: EmptyState(
                    icon: Icons.fact_check,
                    title: l10n.noAttendance,
                  ),
                ),
              ]);
            }

            // Compute stats
            final now = DateTime.now();
            int thisMonthCount = 0;
            for (final a in attendances) {
              final d = du.parseGreekDate(a.date);
              if (d != null && d.month == now.month && d.year == now.year) {
                thisMonthCount++;
              }
            }

            // Group by month-year
            final Map<String, List<Attendance>> grouped = {};
            for (final att in attendances) {
              final d = du.parseGreekDate(att.date);
              if (d == null) continue;
              final key =
                  '${d.year}-${d.month.toString().padLeft(2, '0')}';
              grouped.putIfAbsent(key, () => []).add(att);
            }
            final sortedKeys = grouped.keys.toList()
              ..sort((a, b) => b.compareTo(a));

            return ListView(
              padding: const EdgeInsets.all(16),
              children: [
                // Summary stats
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Row(
                      children: [
                        Expanded(
                          child: Row(
                            children: [
                              Icon(Icons.fact_check,
                                  color: theme.colorScheme.primary, size: 20),
                              const SizedBox(width: 8),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(l10n.totalCount,
                                      style: theme.textTheme.bodySmall
                                          ?.copyWith(
                                              color:
                                                  theme.colorScheme.outline)),
                                  Text(
                                    '${attendances.length}',
                                    style: theme.textTheme.titleMedium
                                        ?.copyWith(
                                            fontWeight: FontWeight.bold),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        Container(
                          width: 1,
                          height: 40,
                          color: theme.colorScheme.outlineVariant,
                        ),
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.only(left: 16),
                            child: Row(
                              children: [
                                Icon(Icons.calendar_month,
                                    color: theme.colorScheme.tertiary,
                                    size: 20),
                                const SizedBox(width: 8),
                                Column(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.start,
                                  children: [
                                    Text(l10n.thisMonth,
                                        style: theme.textTheme.bodySmall
                                            ?.copyWith(
                                                color: theme
                                                    .colorScheme.outline)),
                                    Text(
                                      '$thisMonthCount',
                                      style: theme.textTheme.titleMedium
                                          ?.copyWith(
                                              fontWeight: FontWeight.bold),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                // Monthly groups
                for (final key in sortedKeys) ...[
                  () {
                    final parts = key.split('-');
                    final year = int.parse(parts[0]);
                    final month = int.parse(parts[1]);
                    final date = DateTime(year, month);
                    final monthName =
                        DateFormat('MMMM yyyy', locale).format(date);
                    final items = grouped[key]!;

                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(Icons.calendar_today,
                                size: 18, color: theme.colorScheme.primary),
                            const SizedBox(width: 8),
                            Text(
                              '$monthName (${items.length})',
                              style: theme.textTheme.titleSmall?.copyWith(
                                fontWeight: FontWeight.w600,
                                color: theme.colorScheme.primary,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        ...items.map((att) => Card(
                              margin: const EdgeInsets.only(bottom: 8),
                              child: ListTile(
                                leading: CircleAvatar(
                                  backgroundColor:
                                      theme.colorScheme.primaryContainer,
                                  child: Icon(Icons.pool,
                                      color: theme.colorScheme.primary,
                                      size: 20),
                                ),
                                title: Text(att.date),
                                trailing: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(Icons.access_time,
                                        size: 16,
                                        color: theme.colorScheme.outline),
                                    const SizedBox(width: 4),
                                    Text(
                                      att.time,
                                      style: theme.textTheme.bodyMedium
                                          ?.copyWith(
                                              color:
                                                  theme.colorScheme.outline),
                                    ),
                                  ],
                                ),
                              ),
                            )),
                        const SizedBox(height: 8),
                      ],
                    );
                  }(),
                ],
              ],
            );
          },
        ),
      ),
    );
  }
}
