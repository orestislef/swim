import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:swim_college_app/core/l10n/generated/app_localizations.dart';
import '../../core/widgets/loading_widget.dart';
import '../../core/widgets/empty_state.dart';
import '../../core/widgets/error_state.dart';
import '../../data/models/waitlist_item.dart';
import '../dashboard/dashboard_provider.dart';

final waitlistProvider = FutureProvider<List<WaitlistItem>>((ref) {
  return ref.watch(dataRepositoryProvider).getWaitlist();
});

class WaitlistScreen extends ConsumerWidget {
  const WaitlistScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final asyncData = ref.watch(waitlistProvider);
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(title: Text(l10n.waitlistTitle)),
      body: RefreshIndicator(
        onRefresh: () => ref.refresh(waitlistProvider.future),
        child: asyncData.when(
          loading: () => const ShimmerBannerList(color: Colors.amber),
          error: (e, _) => ListView(children: [
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.6,
              child: ErrorState(
                message: e.toString(),
                onRetry: () => ref.invalidate(waitlistProvider),
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
                    title: l10n.noWaitlist,
                    subtitle: l10n.noWaitlistText,
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
                    color: Colors.amber.withAlpha(30),
                    borderRadius: BorderRadius.circular(12),
                    border: Border(
                      left: BorderSide(color: Colors.amber, width: 4),
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
