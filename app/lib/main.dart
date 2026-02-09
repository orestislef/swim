import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'app.dart';
import 'data/api_client.dart';
import 'features/auth/auth_provider.dart';
import 'services/notification_service.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize API client with persistent cookies
  final apiClient = ApiClient();
  await apiClient.init();

  // Initialize notifications
  await NotificationService().init();

  runApp(
    ProviderScope(
      overrides: [
        apiClientProvider.overrideWithValue(apiClient),
      ],
      child: const SwimCollegeApp(),
    ),
  );
}
