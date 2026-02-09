import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../features/auth/auth_provider.dart';
import '../features/auth/login_screen.dart';
import '../features/dashboard/dashboard_screen.dart';
import '../features/bookings/bookings_screen.dart';
import '../features/book_class/book_class_screen.dart';
import '../features/barcode/barcode_screen.dart';
import '../features/subscriptions/subscriptions_screen.dart';
import '../features/attendances/attendances_screen.dart';
import '../features/waitlist/waitlist_screen.dart';
import '../features/cancellations/cancellations_screen.dart';
import '../features/profile/profile_screen.dart';
import '../features/settings/settings_screen.dart';
import 'widgets/swim_scaffold.dart';

final routerProvider = Provider<GoRouter>((ref) {
  final router = GoRouter(
    initialLocation: '/dashboard',
    redirect: (context, state) {
      final authState = ref.read(authProvider);
      final isAuth = authState.status == AuthStatus.authenticated;
      final isLoginRoute = state.matchedLocation == '/login';

      if (authState.status == AuthStatus.unknown) return null;

      if (!isAuth && !isLoginRoute) return '/login';
      if (isAuth && isLoginRoute) return '/dashboard';
      return null;
    },
    routes: [
      GoRoute(
        path: '/login',
        builder: (context, state) => const LoginScreen(),
      ),
      ShellRoute(
        builder: (context, state, child) => SwimScaffold(child: child),
        routes: [
          GoRoute(
            path: '/dashboard',
            pageBuilder: (context, state) => const NoTransitionPage(
              child: DashboardScreen(),
            ),
          ),
          GoRoute(
            path: '/bookings',
            pageBuilder: (context, state) => const NoTransitionPage(
              child: BookingsScreen(),
            ),
          ),
          GoRoute(
            path: '/book-class',
            pageBuilder: (context, state) => const NoTransitionPage(
              child: BookClassScreen(),
            ),
          ),
          GoRoute(
            path: '/barcode',
            pageBuilder: (context, state) => const NoTransitionPage(
              child: BarcodeScreen(),
            ),
          ),
          GoRoute(
            path: '/subscriptions',
            builder: (context, state) => const SubscriptionsScreen(),
          ),
          GoRoute(
            path: '/attendances',
            builder: (context, state) => const AttendancesScreen(),
          ),
          GoRoute(
            path: '/waitlist',
            builder: (context, state) => const WaitlistScreen(),
          ),
          GoRoute(
            path: '/cancellations',
            builder: (context, state) => const CancellationsScreen(),
          ),
          GoRoute(
            path: '/profile',
            builder: (context, state) => const ProfileScreen(),
          ),
          GoRoute(
            path: '/settings',
            builder: (context, state) => const SettingsScreen(),
          ),
        ],
      ),
    ],
  );

  ref.listen<AuthState>(authProvider, (previous, next) {
    if (previous?.status != next.status) {
      router.refresh();
    }
  });

  return router;
});
