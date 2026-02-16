import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/models/booking.dart';
import '../../data/models/subscription.dart';
import '../../data/models/user.dart';
import '../../data/models/waitlist_item.dart';
import '../../data/repositories/data_repository.dart';
import '../../services/notification_service.dart';
import '../auth/auth_provider.dart';
import '../settings/settings_provider.dart';

class DashboardState {
  final User? user;
  final List<Booking> bookings;
  final List<Subscription> subscriptions;
  final int waitlistCount;
  final int cancellationsCount;
  final bool isLoading;
  final String? error;

  const DashboardState({
    this.user,
    this.bookings = const [],
    this.subscriptions = const [],
    this.waitlistCount = 0,
    this.cancellationsCount = 0,
    this.isLoading = false,
    this.error,
  });

  DashboardState copyWith({
    User? user,
    List<Booking>? bookings,
    List<Subscription>? subscriptions,
    int? waitlistCount,
    int? cancellationsCount,
    bool? isLoading,
    String? error,
  }) {
    return DashboardState(
      user: user ?? this.user,
      bookings: bookings ?? this.bookings,
      subscriptions: subscriptions ?? this.subscriptions,
      waitlistCount: waitlistCount ?? this.waitlistCount,
      cancellationsCount: cancellationsCount ?? this.cancellationsCount,
      isLoading: isLoading ?? this.isLoading,
      error: error,
    );
  }
}

class DashboardNotifier extends Notifier<DashboardState> {
  bool _hasLoaded = false;
  bool _isLoadInProgress = false;

  @override
  DashboardState build() {
    // Auto-load when auth becomes authenticated
    ref.listen<AuthState>(authProvider, (prev, next) {
      if (next.status == AuthStatus.authenticated &&
          prev?.status != AuthStatus.authenticated) {
        _hasLoaded = false;
        load();
      }
    });
    return const DashboardState();
  }

  /// Loads dashboard data. Skips if already loading.
  /// Use [force] to bypass the duplicate-load guard (pull-to-refresh).
  Future<void> load({bool force = false}) async {
    // Prevent concurrent loads
    if (_isLoadInProgress) return;

    // Don't auto-reload if we already have data (unless forced)
    if (!force && _hasLoaded && state.user != null) return;

    _isLoadInProgress = true;
    state = state.copyWith(isLoading: true, error: null);
    try {
      final dataRepo = ref.read(dataRepositoryProvider);
      final results = await Future.wait([
        dataRepo.getDashboard(),
        dataRepo.getBookings(),
        dataRepo.getSubscriptions(),
        dataRepo.getWaitlist(),
        dataRepo.getCancellations(),
      ]);
      final user = results[0] as User?;
      final bookings = results[1] as List<Booking>;
      final subscriptions = results[2] as List<Subscription>;
      final waitlist = results[3] as List<WaitlistItem>;
      final cancellations = results[4] as List<WaitlistItem>;

      state = DashboardState(
        user: user,
        bookings: bookings,
        subscriptions: subscriptions,
        waitlistCount: waitlist.length,
        cancellationsCount: cancellations.length,
      );
      _hasLoaded = true;

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
    } finally {
      _isLoadInProgress = false;
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
