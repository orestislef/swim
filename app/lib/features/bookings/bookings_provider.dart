import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/models/booking.dart';
import '../../data/repositories/data_repository.dart';
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

class BookingsNotifier extends StateNotifier<BookingsState> {
  final DataRepository _dataRepo;
  final bool _notificationsEnabled;

  BookingsNotifier(this._dataRepo, this._notificationsEnabled)
      : super(const BookingsState());

  Future<void> load() async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final bookings = await _dataRepo.getBookings();
      state = BookingsState(bookings: bookings);
      if (_notificationsEnabled) {
        NotificationService().scheduleBookingReminders(bookings);
      }
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  Future<bool> cancelBooking(String bookingId) async {
    final result = await _dataRepo.cancelBooking(bookingId);
    if (result.success) {
      await load();
      return true;
    }
    return false;
  }
}

final bookingsProvider =
    StateNotifierProvider<BookingsNotifier, BookingsState>((ref) {
  final notifEnabled = ref.watch(
    settingsProvider.select((s) => s.notificationsEnabled),
  );
  return BookingsNotifier(ref.watch(dataRepositoryProvider), notifEnabled);
});
