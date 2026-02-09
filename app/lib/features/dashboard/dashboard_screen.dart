import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:swim_college_app/core/l10n/generated/app_localizations.dart';
import '../../core/date_utils.dart' as du;
import '../../core/widgets/loading_widget.dart';
import '../../core/widgets/empty_state.dart';
import '../../core/widgets/error_state.dart';
import '../../data/models/booking.dart';
import '../../features/settings/settings_provider.dart';
import 'dashboard_provider.dart';

class DashboardScreen extends ConsumerStatefulWidget {
  const DashboardScreen({super.key});

  @override
  ConsumerState<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends ConsumerState<DashboardScreen> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() => ref.read(dashboardProvider.notifier).load());
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final state = ref.watch(dashboardProvider);
    final theme = Theme.of(context);
    final isGreek = ref.watch(settingsProvider).locale.languageCode == 'el';

    return Scaffold(
      appBar: AppBar(title: Text(l10n.dashboard)),
      body: RefreshIndicator(
        onRefresh: () => ref.read(dashboardProvider.notifier).load(),
        child: state.error != null && state.user == null
            ? ErrorState(
                message: state.error!,
                onRetry: () => ref.read(dashboardProvider.notifier).load(),
              )
            : state.isLoading && state.user == null
            ? const ShimmerList()
            : ListView(
                padding: const EdgeInsets.all(16),
                children: [
                  // Welcome
                  Text(
                    l10n.welcomeBack,
                    style: theme.textTheme.headlineSmall
                        ?.copyWith(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 4),
                  Text(l10n.overview,
                      style: theme.textTheme.bodyMedium
                          ?.copyWith(color: theme.colorScheme.outline)),
                  const SizedBox(height: 20),

                  // Stat cards
                  if (state.user != null) ...[
                    Row(
                      children: [
                        Expanded(
                          child: _StatCard(
                            icon: Icons.person,
                            label: l10n.member,
                            value: state.user!.name,
                            color: theme.colorScheme.primary,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: _StatCard(
                            icon: Icons.event,
                            label: l10n.expires,
                            value: state.user!.expiry,
                            color: Colors.orange,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(
                          child: _StatCard(
                            icon: Icons.account_balance_wallet,
                            label: l10n.balance,
                            value: state.user!.balance,
                            color: Colors.green,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: _StatCard(
                            icon: Icons.calendar_today,
                            label: l10n.bookings,
                            value: '${state.bookings.length}',
                            color: theme.colorScheme.tertiary,
                          ),
                        ),
                      ],
                    ),
                  ],

                  const SizedBox(height: 24),

                  // Upcoming classes
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        l10n.upcomingClasses,
                        style: theme.textTheme.titleMedium
                            ?.copyWith(fontWeight: FontWeight.w600),
                      ),
                      TextButton(
                        onPressed: () => context.go('/bookings'),
                        child: Text(l10n.allBookings),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),

                  if (state.bookings.isEmpty)
                    EmptyState(
                      icon: Icons.event_busy,
                      title: l10n.noUpcomingClasses,
                      subtitle: l10n.bookFirstClass,
                      actionLabel: l10n.bookClass,
                      onAction: () => context.go('/book-class'),
                    )
                  else
                    ...state.bookings.take(5).map(
                          (b) => _BookingCard(booking: b, isGreek: isGreek),
                        ),
                ],
              ),
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final Color color;

  const _StatCard({
    required this.icon,
    required this.label,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, color: color, size: 28),
            const SizedBox(height: 8),
            Text(label,
                style: theme.textTheme.bodySmall
                    ?.copyWith(color: theme.colorScheme.outline)),
            const SizedBox(height: 2),
            Text(
              value.isEmpty ? '-' : value,
              style: theme.textTheme.titleSmall
                  ?.copyWith(fontWeight: FontWeight.w600),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}

class _BookingCard extends StatelessWidget {
  final Booking booking;
  final bool isGreek;

  const _BookingCard({required this.booking, required this.isGreek});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final classTime = du.parseBookingDateTime(booking.date, booking.time);
    final countdown = classTime != null
        ? du.formatCountdown(classTime, isGreek: isGreek)
        : '';
    final isPast = classTime != null && classTime.isBefore(DateTime.now());

    return Card(
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor:
              isPast ? theme.colorScheme.surfaceContainerHighest : theme.colorScheme.primaryContainer,
          child: Icon(
            Icons.pool,
            color: isPast
                ? theme.colorScheme.outline
                : theme.colorScheme.primary,
          ),
        ),
        title: Text(
          booking.course,
          style: TextStyle(
            fontWeight: FontWeight.w600,
            color: isPast ? theme.colorScheme.outline : null,
          ),
        ),
        subtitle: Text(
          '${booking.date}  ${booking.time}',
          style: TextStyle(
            color: isPast ? theme.colorScheme.outline : null,
          ),
        ),
        trailing: countdown.isNotEmpty
            ? Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: isPast
                      ? theme.colorScheme.surfaceContainerHighest
                      : theme.colorScheme.primaryContainer,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  countdown,
                  style: theme.textTheme.labelSmall?.copyWith(
                    color: isPast
                        ? theme.colorScheme.outline
                        : theme.colorScheme.primary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              )
            : null,
      ),
    );
  }
}
