import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/models/attendance.dart';
import '../../data/models/booking.dart';
import '../../services/notification_service.dart';
import '../dashboard/dashboard_provider.dart';
import '../settings/settings_provider.dart';

class BookingsState {
  final List<Booking> bookings;
  final int totalAttendances;
  final bool isLoading;
  final String? error;

  const BookingsState({
    this.bookings = const [],
    this.totalAttendances = 0,
    this.isLoading = false,
    this.error,
  });

  BookingsState copyWith({
    List<Booking>? bookings,
    int? totalAttendances,
    bool? isLoading,
    String? error,
  }) {
    return BookingsState(
      bookings: bookings ?? this.bookings,
      totalAttendances: totalAttendances ?? this.totalAttendances,
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
      final results = await Future.wait([
        dataRepo.getBookings(),
        dataRepo.getAttendances(),
      ]);
      final bookings = results[0] as List<Booking>;
      final attendances = results[1] as List<Attendance>;

      state = BookingsState(
        bookings: bookings,
        totalAttendances: attendances.length,
      );

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
