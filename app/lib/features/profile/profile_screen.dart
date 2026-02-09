import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:swim_college_app/core/l10n/generated/app_localizations.dart';
import '../../core/widgets/loading_widget.dart';
import '../../core/widgets/empty_state.dart';
import '../../core/widgets/error_state.dart';
import '../../data/models/user.dart';
import '../dashboard/dashboard_provider.dart';

final profileProvider = FutureProvider<User?>((ref) {
  return ref.watch(dataRepositoryProvider).getProfile();
});

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final asyncData = ref.watch(profileProvider);
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(title: Text(l10n.myProfile)),
      body: RefreshIndicator(
        onRefresh: () => ref.refresh(profileProvider.future),
        child: asyncData.when(
          loading: () => const ShimmerProfile(),
          error: (e, _) => ListView(children: [
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.6,
              child: ErrorState(
                message: e.toString(),
                onRetry: () => ref.invalidate(profileProvider),
              ),
            )
          ]),
          data: (user) {
            if (user == null) {
              return ListView(children: [
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.6,
                  child: EmptyState(
                    icon: Icons.person_off,
                    title: l10n.error,
                  ),
                ),
              ]);
            }
            return ListView(
              padding: const EdgeInsets.all(16),
              children: [
                // Avatar
                Center(
                  child: CircleAvatar(
                    radius: 48,
                    backgroundColor: theme.colorScheme.primaryContainer,
                    child: Text(
                      user.name.isNotEmpty ? user.name[0].toUpperCase() : '?',
                      style: TextStyle(
                        fontSize: 36,
                        fontWeight: FontWeight.bold,
                        color: theme.colorScheme.primary,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                Center(
                  child: Text(
                    user.name,
                    style: theme.textTheme.titleLarge
                        ?.copyWith(fontWeight: FontWeight.bold),
                  ),
                ),
                Center(
                  child: Container(
                    margin: const EdgeInsets.only(top: 8),
                    padding:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.green.withAlpha(30),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      l10n.activeMember,
                      style: const TextStyle(
                          color: Colors.green,
                          fontWeight: FontWeight.w600,
                          fontSize: 12),
                    ),
                  ),
                ),
                const SizedBox(height: 32),

                _ProfileField(
                  icon: Icons.person,
                  label: l10n.fullName,
                  value: user.name,
                ),
                _ProfileField(
                  icon: Icons.event,
                  label: l10n.programExpires,
                  value: user.expiry,
                ),
                _ProfileField(
                  icon: Icons.account_balance_wallet,
                  label: l10n.accountBalance,
                  value: user.balance,
                ),

                const SizedBox(height: 24),
                OutlinedButton.icon(
                  onPressed: () => context.go('/settings'),
                  icon: const Icon(Icons.settings),
                  label: Text(l10n.settings),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

class _ProfileField extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _ProfileField({
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        leading: Icon(icon, color: theme.colorScheme.primary),
        title: Text(label,
            style: theme.textTheme.bodySmall
                ?.copyWith(color: theme.colorScheme.outline)),
        subtitle: Text(
          value.isEmpty ? '-' : value,
          style:
              theme.textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.w500),
        ),
      ),
    );
  }
}
