import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:swim_college_app/core/l10n/generated/app_localizations.dart';
import '../connectivity_provider.dart';
import '../../features/auth/auth_provider.dart';

class SwimScaffold extends ConsumerWidget {
  final Widget child;

  const SwimScaffold({super.key, required this.child});

  static const _navPaths = [
    '/dashboard',
    '/bookings',
    '/book-class',
    '/barcode',
  ];

  int _currentIndex(BuildContext context) {
    final location = GoRouterState.of(context).matchedLocation;
    final idx = _navPaths.indexOf(location);
    return idx >= 0 ? idx : 0;
  }

  void _showMoreSheet(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);

    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 8),
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: theme.colorScheme.outline.withAlpha(80),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 16),
            _MoreItem(
              icon: Icons.card_membership,
              label: l10n.subscriptions,
              onTap: () { Navigator.pop(ctx); context.go('/subscriptions'); },
            ),
            _MoreItem(
              icon: Icons.fact_check,
              label: l10n.attendance,
              onTap: () { Navigator.pop(ctx); context.go('/attendances'); },
            ),
            _MoreItem(
              icon: Icons.hourglass_top,
              label: l10n.waitlist,
              onTap: () { Navigator.pop(ctx); context.go('/waitlist'); },
            ),
            _MoreItem(
              icon: Icons.cancel_outlined,
              label: l10n.cancellations,
              onTap: () { Navigator.pop(ctx); context.go('/cancellations'); },
            ),
            _MoreItem(
              icon: Icons.person,
              label: l10n.profile,
              onTap: () { Navigator.pop(ctx); context.go('/profile'); },
            ),
            _MoreItem(
              icon: Icons.settings,
              label: l10n.settings,
              onTap: () { Navigator.pop(ctx); context.go('/settings'); },
            ),
            const Divider(),
            _MoreItem(
              icon: Icons.logout,
              label: l10n.logout,
              color: theme.colorScheme.error,
              onTap: () {
                Navigator.pop(ctx);
                ProviderScope.containerOf(context).read(authProvider.notifier).logout();
              },
            ),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final currentIdx = _currentIndex(context);

    final isOnline = ref.watch(connectivityProvider).value ?? true;

    return Scaffold(
      body: Column(
        children: [
          if (!isOnline)
            Material(
              color: theme.colorScheme.error,
              child: SafeArea(
                bottom: false,
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.wifi_off, size: 16, color: theme.colorScheme.onError),
                      const SizedBox(width: 8),
                      Text(
                        l10n.noInternetConnection,
                        style: TextStyle(
                          color: theme.colorScheme.onError,
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          Expanded(child: child),
        ],
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: currentIdx >= 0 ? currentIdx : 0,
        onDestinationSelected: (idx) {
          if (idx < _navPaths.length) {
            context.go(_navPaths[idx]);
          } else {
            _showMoreSheet(context);
          }
        },
        destinations: [
          NavigationDestination(
            icon: const Icon(Icons.dashboard_outlined),
            selectedIcon: const Icon(Icons.dashboard),
            label: l10n.navDashboard,
          ),
          NavigationDestination(
            icon: const Icon(Icons.calendar_today_outlined),
            selectedIcon: const Icon(Icons.calendar_today),
            label: l10n.navBookings,
          ),
          NavigationDestination(
            icon: const Icon(Icons.add_circle_outline),
            selectedIcon: const Icon(Icons.add_circle),
            label: l10n.navBookClass,
          ),
          NavigationDestination(
            icon: const Icon(Icons.qr_code),
            selectedIcon: const Icon(Icons.qr_code_2),
            label: l10n.navBarcode,
          ),
          NavigationDestination(
            icon: const Icon(Icons.more_horiz),
            selectedIcon: const Icon(Icons.more_horiz),
            label: l10n.more,
          ),
        ],
      ),
    );
  }
}

class _MoreItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final Color? color;

  const _MoreItem({
    required this.icon,
    required this.label,
    required this.onTap,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(icon, color: color),
      title: Text(label, style: color != null ? TextStyle(color: color) : null),
      onTap: onTap,
    );
  }
}
