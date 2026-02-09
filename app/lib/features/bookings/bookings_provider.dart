import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/models/booking.dart';
import '../../services/notification_service.dart';
import '../dashboard/dashboard_provider.dart';
import '../settings/settings_provider.dart';

class BookingsState {
  final List<Booking> bookings;
  final bool isLoading;
  final String? error;

  const BookingsState({
    this.bookings = const [],
    this.isLoading = false,
    this.error,
  });

  BookingsState copyWith({
    List<Booking>? bookings,
    bool? isLoading,
    String? error,
  }) {
    return BookingsState(
      bookings: bookings ?? this.bookings,
      isLoading: isLoading ?? this.isLoading,
      error: error,
    );
  }
}

class BookingsNotifier extends Notifier<BookingsState> {
  @override
  BookingsState build() {
    return const BookingsState();
  }

  Future<void> load() async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final dataRepo = ref.read(dataRepositoryProvider);
      final bookings = await dataRepo.getBookings();
      state = BookingsState(bookings: bookings);
      final settings = ref.read(settingsProvider);
      if (settings.notificationsEnabled) {
        NotificationService().scheduleBookingReminders(
          bookings,
          notify24h: settings.notify24hBefore,
          notify1h: settings.notify1hBefore,
        );
      }
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  Future<bool> cancelBooking(String bookingId) async {
    final dataRepo = ref.read(dataRepositoryProvider);
    final result = await dataRepo.cancelBooking(bookingId);
    if (result.success) {
      await load();
      return true;
    }
    return false;
  }
}

final bookingsProvider =
    NotifierProvider<BookingsNotifier, BookingsState>(
  BookingsNotifier.new,
);
