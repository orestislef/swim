import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:swim_college_app/core/l10n/generated/app_localizations.dart';
import '../../core/widgets/loading_widget.dart';
import '../../core/widgets/empty_state.dart';
import '../../core/widgets/error_state.dart';
import '../../data/models/subscription.dart';
import '../dashboard/dashboard_provider.dart';

final subscriptionsProvider = FutureProvider<List<Subscription>>((ref) {
  return ref.watch(dataRepositoryProvider).getSubscriptions();
});

class SubscriptionsScreen extends ConsumerWidget {
  const SubscriptionsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final asyncSubs = ref.watch(subscriptionsProvider);
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(title: Text(l10n.mySubscriptions)),
      body: RefreshIndicator(
        onRefresh: () => ref.refresh(subscriptionsProvider.future),
        child: asyncSubs.when(
          loading: () => const ShimmerList(),
          error: (e, _) => ListView(children: [
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.6,
              child: ErrorState(
                message: e.toString(),
                onRetry: () => ref.invalidate(subscriptionsProvider),
              ),
            )
          ]),
          data: (subs) {
            if (subs.isEmpty) {
              return ListView(children: [
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.6,
                  child: EmptyState(
                    icon: Icons.card_membership,
                    title: l10n.noActiveSubscriptions,
                    subtitle: l10n.contactReception,
                  ),
                ),
              ]);
            }
            return ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: subs.length,
              itemBuilder: (context, index) {
                final sub = subs[index];
                return Card(
                  margin: const EdgeInsets.only(bottom: 12),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(Icons.card_membership,
                                color: theme.colorScheme.primary),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Text(
                                sub.name,
                                style: theme.textTheme.titleSmall
                                    ?.copyWith(fontWeight: FontWeight.w600),
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 4),
                              decoration: BoxDecoration(
                                color: Colors.green.withAlpha(30),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Text(
                                l10n.bookingStatusActive,
                                style: const TextStyle(
                                    color: Colors.green,
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        _InfoRow(
                            icon: Icons.calendar_today,
                            label: l10n.subscriptionStart,
                            value: sub.start),
                        const SizedBox(height: 4),
                        _InfoRow(
                            icon: Icons.event,
                            label: l10n.subscriptionEnd,
                            value: sub.end),
                        const SizedBox(height: 4),
                        _InfoRow(
                            icon: Icons.check_circle,
                            label: l10n.subscriptionAttendances,
                            value: sub.attendances),
                        if (sub.remaining.isNotEmpty) ...[
                          const SizedBox(height: 4),
                          _InfoRow(
                              icon: Icons.hourglass_bottom,
                              label: '',
                              value: sub.remaining),
                        ],
                      ],
                    ),
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _InfoRow(
      {required this.icon, required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Row(
      children: [
        Icon(icon, size: 16, color: theme.colorScheme.outline),
        const SizedBox(width: 8),
        if (label.isNotEmpty)
          Text('$label: ',
              style: theme.textTheme.bodySmall
                  ?.copyWith(color: theme.colorScheme.outline)),
        Expanded(
          child: Text(value, style: theme.textTheme.bodySmall),
        ),
      ],
    );
  }
}
