import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:swim_college_app/core/l10n/generated/app_localizations.dart';
import '../../core/date_utils.dart' as du;
import '../../core/widgets/loading_widget.dart';
import '../../core/widgets/empty_state.dart';
import '../../core/widgets/error_state.dart';
import '../../data/models/booking.dart';
import '../../data/models/subscription.dart';
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
    // load() has built-in guards: skips if already loaded or in progress.
    // Auth listener in provider handles reload after login.
    Future.microtask(() => ref.read(dashboardProvider.notifier).load());
  }

  Booking? _getTodaysNextClass(List<Booking> bookings) {
    final now = DateTime.now();
    final todayEnd = DateTime(now.year, now.month, now.day + 1);
    Booking? nearest;
    DateTime? nearestTime;
    for (final b in bookings) {
      final dt = du.parseBookingDateTime(b.date, b.time);
      if (dt == null) continue;
      if (dt.isAfter(now) && dt.isBefore(todayEnd)) {
        if (nearestTime == null || dt.isBefore(nearestTime)) {
          nearest = b;
          nearestTime = dt;
        }
      }
    }
    return nearest;
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final state = ref.watch(dashboardProvider);
    final theme = Theme.of(context);
    final locale = ref.watch(settingsProvider).locale.languageCode;

    return Scaffold(
      appBar: AppBar(title: Text(l10n.dashboard)),
      body: RefreshIndicator(
        onRefresh: () => ref.read(dashboardProvider.notifier).load(force: true),
        child: state.error != null && state.user == null
            ? ErrorState(
                message: state.error!,
                onRetry: () => ref.read(dashboardProvider.notifier).load(force: true),
              )
            : state.isLoading && state.user == null
            ? const ShimmerDashboard()
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
                  const SizedBox(height: 16),

                  // Today's class hero card
                  if (_getTodaysNextClass(state.bookings) case final todayClass?) ...[
                    _TodaysClassHeroCard(
                      booking: todayClass,
                      locale: locale,
                    ),
                    const SizedBox(height: 16),
                  ],

                  // Quick actions
                  Row(
                    children: [
                      Expanded(
                        child: _QuickActionCard(
                          icon: Icons.add_circle,
                          label: l10n.bookClass,
                          color: theme.colorScheme.primary,
                          onTap: () => context.go('/book-class'),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _QuickActionCard(
                          icon: Icons.qr_code,
                          label: l10n.navBarcode,
                          color: theme.colorScheme.tertiary,
                          onTap: () => context.go('/barcode'),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

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
                            color: _expiryColor(state.user!.expiry),
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

                  // Subscription progress
                  if (state.subscriptions.isNotEmpty) ...[
                    const SizedBox(height: 16),
                    _SubscriptionProgressCard(
                      subscription: state.subscriptions.first,
                      locale: locale,
                      onTap: () => context.go('/subscriptions'),
                    ),
                  ],

                  // Low-balance warning
                  for (final sub in state.subscriptions) ...[
                    () {
                      final progress = du.parseAttendances(sub.attendances);
                      if (progress != null &&
                          progress.total > 0 &&
                          (progress.total - progress.used) <= 3 &&
                          (progress.total - progress.used) > 0) {
                        return Padding(
                          padding: const EdgeInsets.only(top: 8),
                          child: _AlertBanner(
                            icon: Icons.warning_amber_rounded,
                            message: l10n.lowBalanceWarning(
                              progress.total - progress.used,
                              sub.name,
                            ),
                            color: Colors.amber,
                            onTap: () => context.go('/subscriptions'),
                          ),
                        );
                      }
                      return const SizedBox.shrink();
                    }(),
                  ],

                  // Waitlist alert
                  if (state.waitlistCount > 0) ...[
                    const SizedBox(height: 8),
                    _AlertBanner(
                      icon: Icons.hourglass_top,
                      message: l10n.waitlistAlert(state.waitlistCount),
                      color: Colors.amber,
                      onTap: () => context.go('/waitlist'),
                    ),
                  ],

                  // Cancellations alert
                  if (state.cancellationsCount > 0) ...[
                    const SizedBox(height: 8),
                    _AlertBanner(
                      icon: Icons.cancel_outlined,
                      message: l10n.cancellationsAlert(state.cancellationsCount),
                      color: theme.colorScheme.error,
                      onTap: () => context.go('/cancellations'),
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
                          (b) => _BookingCard(booking: b, locale: locale),
                        ),
                ],
              ),
      ),
    );
  }

  Color _expiryColor(String expiry) {
    final date = du.parseGreekDate(expiry);
    if (date == null) return Colors.orange;
    final daysLeft = date.difference(DateTime.now()).inDays;
    if (daysLeft <= 7) return Colors.red;
    if (daysLeft <= 30) return Colors.orange;
    return Colors.green;
  }
}

class _TodaysClassHeroCard extends StatelessWidget {
  final Booking booking;
  final String locale;

  const _TodaysClassHeroCard({
    required this.booking,
    required this.locale,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;
    final classTime = du.parseBookingDateTime(booking.date, booking.time);
    final countdown = classTime != null
        ? du.formatCountdown(classTime, locale: locale)
        : '';

    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            theme.colorScheme.primary,
            theme.colorScheme.tertiary,
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () => context.go('/bookings'),
          borderRadius: BorderRadius.circular(16),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        l10n.todaysClass,
                        style: theme.textTheme.labelMedium?.copyWith(
                          color: Colors.white70,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        booking.course,
                        style: theme.textTheme.titleMedium?.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        booking.time,
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: Colors.white70,
                        ),
                      ),
                      if (countdown.isNotEmpty) ...[
                        const SizedBox(height: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(
                            color: Colors.white.withAlpha(40),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            countdown,
                            style: theme.textTheme.labelSmall?.copyWith(
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
                FilledButton.tonal(
                  onPressed: () => context.go('/barcode'),
                  style: FilledButton.styleFrom(
                    backgroundColor: Colors.white.withAlpha(40),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 12),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.qr_code, size: 28),
                      const SizedBox(height: 4),
                      Text(
                        l10n.showBarcode,
                        style: const TextStyle(fontSize: 11),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _AlertBanner extends StatelessWidget {
  final IconData icon;
  final String message;
  final Color color;
  final VoidCallback onTap;

  const _AlertBanner({
    required this.icon,
    required this.message,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: color.withAlpha(25),
          borderRadius: BorderRadius.circular(12),
          border: Border(
            left: BorderSide(color: color, width: 4),
          ),
        ),
        child: Row(
          children: [
            Icon(icon, color: color, size: 20),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                message,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: color,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            Icon(Icons.chevron_right, color: color, size: 20),
          ],
        ),
      ),
    );
  }
}

class _QuickActionCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onTap;

  const _QuickActionCard({
    required this.icon,
    required this.label,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Card(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, color: color, size: 24),
              const SizedBox(width: 8),
              Flexible(
                child: Text(
                  label,
                  style: theme.textTheme.titleSmall
                      ?.copyWith(fontWeight: FontWeight.w600),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SubscriptionProgressCard extends StatelessWidget {
  final Subscription subscription;
  final String locale;
  final VoidCallback onTap;

  const _SubscriptionProgressCard({
    required this.subscription,
    required this.locale,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;
    final progress = du.parseAttendances(subscription.attendances);

    return Card(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(Icons.card_membership,
                      color: theme.colorScheme.primary, size: 24),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      subscription.name,
                      style: theme.textTheme.titleSmall
                          ?.copyWith(fontWeight: FontWeight.w600),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  Icon(Icons.chevron_right,
                      color: theme.colorScheme.outline, size: 20),
                ],
              ),
              if (progress != null && progress.total > 0) ...[
                const SizedBox(height: 12),
                ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child: LinearProgressIndicator(
                    value: progress.used / progress.total,
                    minHeight: 8,
                    backgroundColor:
                        theme.colorScheme.primaryContainer.withAlpha(100),
                    color: theme.colorScheme.primary,
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '${progress.used}/${progress.total} ${l10n.subscriptionAttendances.toLowerCase()}',
                      style: theme.textTheme.bodySmall
                          ?.copyWith(color: theme.colorScheme.outline),
                    ),
                    if (subscription.remaining.isNotEmpty)
                      Text(
                        '${subscription.remaining} ${l10n.remaining}',
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: theme.colorScheme.primary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                  ],
                ),
              ],
              if (subscription.start.isNotEmpty ||
                  subscription.end.isNotEmpty) ...[
                const SizedBox(height: 4),
                Text(
                  '${subscription.start} - ${subscription.end}',
                  style: theme.textTheme.bodySmall
                      ?.copyWith(color: theme.colorScheme.outline),
                ),
              ],
            ],
          ),
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
  final String locale;

  const _BookingCard({required this.booking, required this.locale});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final classTime = du.parseBookingDateTime(booking.date, booking.time);
    final countdown = classTime != null
        ? du.formatCountdown(classTime, locale: locale)
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
