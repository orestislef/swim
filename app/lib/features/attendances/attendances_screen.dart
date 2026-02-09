import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:swim_college_app/core/l10n/generated/app_localizations.dart';
import '../../core/widgets/loading_widget.dart';
import '../../core/widgets/empty_state.dart';
import '../../core/widgets/error_state.dart';
import '../../data/models/attendance.dart';
import '../dashboard/dashboard_provider.dart';

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

    return Scaffold(
      appBar: AppBar(title: Text(l10n.attendanceHistory)),
      body: RefreshIndicator(
        onRefresh: () => ref.refresh(attendancesProvider.future),
        child: asyncData.when(
          loading: () => const ShimmerTable(),
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
            return ListView(
              padding: const EdgeInsets.all(16),
              children: [
                Card(
                  child: DataTable(
                    columns: [
                      DataColumn(label: Text(l10n.date)),
                      DataColumn(label: Text(l10n.time)),
                    ],
                    rows: attendances
                        .map(
                          (att) => DataRow(cells: [
                            DataCell(Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(Icons.calendar_today,
                                    size: 14, color: theme.colorScheme.primary),
                                const SizedBox(width: 8),
                                Text(att.date),
                              ],
                            )),
                            DataCell(Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(Icons.access_time,
                                    size: 14, color: theme.colorScheme.outline),
                                const SizedBox(width: 8),
                                Text(att.time),
                              ],
                            )),
                          ]),
                        )
                        .toList(),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
