import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest_all.dart' as tz;
import '../core/date_utils.dart' as du;
import '../data/models/booking.dart';

class NotificationService {
  static final NotificationService _instance = NotificationService._();
  factory NotificationService() => _instance;
  NotificationService._();

  final FlutterLocalNotificationsPlugin _plugin =
      FlutterLocalNotificationsPlugin();
  bool _initialized = false;

  Future<void> init() async {
    if (_initialized) return;

    tz.initializeTimeZones();

    const androidSettings =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    const iosSettings = DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );

    await _plugin.initialize(
      const InitializationSettings(
        android: androidSettings,
        iOS: iosSettings,
      ),
    );

    // Request permission on Android 13+
    await _plugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.requestNotificationsPermission();

    _initialized = true;
  }

  Future<void> scheduleBookingReminders(List<Booking> bookings) async {
    if (!_initialized) return;

    // Cancel all existing notifications first
    await _plugin.cancelAll();

    int notificationId = 0;
    final now = DateTime.now();

    for (final booking in bookings) {
      if (booking.status != 'pending') continue;

      final classTime = du.parseBookingDateTime(booking.date, booking.time);
      if (classTime == null || classTime.isBefore(now)) continue;

      // 24h before
      final time24h = classTime.subtract(const Duration(hours: 24));
      if (time24h.isAfter(now)) {
        await _scheduleNotification(
          id: notificationId++,
          title: 'Swim College',
          body: 'Tomorrow: ${booking.course} at ${booking.time.split(' ').first}',
          scheduledTime: time24h,
        );
      }

      // 1h before
      final time1h = classTime.subtract(const Duration(hours: 1));
      if (time1h.isAfter(now)) {
        await _scheduleNotification(
          id: notificationId++,
          title: 'Swim College',
          body: 'Starting soon! ${booking.course} in 1 hour',
          scheduledTime: time1h,
        );
      }
    }
  }

  Future<void> _scheduleNotification({
    required int id,
    required String title,
    required String body,
    required DateTime scheduledTime,
  }) async {
    final tzTime = tz.TZDateTime.from(scheduledTime, tz.local);

    await _plugin.zonedSchedule(
      id,
      title,
      body,
      tzTime,
      const NotificationDetails(
        android: AndroidNotificationDetails(
          'swim_college_reminders',
          'Class Reminders',
          channelDescription: 'Reminders for upcoming swim classes',
          importance: Importance.high,
          priority: Priority.high,
          icon: '@mipmap/ic_launcher',
        ),
        iOS: DarwinNotificationDetails(
          presentAlert: true,
          presentBadge: true,
          presentSound: true,
        ),
      ),
      androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
    );
  }

  Future<void> cancelAll() async {
    await _plugin.cancelAll();
  }
}
