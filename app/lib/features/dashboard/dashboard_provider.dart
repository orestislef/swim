import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/models/booking.dart';
import '../../data/models/subscription.dart';
import '../../data/models/user.dart';
import '../../data/repositories/data_repository.dart';
import '../../services/notification_service.dart';
import '../auth/auth_provider.dart';
import '../settings/settings_provider.dart';

class DashboardState {
  final User? user;
  final List<Booking> bookings;
  final List<Subscription> subscriptions;
  final bool isLoading;
  final String? error;

  const DashboardState({
    this.user,
    this.bookings = const [],
    this.subscriptions = const [],
    this.isLoading = false,
    this.error,
  });

  DashboardState copyWith({
    User? user,
    List<Booking>? bookings,
    List<Subscription>? subscriptions,
    bool? isLoading,
    String? error,
  }) {
    return DashboardState(
      user: user ?? this.user,
      bookings: bookings ?? this.bookings,
      subscriptions: subscriptions ?? this.subscriptions,
      isLoading: isLoading ?? this.isLoading,
      error: error,
    );
  }
}

class DashboardNotifier extends Notifier<DashboardState> {
  @override
  DashboardState build() {
    return const DashboardState();
  }

  Future<void> load() async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final dataRepo = ref.read(dataRepositoryProvider);
      final results = await Future.wait([
        dataRepo.getDashboard(),
        dataRepo.getBookings(),
        dataRepo.getSubscriptions(),
      ]);
      final user = results[0] as User?;
      final bookings = results[1] as List<Booking>;
      final subscriptions = results[2] as List<Subscription>;

      state = DashboardState(
        user: user,
        bookings: bookings,
        subscriptions: subscriptions,
      );

      // Schedule notifications if enabled
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
}

final dataRepositoryProvider = Provider<DataRepository>((ref) {
  return DataRepository(ref.watch(apiClientProvider));
});

final dashboardProvider =
    NotifierProvider<DashboardNotifier, DashboardState>(
  DashboardNotifier.new,
);
