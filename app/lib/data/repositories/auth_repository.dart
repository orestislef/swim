import 'package:dio/dio.dart';
import '../../core/constants.dart';
import '../api_client.dart';
import '../models/user.dart';

class AuthRepository {
  final ApiClient _client;

  AuthRepository(this._client);

  Future<({bool success, User? user, String? error})> login(
      String username, String password) async {
    try {
      final response = await _client.dio.post(
        ApiConstants.login,
        data: {'username': username, 'password': password},
      );
      final data = response.data as Map<String, dynamic>;
      if (data['success'] == true) {
        final userData = data['data']?['userData'] as Map<String, dynamic>?;
        final user = userData != null ? User.fromJson(userData) : null;
        return (success: true, user: user, error: null);
      }
      return (
        success: false,
        user: null,
        error: data['error'] as String? ?? 'Login failed'
      );
    } on DioException catch (e) {
      if (e.response?.statusCode == 401) {
        return (success: false, user: null, error: 'Invalid credentials');
      }
      return (success: false, user: null, error: e.message ?? 'Connection error');
    }
  }

  Future<bool> checkAuthStatus() async {
    try {
      final response = await _client.dio.get(ApiConstants.authStatus);
      final data = response.data as Map<String, dynamic>;
      return data['authenticated'] == true;
    } catch (_) {
      return false;
    }
  }

  Future<void> logout() async {
    try {
      await _client.dio.post(ApiConstants.logout);
    } catch (_) {}
    await _client.clearCookies();
  }
}
