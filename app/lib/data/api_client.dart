import 'dart:async';

import 'package:cookie_jar/cookie_jar.dart';
import 'package:dio/dio.dart';
import 'package:dio_cookie_manager/dio_cookie_manager.dart';
import 'package:flutter/foundation.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../core/constants.dart';

class ApiClient {
  late final Dio dio;
  late final Dio _retryDio;
  late final PersistCookieJar cookieJar;
  bool _initialized = false;
  Completer<bool>? _reAuthCompleter;

  // Callback set by auth provider to handle unrecoverable auth failure
  void Function()? onUnauthorized;

  Future<void> init() async {
    if (_initialized) return;

    final dir = await getApplicationDocumentsDirectory();
    cookieJar = PersistCookieJar(
      storage: FileStorage('${dir.path}/.cookies/'),
    );

    dio = Dio(BaseOptions(
      baseUrl: ApiConstants.baseUrl,
      connectTimeout: const Duration(seconds: 15),
      receiveTimeout: const Duration(seconds: 15),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
    ));

    // Separate Dio for re-auth & retry (avoids interceptor loops)
    _retryDio = Dio(BaseOptions(
      baseUrl: ApiConstants.baseUrl,
      connectTimeout: const Duration(seconds: 15),
      receiveTimeout: const Duration(seconds: 15),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
    ));

    dio.interceptors.add(CookieManager(cookieJar));
    _retryDio.interceptors.add(CookieManager(cookieJar));

    // Session recovery interceptor
    dio.interceptors.add(InterceptorsWrapper(
      onRequest: (options, handler) {
        debugPrint('[API] ${options.method} ${options.uri}');
        handler.next(options);
      },
      onResponse: (response, handler) async {
        debugPrint(
            '[API] ${response.statusCode} ${response.requestOptions.uri}');

        final data = response.data;
        final path = response.requestOptions.path;

        // Skip auth endpoints to avoid loops
        if (path.contains('/auth/')) {
          return handler.next(response);
        }

        // Detect session expiry: API returns 200 with success:false + auth error
        if (data is Map<String, dynamic> &&
            data['success'] == false &&
            _isAuthError(data['error'] as String?)) {
          debugPrint('[API] Session expired, attempting silent re-login...');

          final reLoginSuccess = await _silentReLogin();
          if (reLoginSuccess) {
            debugPrint('[API] Re-login successful, retrying request...');
            try {
              final opts = response.requestOptions;
              final retryResponse = await _retryDio.request(
                opts.path,
                data: opts.data,
                queryParameters: opts.queryParameters,
                options: Options(method: opts.method),
              );
              return handler.resolve(retryResponse);
            } catch (e) {
              debugPrint('[API] Retry failed: $e');
            }
          }

          debugPrint('[API] Re-login failed, triggering unauthorized');
          onUnauthorized?.call();
        }

        handler.next(response);
      },
      onError: (error, handler) {
        debugPrint(
            '[API] ERROR ${error.response?.statusCode} ${error.requestOptions.uri}: ${error.message}');
        if (error.response?.statusCode == 401) {
          onUnauthorized?.call();
        }
        handler.next(error);
      },
    ));

    _initialized = true;
  }

  bool _isAuthError(String? error) {
    if (error == null) return false;
    final lower = error.toLowerCase();
    return lower.contains('not authenticated') ||
        lower.contains('session expired');
  }

  Future<bool> _silentReLogin() async {
    // If already re-authenticating, wait for that result
    if (_reAuthCompleter != null && !_reAuthCompleter!.isCompleted) {
      return _reAuthCompleter!.future;
    }

    _reAuthCompleter = Completer<bool>();
    try {
      final prefs = await SharedPreferences.getInstance();
      final username = prefs.getString('saved_username');
      final password = prefs.getString('saved_password');
      if (username == null ||
          password == null ||
          username.isEmpty ||
          password.isEmpty) {
        _reAuthCompleter!.complete(false);
        return false;
      }

      final response = await _retryDio.post(
        ApiConstants.login,
        data: {'username': username, 'password': password},
      );
      final data = response.data as Map<String, dynamic>;
      final success = data['success'] == true;
      _reAuthCompleter!.complete(success);
      return success;
    } catch (e) {
      debugPrint('[API] Silent re-login error: $e');
      _reAuthCompleter!.complete(false);
      return false;
    }
  }

  Future<void> clearCookies() async {
    await cookieJar.deleteAll();
  }
}
