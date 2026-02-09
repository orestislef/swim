import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/api_client.dart';
import '../../data/models/user.dart';
import '../../data/repositories/auth_repository.dart';
import '../../services/notification_service.dart';

enum AuthStatus { unknown, authenticated, unauthenticated }

class AuthState {
  final AuthStatus status;
  final User? user;
  final bool isLoading;
  final String? error;

  const AuthState({
    this.status = AuthStatus.unknown,
    this.user,
    this.isLoading = false,
    this.error,
  });

  AuthState copyWith({
    AuthStatus? status,
    User? user,
    bool? isLoading,
    String? error,
  }) {
    return AuthState(
      status: status ?? this.status,
      user: user ?? this.user,
      isLoading: isLoading ?? this.isLoading,
      error: error,
    );
  }
}

class AuthNotifier extends StateNotifier<AuthState> {
  final AuthRepository _authRepo;
  final ApiClient _apiClient;

  AuthNotifier(this._authRepo, this._apiClient)
      : super(const AuthState()) {
    _apiClient.onUnauthorized = _handleUnauthorized;
    checkAuth();
  }

  void _handleUnauthorized() {
    state = const AuthState(status: AuthStatus.unauthenticated);
  }

  Future<void> checkAuth() async {
    final isAuth = await _authRepo.checkAuthStatus();
    state = AuthState(
      status: isAuth ? AuthStatus.authenticated : AuthStatus.unauthenticated,
    );
  }

  Future<void> login(String username, String password) async {
    state = state.copyWith(isLoading: true, error: null);
    final result = await _authRepo.login(username, password);
    if (result.success) {
      state = AuthState(
        status: AuthStatus.authenticated,
        user: result.user,
      );
    } else {
      state = state.copyWith(
        isLoading: false,
        error: result.error,
        status: AuthStatus.unauthenticated,
      );
    }
  }

  Future<void> logout() async {
    await _authRepo.logout();
    await NotificationService().cancelAll();
    state = const AuthState(status: AuthStatus.unauthenticated);
  }
}

// Providers
final apiClientProvider = Provider<ApiClient>((ref) => ApiClient());

final authRepositoryProvider = Provider<AuthRepository>((ref) {
  return AuthRepository(ref.watch(apiClientProvider));
});

final authProvider = StateNotifierProvider<AuthNotifier, AuthState>((ref) {
  return AuthNotifier(
    ref.watch(authRepositoryProvider),
    ref.watch(apiClientProvider),
  );
});
