import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
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
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: Text(l10n.no),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: Text(l10n.yes),
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
            ? const ShimmerList()
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
                : ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: state.bookings.length,
                    itemBuilder: (context, index) {
                      final booking = state.bookings[index];
                      return _BookingListItem(
                        booking: booking,
                        isGreek: isGreek,
                        onCancel:
                            booking.canCancel ? () => _cancelBooking(booking) : null,
                      );
                    },
                  ),
      ),
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
