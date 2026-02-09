import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final connectivityProvider = StreamProvider<bool>((ref) {
  final connectivity = Connectivity();

  final controller = StreamController<bool>();

  // Check initial state
  connectivity.checkConnectivity().then((results) {
    controller.add(!results.contains(ConnectivityResult.none));
  });

  // Listen for changes
  final sub = connectivity.onConnectivityChanged.listen((results) {
    controller.add(!results.contains(ConnectivityResult.none));
  });

  ref.onDispose(() {
    sub.cancel();
    controller.close();
  });

  return controller.stream;
});
