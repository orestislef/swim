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
import 'bookings_provider.dart';

class BookingsScreen extends ConsumerStatefulWidget {
  const BookingsScreen({super.key});

  @override
  ConsumerState<BookingsScreen> createState() => _BookingsScreenState();
}

class _BookingsScreenState extends ConsumerState<BookingsScreen> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() => ref.read(bookingsProvider.notifier).load());
  }

  Future<void> _cancelBooking(Booking booking) async {
    final l10n = AppLocalizations.of(context)!;
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(l10n.cancel),
        content: Text(l10n.cancelBookingConfirm),
        actions: [
          OutlinedButton(
            onPressed: () => Navigator.pop(ctx, true),
            style: OutlinedButton.styleFrom(
              foregroundColor: Theme.of(ctx).colorScheme.error,
              side: BorderSide(color: Theme.of(ctx).colorScheme.error),
            ),
            child: Text(l10n.yes),
          ),
          OutlinedButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: Text(l10n.no),
          ),
        ],
      ),
    );

    if (confirmed == true && mounted) {
      final success =
          await ref.read(bookingsProvider.notifier).cancelBooking(booking.id);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(success ? l10n.bookingCancelled : l10n.error),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final state = ref.watch(bookingsProvider);
    final isGreek = ref.watch(settingsProvider).locale.languageCode == 'el';
    final theme = Theme.of(context);

    // Split bookings into upcoming and past
    final now = DateTime.now();
    final upcoming = <Booking>[];
    final past = <Booking>[];
    for (final b in state.bookings) {
      final dt = du.parseBookingDateTime(b.date, b.time);
      if (dt != null && dt.isAfter(now)) {
        upcoming.add(b);
      } else {
        past.add(b);
      }
    }

    return Scaffold(
      appBar: AppBar(title: Text(l10n.myBookings)),
      body: RefreshIndicator(
        onRefresh: () => ref.read(bookingsProvider.notifier).load(),
        child: state.error != null && state.bookings.isEmpty
            ? ErrorState(
                message: state.error!,
                onRetry: () => ref.read(bookingsProvider.notifier).load(),
              )
            : state.isLoading && state.bookings.isEmpty
            ? const ShimmerBookingList()
            : state.bookings.isEmpty
                ? ListView(
                    children: [
                      SizedBox(
                        height: MediaQuery.of(context).size.height * 0.6,
                        child: EmptyState(
                          icon: Icons.event_busy,
                          title: l10n.noBookings,
                          subtitle: l10n.startBooking,
                        ),
                      ),
                    ],
                  )
                : ListView(
                    padding: const EdgeInsets.all(16),
                    children: [
                      // Attendance summary card
                      Card(
                        color: theme.colorScheme.primaryContainer.withAlpha(80),
                        child: ListTile(
                          leading: Icon(Icons.fact_check,
                              color: theme.colorScheme.primary),
                          title: Text(
                            '${l10n.totalAttendances}: ${state.totalAttendances}',
                            style: theme.textTheme.titleSmall
                                ?.copyWith(fontWeight: FontWeight.w600),
                          ),
                          trailing: TextButton(
                            onPressed: () => context.go('/attendances'),
                            child: Text(l10n.viewAll),
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),

                      // Upcoming section
                      if (upcoming.isNotEmpty) ...[
                        _SectionHeader(
                          title: '${l10n.upcoming} (${upcoming.length})',
                          icon: Icons.upcoming,
                          color: theme.colorScheme.primary,
                        ),
                        const SizedBox(height: 8),
                        ...upcoming.map((b) => _BookingListItem(
                              booking: b,
                              isGreek: isGreek,
                              onCancel: b.canCancel
                                  ? () => _cancelBooking(b)
                                  : null,
                            )),
                      ],

                      // Past section
                      if (past.isNotEmpty) ...[
                        if (upcoming.isNotEmpty)
                          const SizedBox(height: 16),
                        _SectionHeader(
                          title: '${l10n.pastClasses} (${past.length})',
                          icon: Icons.history,
                          color: theme.colorScheme.outline,
                        ),
                        const SizedBox(height: 8),
                        ...past.map((b) => _BookingListItem(
                              booking: b,
                              isGreek: isGreek,
                              onCancel: b.canCancel
                                  ? () => _cancelBooking(b)
                                  : null,
                            )),
                      ],
                    ],
                  ),
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final String title;
  final IconData icon;
  final Color color;

  const _SectionHeader({
    required this.title,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Row(
      children: [
        Icon(icon, size: 20, color: color),
        const SizedBox(width: 8),
        Text(
          title,
          style: theme.textTheme.titleSmall?.copyWith(
            fontWeight: FontWeight.w600,
            color: color,
          ),
        ),
      ],
    );
  }
}

class _BookingListItem extends StatelessWidget {
  final Booking booking;
  final bool isGreek;
  final VoidCallback? onCancel;

  const _BookingListItem({
    required this.booking,
    required this.isGreek,
    this.onCancel,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;
    final classTime = du.parseBookingDateTime(booking.date, booking.time);
    final isPast = classTime != null && classTime.isBefore(DateTime.now());
    final countdown = classTime != null
        ? du.formatCountdown(classTime, isGreek: isGreek)
        : '';

    Color statusColor;
    String statusText;
    switch (booking.status) {
      case 'pending':
        statusColor = Colors.blue;
        statusText = l10n.bookingStatusActive;
        break;
      case 'confirmed':
        statusColor = Colors.green;
        statusText = l10n.bookingStatusCompleted;
        break;
      default:
        statusColor = theme.colorScheme.outline;
        statusText = booking.statusText;
    }

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.pool,
                    color: isPast
                        ? theme.colorScheme.outline
                        : theme.colorScheme.primary),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        booking.course,
                        style: theme.textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.w600,
                          color: isPast ? theme.colorScheme.outline : null,
                        ),
                      ),
                      Text(
                        '${booking.date}  ${booking.time}',
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: theme.colorScheme.outline,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: statusColor.withAlpha(30),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    statusText,
                    style: theme.textTheme.labelSmall?.copyWith(
                      color: statusColor,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
            if (countdown.isNotEmpty || onCancel != null) ...[
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  if (countdown.isNotEmpty)
                    Text(
                      countdown,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: isPast
                            ? theme.colorScheme.outline
                            : theme.colorScheme.primary,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  if (onCancel != null)
                    TextButton.icon(
                      onPressed: onCancel,
                      icon: Icon(Icons.cancel_outlined,
                          size: 18, color: theme.colorScheme.error),
                      label: Text(l10n.cancel,
                          style: TextStyle(color: theme.colorScheme.error)),
                    ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }
}
