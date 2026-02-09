import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:swim_college_app/core/l10n/generated/app_localizations.dart';
import '../../core/widgets/loading_widget.dart';
import '../../core/widgets/empty_state.dart';
import '../../core/widgets/error_state.dart';
import '../../data/models/waitlist_item.dart';
import '../dashboard/dashboard_provider.dart';

final cancellationsDataProvider = FutureProvider<List<WaitlistItem>>((ref) {
  return ref.watch(dataRepositoryProvider).getCancellations();
});

class CancellationsScreen extends ConsumerWidget {
  const CancellationsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final asyncData = ref.watch(cancellationsDataProvider);
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(title: Text(l10n.cancellationsTitle)),
      body: RefreshIndicator(
        onRefresh: () => ref.refresh(cancellationsDataProvider.future),
        child: asyncData.when(
          loading: () => const ShimmerBannerList(color: Colors.red),
          error: (e, _) => ListView(children: [
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.6,
              child: ErrorState(
                message: e.toString(),
                onRetry: () => ref.invalidate(cancellationsDataProvider),
              ),
            )
          ]),
          data: (items) {
            if (items.isEmpty) {
              return ListView(children: [
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.6,
                  child: EmptyState(
                    icon: Icons.check_circle,
                    title: l10n.noCancellations,
                    subtitle: l10n.noCancellationsText,
                  ),
                ),
              ]);
            }
            return ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: items.length,
              itemBuilder: (context, index) {
                return Container(
                  margin: const EdgeInsets.only(bottom: 12),
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.red.withAlpha(20),
                    borderRadius: BorderRadius.circular(12),
                    border: Border(
                      left: BorderSide(color: Colors.red, width: 4),
                    ),
                  ),
                  child: Text(items[index].details,
                      style: theme.textTheme.bodyMedium),
                );
              },
            );
          },
        ),
      ),
    );
  }
}
